import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';

abstract class ProfileRepository {
  Future<List<ProfileModel>> fetchProfile();
  Future<ProfileModel?> getDetailProfile(String idProfile);
  Future<Map<String, dynamic>> insertRegister(ProfileModel data);
  Future<bool> updateProfile(ProfileModel data);
}
