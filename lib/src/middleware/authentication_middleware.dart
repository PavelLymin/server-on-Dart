import 'package:shelf/shelf.dart';

abstract class AuthenticationMiddleware {
  static Middleware handle() =>
      (Handler innerHandler) => (Request request) async {
        try {
          if (request.headers.containsKey('user_id')) {
            final userId = request.headers['user_id']!;

            request = request.change(
              context: {...request.context, 'user_id': userId},
            );

            return innerHandler(request);
          } else {
            return _getUnauthorizedResponse(request);
          }
        } catch (e) {
          return Response.badRequest(
            body: 'Error processing request: ${e.toString()}',
          );
        }
      };

  static Response _getUnauthorizedResponse(Request request) {
    return Response.unauthorized(
      'Request is missing user-id header: ${request.handlerPath}',
    );
  }
}
