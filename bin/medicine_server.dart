import 'dart:io';
import 'package:medicine_server/src/initialization/logic/composition_root.dart';
import 'package:medicine_server/src/middleware/authentication_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main(List<String> arguments) async {
  final container = await CompositionRoot().compose();

  ProcessSignal.sigint.watch().listen((_) async {
    await container.database.close();
    exit(0);
  });

  final pipeline = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addMiddleware(AuthenticationMiddleware.handle())
      .addHandler(container.connectionWsHandler.router.call);

  final pipelineWithoutAuth = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(container.messageHandler.router.call);

  final handler = Cascade().add(pipelineWithoutAuth).add(pipeline).handler;

  await serve(handler, InternetAddress.anyIPv4, 8080);
}
