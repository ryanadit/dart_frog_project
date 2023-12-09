import 'dart:io';

import 'package:dev_socmed/core/helper/string_helpers.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/profile/module/models/profile_model.dart';
import 'package:dev_socmed/feature/profile/module/repositories/profile_repository.dart';

class ProflieDatasource implements ProfileRepository {
  const ProflieDatasource(this.sqlClient);
  final MySQLClient sqlClient;

  @override
  Future<List<ProfileModel>> fetchProfile() async {
    try {
      final listProfile = <ProfileModel>[];
      const sqlQuery = 'SELECT * FROM ${StringHelpers.profileDbName}';
      // executing our sqlQuery
      final result = await sqlClient.execute(sqlQuery);
      if (result != null) {
        for (final row in result.rows) {
          listProfile.add(ProfileModel.fromRowAssoc(row.assoc()));
        }
      }
      return listProfile;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }

  @override
  Future<ProfileModel?> getDetailProfile(String idProfile) async {
    try {
      ProfileModel? profile;
      final sqlQuery = '''SELECT * FROM ${StringHelpers.profileDbName} WHERE user_id ="$idProfile"''';
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
  Future<Map<String, dynamic>> insertRegister(ProfileModel data) async {
    try {
      var objectResult = <String, dynamic>{
        'message' : 'Something Wrong',
        'code' : HttpStatus.badRequest,
      };
      const sqlQuery =
          '''INSERT INTO ${StringHelpers.profileDbName} (name, email, gender, city, created_at, updated_at, user_id, password) VALUES (:name, :email, :gender, :city, :created_at, :updated_at, :user_id, :password)''';
      final result = await sqlClient.execute(
        sqlQuery,
        params: data.toJson(),
      );
      if (result != null) {
        if (result.affectedRows > BigInt.zero) {
          objectResult = {
            'message': 'Success Register',
            'code': HttpStatus.ok,
          };
        }
      }
      return objectResult;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }
  
  @override
  Future<bool> updateProfile(ProfileModel data) async {
    try {
      var isUpdate = false;
      final sqlQuery = '''
          UPDATE ${StringHelpers.profileDbName} SET (name, email, gender, city, created_at, updated_at, password) VALUES (:name, :email, :gender, :city, :created_at, :updated_at, :password)
          WHERE user_id = ${data.userId}
        ''';
      final result = await sqlClient.execute(
        sqlQuery,
        params: data.toJson(),
      );
      if (result != null) {
        if (result.affectedRows > BigInt.zero) {
          isUpdate = true;
        }
      }
      return isUpdate;
    } catch (e) {
      throw UnimplementedError('error $e');
    }
  }
  

}
