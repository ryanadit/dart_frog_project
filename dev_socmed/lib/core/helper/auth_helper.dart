import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/string_helpers.dart';
import 'package:dev_socmed/core/models/jwt_token_model.dart';

class AuthHelper {

  static const int durationTokenInMinute = 30;
  static const int durationRefreshTokenInHours = 24;

  static String generateExpiryDate({bool isLogin = true }) {
    final formatDate = StringHelpers.formatDate;
    final expiryDate = formatDate.format(DateTime.now().add(isLogin ? const Duration(minutes: durationTokenInMinute) : const Duration(hours: durationRefreshTokenInHours)));
    return expiryDate;
  }
  
  static Future<bool> tokenIsExpired(RequestContext context) async {
    try {
      final token = context.read<JwtTokenModel>();
      final dateUser = DateTime.parse(token.expiryDate ?? '');
      if (dateUser.difference(DateTime.now()).inMinutes < 1) {
        return true;
      }
      return false;
    } catch (err) {
      throw UnimplementedError('$err');
    }
  }

  static Response responseTokenIsExpired() {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'message' : 'Token Expired',
        'code' : HttpStatus.forbidden,
      },
    );
  }
  
}
