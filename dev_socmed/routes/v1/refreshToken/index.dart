import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/feature/auth/datasources/user_authenticator.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onGet(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  if ((await context.request.body()).isNotEmpty) {
    final authRepo = context.read<Authenticator>();
    final param = await context.request.json() as Map<String, dynamic>;
    final token = param['refreshToken'];
    if (token != null && token is String) {
      final refreshToken = await authRepo.findByRefreshToken(token);
      if (refreshToken != null) {
        final user = await authRepo.findByUserId(refreshToken.userId ?? '');
        if (user != null) {
          if (DateTime.parse(refreshToken.expiryDate ?? '').difference(DateTime.now()).inMinutes < 1) {
            await authRepo.deleteToken(refreshToken.id);
            return Response.json(body: {
              'message' : 'Refresh token was expired. Please make a new signin request',
              'code' : HttpStatus.forbidden,
            }, statusCode: HttpStatus.forbidden,);
          } else {
            final accessToken = authRepo.generateToken(user: user, expiryDate: refreshToken.expiryDate);
            return Response.json(
              body: {
                'token' : accessToken,
                'refreshToken' : refreshToken.token,
              },
            );
          }
        } else {
          return Response.json(body: {
            'message' : 'User not found!',
            'code' : HttpStatus.forbidden,
          }, statusCode: HttpStatus.forbidden,);
        }
      } else {
        return Response.json(body: {
          'message' : 'Refresh token is not in database!',
          'code' : HttpStatus.forbidden,
        }, statusCode: HttpStatus.forbidden,);
      }
    } else {
      return Response.json(body: {
        'message' : 'Refresh token is empty',
        'code' : HttpStatus.forbidden,
      }, statusCode: HttpStatus.forbidden,);
    }
    
  } else {
    return Response.json(body: {
      'message' : 'Parameter is empty',
      'code' : HttpStatus.badRequest,
    }, statusCode: HttpStatus.badRequest,);
  }
}
