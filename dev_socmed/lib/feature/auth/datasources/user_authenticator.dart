import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dev_socmed/core/helper/string_helpers.dart';
import 'package:dev_socmed/core/models/jwt_token_model.dart';
import 'package:dev_socmed/core/utils/config/config_env.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/auth/models/token_model.dart';
import 'package:dev_socmed/feature/auth/repositories/auth_repository.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:uuid/uuid.dart';

class Authenticator implements AuthRepository {
  const Authenticator(this.sqlClient);
  final MySQLClient sqlClient;

  @override
  Future<ProfileModel?> findByUsernameAndPassword({required String email, required String password}) async {
    try {
      ProfileModel? profile;
      final result = await _getUserDataByEmailAndPasswordQuery(email: email, password: password);
      if (result != null && result.rows.isNotEmpty) {
        profile = ProfileModel.fromRowAssoc(result.rows.first.assoc());
      }
      return profile;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  @override
  String generateToken({
    required ProfileModel user,
    String? expiryDate,
  }) {
    try {
      final data = JwtTokenModel(
        userId: user.userId,
        name: user.name,
        email: user.email,
        expiryDate: expiryDate,
      );
      final jwt = JWT(
        data.toJson(),
      );
    return jwt.sign(SecretKey('${ConfigEnv.jwtScreetKey}'));
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }
  
  @override
  Future<JwtTokenModel?> verifyToken(String token) async {
    try {
      final payload = JWT.verify(
        token,
        SecretKey('${ConfigEnv.jwtScreetKey}'),
      );
      final payloadData = payload.payload as Map<String, dynamic>;
      final tokenData = JwtTokenModel.fromJson(payloadData);
      final profile = await _verifyUser(tokenData.userId);
      if (profile != null) {
        return tokenData;
      }
      return null;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  Future<IResultSet?> _getUserDataByEmailAndPasswordQuery({required String email, required String password}) async {
    try {
      final sqlQuery =
          '''SELECT name, created_at, updated_at, user_id, city, email, password, gender FROM ${StringHelpers.profileTableName} WHERE email = "$email" AND password = "$password"''';
      final result = await sqlClient.execute(sqlQuery);
      return result;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  Future<ProfileModel?> _verifyUser(String? userId) async {
    try {
      ProfileModel? profile;
      final sqlQuery = '''SELECT name, created_at, updated_at, user_id, city, email, gender FROM ${StringHelpers.profileTableName} WHERE user_id = "$userId"''';
      final result = await sqlClient.execute(sqlQuery);
      if (result != null && result.rows.isNotEmpty) {
        profile = ProfileModel.fromRowAssoc(result.rows.first.assoc());
      }
      return profile;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  @override
  Future<String?> createToken(TokenModel token) async {
    try {
      String? refreshToken;
      const uuid = Uuid();
      final randomToken = uuid.v4();
      const  sqlQuery = ''' INSERT INTO ${StringHelpers.tokenTableName} (userId, expiryDate, token) VALUES (:userId, :expiryDate, :token)''';
      final result = await sqlClient.execute(
        sqlQuery,
        params: token.copyWith(
          token: randomToken,
        ).toJson(),
      );
      if (result != null) {
        if (result.affectedRows > BigInt.zero) {
          refreshToken = randomToken;
        }
      }
      return refreshToken;
    }catch (err) {
      throw UnimplementedError('$err');
    }
  }
  
  @override
  Future<TokenModel?> findByRefreshToken(String token) async {
   try {
    TokenModel? refreshToken;
    final sqlQuery = ''' SELECT token, userId, expiryDate, token FROM ${StringHelpers.tokenTableName} WHERE token = "$token"''';
    final result = await sqlClient.execute(sqlQuery);
    if (result != null && result.rows.isNotEmpty) {
      refreshToken = TokenModel.fromJson(result.rows.first.assoc());
    }
    return refreshToken;
   } catch (err) {
    throw UnimplementedError('$err');
   }
  }
  
  @override
  Future<void> deleteToken(int? id) async {
    try {
      final sqlQuery = ''' DELETE FROM ${StringHelpers.tokenTableName} WHERE id = $id''';
      await sqlClient.execute(sqlQuery);
    } catch (err) {
      throw UnimplementedError('$err');
    }
  }
  
  @override
  Future<ProfileModel?> findByUserId(String userId) async {
    try {
      ProfileModel? profile;
      final sqlQuery = ''' SELECT name, created_at, updated_at, user_id, city, email, password, gender FROM ${StringHelpers.profileTableName} WHERE user_id = "$userId" ''';
      final result = await sqlClient.execute(sqlQuery);
      if (result != null && result.rows.isNotEmpty) {
        profile = ProfileModel.fromRowAssoc(result.rows.first.assoc());
      }
      return profile;
    } catch (err) {
      throw UnimplementedError('$err');
    }
  }

}
