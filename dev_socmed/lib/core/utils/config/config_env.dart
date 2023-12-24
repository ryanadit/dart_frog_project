import 'package:envied/envied.dart';

part 'config_env.g.dart';

@Envied(path: '.env', allowOptionalFields: true, useConstantCase: true)
final class ConfigEnv {

  @EnviedField(varName: 'DB_HOST')
  static const String? dbHost = _ConfigEnv.dbHost;

  @EnviedField(varName: 'DB_PORT')
  static const int? dbPort = _ConfigEnv.dbPort;
  
  @EnviedField(varName: 'DB_NAME')
  static const String? dbName = _ConfigEnv.dbName;

  @EnviedField(varName: 'DB_USERNAME')
  static const String? dbUsername = _ConfigEnv.dbUsername;

  @EnviedField(varName: 'DB_PASSWORD')
  static const String? dbPassword = _ConfigEnv.dbPassword;

  @EnviedField(varName: 'JWT_SECRET_KEY')
  static const String? jwtScreetKey = _ConfigEnv.jwtScreetKey;

}
