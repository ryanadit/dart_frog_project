import 'package:dev_socmed/core/models/jwt_token_model.dart';
import 'package:dev_socmed/feature/auth/models/token_model.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';

abstract class AuthRepository {
  Future<ProfileModel?> findByUsernameAndPassword({required String email, required String password});
  String generateToken({required ProfileModel user,});
  Future<JwtTokenModel?> verifyToken(String token);
  Future<String?> createToken(TokenModel token);
  Future<TokenModel?> findByRefreshToken(String token);
  Future<void> deleteToken(int? id);
  Future<ProfileModel?> findByUserId(String userId);
}
