import 'package:dio/dio.dart';

import 'exceptions.dart';

Exception dioErrorToApiException(DioError e) {
  switch (e.response.statusCode) {
    case 401:
      return ApiUnauthorizedException(body: e.response.data);

    case 400:
      return ApiBadRequestException(body: e.response.data);

    case 403:
      return ApiPermissionDeniedException(body: e.response.data);

    case 500:
      return ApiInternalServerException(body: e.response.data);

    default:
      return ApiException(
        statusCode: e.response.statusCode,
        body: e.response.data,
      );
  }
}
