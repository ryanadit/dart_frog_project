// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/index.dart' as index;
import '../routes/v1/index.dart' as v1_index;
import '../routes/v1/register/index.dart' as v1_register_index;
import '../routes/v1/refreshToken/index.dart' as v1_refresh_token_index;
import '../routes/v1/profile/index.dart' as v1_profile_index;
import '../routes/v1/profile/[id].dart' as v1_profile_$id;
import '../routes/v1/login/index.dart' as v1_login_index;

import '../routes/v1/_middleware.dart' as v1_middleware;
import '../routes/v1/register/_middleware.dart' as v1_register_middleware;
import '../routes/v1/refreshToken/_middleware.dart' as v1_refresh_token_middleware;
import '../routes/v1/profile/_middleware.dart' as v1_profile_middleware;
import '../routes/v1/login/_middleware.dart' as v1_login_middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8081') ?? 8081;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return entrypoint.run(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/v1/login', (context) => buildV1LoginHandler()(context))
    ..mount('/v1/profile', (context) => buildV1ProfileHandler()(context))
    ..mount('/v1/refreshToken', (context) => buildV1RefreshTokenHandler()(context))
    ..mount('/v1/register', (context) => buildV1RegisterHandler()(context))
    ..mount('/v1', (context) => buildV1Handler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildV1LoginHandler() {
  final pipeline = const Pipeline().addMiddleware(v1_middleware.middleware).addMiddleware(v1_login_middleware.middleware);
  final router = Router()
    ..all('/', (context) => v1_login_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildV1ProfileHandler() {
  final pipeline = const Pipeline().addMiddleware(v1_middleware.middleware).addMiddleware(v1_profile_middleware.middleware);
  final router = Router()
    ..all('/', (context) => v1_profile_index.onRequest(context,))..all('/<id>', (context,id,) => v1_profile_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildV1RefreshTokenHandler() {
  final pipeline = const Pipeline().addMiddleware(v1_middleware.middleware).addMiddleware(v1_refresh_token_middleware.middleware);
  final router = Router()
    ..all('/', (context) => v1_refresh_token_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildV1RegisterHandler() {
  final pipeline = const Pipeline().addMiddleware(v1_middleware.middleware).addMiddleware(v1_register_middleware.middleware);
  final router = Router()
    ..all('/', (context) => v1_register_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildV1Handler() {
  final pipeline = const Pipeline().addMiddleware(v1_middleware.middleware);
  final router = Router()
    ..all('/', (context) => v1_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

