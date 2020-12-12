import 'package:cofein/layers/drivers/api/headers_signatura.dart';
import 'package:cofein/layers/drivers/execeptions/common.dart';
import 'package:cofein/layers/drivers/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';

import 'errors_handler.dart';

class DioClient {
  final Dio _dio;
  final String baseEndpoint;

  DioClient(
    this._dio, {
    @required this.baseEndpoint,
  }) : assert(baseEndpoint != null);

  Future<Options> _defaultOptions(Session session) async {
    final sign = await session.sign();

    if (sign is HeadersSignature) {
      return Options(headers: sign.headers);
    } else {
      return Options();
    }
  }

  Future<Options> _createOptions(
    Options options,
    Optional<Session> session,
  ) async {
    assert(session != null);

    if (options != null) {
      return options;
    } else if (session.isPresent) {
      return _defaultOptions(session.value);
    } else {
      return Options();
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.get(
        '$baseEndpoint$endpoint',
        options: await _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw dioErrorToApiException(e);
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.post(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw dioErrorToApiException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.patch(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw dioErrorToApiException(e);
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.put(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw dioErrorToApiException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    // ignore: avoid_annotating_with_dynamic
    dynamic data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.delete(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw dioErrorToApiException(e);
    }
  }

  Map<String, dynamic> getJsonBody<T>(Response<T> response) {
    try {
      return response.data as Map<String, dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  List<dynamic> getJsonBodyList<T>(Response<T> response) {
    try {
      return response.data as List<dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }
}
