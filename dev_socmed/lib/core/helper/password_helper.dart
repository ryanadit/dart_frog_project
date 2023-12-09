import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHelper {

  static String generatePassword(String password) {
    final passwordKey = utf8.encode(password);
    final hmacSha256 = Hmac(sha256, passwordKey); // HMAC-SHA256
    final digest = hmacSha256.convert(passwordKey);
    final passwordString = digest.toString();
    return passwordString;
  }
}
