import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => Future.value(Response.json(body: {'method GET'})),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}
