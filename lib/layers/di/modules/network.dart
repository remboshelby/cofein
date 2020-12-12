import 'package:alice/alice.dart';
import 'package:cofein/app/config.dart';
import 'package:cofein/layers/drivers/api/dio_client.dart';
import 'package:cofein/layers/drivers/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

Future<void> setupNetworkDependencies(Config config) async {
  final sl = GetIt.instance;

  final navigatorKey = GlobalKey<NavigatorState>();
  final alice = Alice(
    showNotification: true,
    navigatorKey: navigatorKey,
    darkTheme: true,
  );

  sl.registerSingleton(navigatorKey, instanceName: 'RootNavigator');

  if (config.apiLogging) {
    sl.registerSingleton(alice);
  }

  sl.registerFactory<Dio>(
    () => _createDio(config, alice),
  );

  sl.registerFactory<DioClient>(
    () => DioClient(
      resolveDependency<Dio>(),
      baseEndpoint: config.apiBaseUrl,
    ),
  );
}

Dio _createDio(Config config, Alice alice) {
  final dio = Dio();

  if (config.apiLogging) {
    dio.interceptors.add(alice.getDioInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        responseHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}
