import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/auth/datasources/user_authenticator.dart';

class MiddlewareHelper {

  static Middleware authInjectionHandler() {
    return (handler) {
      return handler.use(
        provider<Authenticator>(
          (context) => Authenticator(context.read<MySQLClient>()),
        ),
      );
    };
  }

}
