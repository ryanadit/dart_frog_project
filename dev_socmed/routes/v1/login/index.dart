import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/auth_helper.dart';
import 'package:dev_socmed/core/helper/password_helper.dart';
import 'package:dev_socmed/feature/auth/datasources/user_authenticator.dart';
import 'package:dev_socmed/feature/auth/models/token_model.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onPost(RequestContext context) async {
  if ((await context.request.body()).isNotEmpty) {
    final authRepo = context.read<Authenticator>();
    final param = ProfileModel.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );
    if ((param.password ?? '').isEmpty || (param.email ?? '').isEmpty) {
      return Response.json(
        body: {
          'message': 'Password atau Email tidak boleh kosong',
          'code': HttpStatus.notAcceptable,
        },
        statusCode: HttpStatus.notAcceptable,
      );
    } else if ((param.password ?? '').length >= 8) {
      final result = await authRepo.findByUsernameAndPassword(email: param.email ?? '', password: PasswordHelper.generatePassword(param.password ?? ''));
      if (result != null) {
        final expiryDate = AuthHelper.generateExpiryDate();
        final token = authRepo.generateToken(user: result, expiryDate: expiryDate);
        final tokenData = TokenModel(
          userId: result.userId,
          expiryDate: AuthHelper.generateExpiryDate(isLogin: false),
        );
        final refreshToken = await authRepo.createToken(tokenData);
        if (refreshToken != null) {
          return Response.json(
            body: {
              'data' : result.toJsonResponse(),
              'token' : token,
              'refreshToken' : refreshToken,
            },
          );
        } else {
          return Response.json(
            body: {
              'message': 'Something wrong',
              'code': HttpStatus.forbidden,
            },
            statusCode: HttpStatus.forbidden,
          );
        }
      } else {
        return Response.json(statusCode: HttpStatus.notFound, body: {
          'message' : 'Email atau password salah',
          'code' : HttpStatus.notFound,
        },);
      }
    } else {
      return Response.json(
        body: {
          'message': 'Password Minimal 8 Karakter',
          'code': HttpStatus.notAcceptable,
        },
        statusCode: HttpStatus.notAcceptable,
      );
    }
  } else {
    return Response.json(body: {
      'message' : 'Parameter is empty',
      'code' : HttpStatus.badRequest,
    }, statusCode: HttpStatus.badRequest,);
  }
}
