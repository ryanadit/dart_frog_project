import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/auth_helper.dart';
import 'package:dev_socmed/feature/profile/module/datasource/profile/profile_datasource.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (await AuthHelper.tokenIsExpired(context)) {
    return AuthHelper.responseTokenIsExpired();
  }
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context, String userId) async {
  if (userId.isNotEmpty) {
    final profileRepo = context.read<ProflieDatasource>();
    final result = await profileRepo.getDetailProfile(userId);
    if (result != null) {
      return Response.json(body: result.toJsonResponse());
    } else {
      return Response.json(
        body: {
          'message' : 'User tidak ditemukan',
          'code' : HttpStatus.notFound,
        },
      );
    }
  } else {
    return Response.json(
      body: {
        'message' : 'Id harap diisi',
        'code' : HttpStatus.badRequest,
      },
    );
  }
  
}
