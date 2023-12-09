import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/password_helper.dart';
import 'package:dev_socmed/core/helper/string_helpers.dart';
import 'package:dev_socmed/feature/profile/module/datasource/profile/profile_datasource.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post ) {
    if ((await context.request.body()).isNotEmpty) {
      final bodyParam = await context.request.json() as Map<String, dynamic>;
      return _onRegister(context, bodyParam);
    } else {
      return Response.json(body: {
        'message' : 'Parameter is empty',
        'code' : HttpStatus.badRequest,
      }, statusCode: HttpStatus.badRequest,);
    }
  } else {
    return Response.json(body: {
      'message' : 'Method Not Allowed',
      'code' : HttpStatus.methodNotAllowed,
    }, statusCode: HttpStatus.methodNotAllowed,);
  }
}

Future<Response> _onRegister(RequestContext context, Map<String, dynamic> bodyParam) async {
  if (bodyParam.isNotEmpty) {
    final profileDatasource = context.read<ProflieDatasource>();
    final param = ProfileModel.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );
    if ((param.password ?? '').length >= 8) {
      final dateDefault = StringHelpers.formatDate;
      final result = await profileDatasource.insertRegister(
        param.copyWith(
          userId: StringHelpers.generateUserId(),
          password: PasswordHelper.generatePassword(param.password ?? ''),
          createdAt: dateDefault.format(DateTime.now()),
          updatedAt: dateDefault.format(DateTime.now()),
        ),
      );
      return Response.json(body: result);
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
    return Response.json(
      body: {
        'message': 'Harap semua data diisi',
        'code': HttpStatus.noContent,
      },
      statusCode: HttpStatus.noContent,
    );
  }
}
