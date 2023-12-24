import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/middleware_helper.dart';
import 'package:dev_socmed/core/utils/db/my_sql_client_init.dart';
import 'package:dev_socmed/feature/profile/module/datasource/profile/profile_datasource.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(injectionHandler()).use(MiddlewareHelper.authInjectionHandler());
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
