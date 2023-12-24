import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dev_socmed/core/helper/middleware_helper.dart';
import 'package:dev_socmed/core/models/jwt_token_model.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/auth/datasources/user_authenticator.dart';
import 'package:dev_socmed/feature/profile/module/datasource/profile/profile_datasource.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(MiddlewareHelper.authInjectionHandler()).use(injectionHandler()).use(
    bearerAuthentication<JwtTokenModel>(
      authenticator: (context, token) async {
        final authenticator = Authenticator(context.read<MySQLClient>());
        return authenticator.verifyToken(token);
      },
    ),
  );
}

Middleware injectionHandler() {
  return (handler) {
    return handler.use(
      provider<ProflieDatasource>(
        (context) => ProflieDatasource(context.read<MySQLClient>()),
      ),
    );
  };
}
