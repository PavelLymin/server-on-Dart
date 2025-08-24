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

  final handlersWithAuth = Cascade()
      .add(container.chatHandler.router.call)
      .add(container.connectionWsHandler.router.call)
      .add(container.messageHandler.router.call)
      .add(container.connectionWsHandler.connect);

  final pipelineaWithAuth = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addMiddleware(AuthenticationMiddleware.handle())
      .addHandler(handlersWithAuth.handler);

  await serve(pipelineaWithAuth, InternetAddress.anyIPv4, 8080);
}
