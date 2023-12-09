import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/middleware_helper.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(MiddlewareHelper.authInjectionHandler());
}
