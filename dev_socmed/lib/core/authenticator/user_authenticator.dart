import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dev_socmed/core/helper/string_helpers.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';
import 'package:mysql_client/mysql_client.dart';

class Authenticator {
  const Authenticator(this.sqlClient);
  final MySQLClient sqlClient;

  Future<ProfileModel?> findByUsernameAndPassword({required String email, required String password, bool isDateUpdate = false}) async {
    try {
      ProfileModel? profile;
      final result = await _getUserDataByEmailAndPasswordQuery(email: email, password: password);
      if (result != null && result.rows.isNotEmpty) {
        profile = ProfileModel.fromRowAssoc(result.rows.first.assoc());
      }
      if (isDateUpdate && profile != null) {
        return await _dateUpdateForGenerateToken(
          idProfile: profile.userId ?? '', 
          user: profile.copyWith(
            updatedAt: StringHelpers.formatDate.format(DateTime.now()),
          ),
        );
      }
      return profile;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  String generateToken({
    required ProfileModel user,
  }) {
    try {
      final jwt = JWT(
      {
        'user_id': user.userId,
        'name': user.name,
        'username': user.email,
        'updated_at' : user.updatedAt,
      },
    );
    return jwt.sign(SecretKey('123'));
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }
  
  Future<ProfileModel?> verifyToken(String token) async {
    try {
      final payload = JWT.verify(
        token,
        SecretKey('123'),
      );
      final payloadData = payload.payload as Map<String, dynamic>;
      final profile = ProfileModel.fromJson(payloadData);
      return await _verifyUser(profile);
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  Future<IResultSet?> _getUserDataByEmailAndPasswordQuery({required String email, required String password}) async {
    try {
      final sqlQuery =
          '''SELECT name, created_at, updated_at, user_id, city, email, password, gender FROM ${StringHelpers.profileDbName} WHERE email = "$email" AND password = "$password"''';
      final result = await sqlClient.execute(sqlQuery);
      return result;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  Future<ProfileModel?> _verifyUser(ProfileModel user) async {
    try {
      ProfileModel? profile;
      final sqlQuery = '''SELECT * FROM ${StringHelpers.profileDbName} WHERE user_id = "${user.userId}" AND updated_at = "${user.updatedAt}"''';
      final result = await sqlClient.execute(sqlQuery);
      if (result != null && result.rows.isNotEmpty) {
        profile = ProfileModel.fromRowAssoc(result.rows.first.assoc());
      }
      return profile;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  Future<ProfileModel?> _dateUpdateForGenerateToken({required String idProfile, required ProfileModel user}) async {
    try {
      ProfileModel? profileModel;
      bool? isUpdate;
      final sqlQuery = '''
        UPDATE ${StringHelpers.profileDbName} SET updated_at = "${user.updatedAt}" WHERE user_id = "$idProfile"
      ''';
      final result = await sqlClient.execute(
        sqlQuery,
      );
      if (result != null) {
        if (result.affectedRows > BigInt.zero) {
          isUpdate = true;
        }
      }
      if (isUpdate != null && isUpdate == true) {
        final resultGet = await _getUserDataByEmailAndPasswordQuery(email: user.email ?? '', password: user.password ?? '');
        if (resultGet != null && resultGet.rows.isNotEmpty) {
          profileModel = ProfileModel.fromRowAssoc(resultGet.rows.first.assoc());
        }
      }
      return profileModel;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

}
