// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:intl/intl.dart';

class StringHelpers {
  static const String postMethod = 'post';
  static const String getMethod = 'get';
  static const String deleteMethod = 'delete';
  static const String putMethod = 'put';
  static const String profileDbName = 'profile';

  static final DateFormat formatDate = DateFormat('yyyy-MM-dd HH:mm:ss');

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),),
  );

  static String generateUserId() {
    final dateDefault = DateFormat('yyyyMMddHHmmss');
    final dateNow = dateDefault.format(DateTime.now());
    return '${getRandomString(5)}$dateNow';
  }
}
