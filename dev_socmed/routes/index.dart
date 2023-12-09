import 'package:dart_frog/dart_frog.dart';
import 'package:dev_socmed/core/helper/string_helpers.dart';

Response onRequest(RequestContext context) {
  final request = context.request;
  final method = request.method.value;
  
  if (method.toLowerCase() == StringHelpers.postMethod) {
    return Response(body: 'This Is POST method');
  }
  if (method.toLowerCase() == StringHelpers.getMethod) {
    return Response(body: 'This Is GET method');
  }
  if (method.toLowerCase() == StringHelpers.deleteMethod) {
    return Response(body: 'This Is DELETE method');
  }
  if (method.toLowerCase() == StringHelpers.putMethod) {
    return Response(body: 'This Is PUT method');
  }
  return Response(body: 'This is dart_frog project');
}
