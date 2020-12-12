import 'package:cofein/app/config.dart';
import 'package:cofein/layers/drivers/api/dio_client.dart';
import 'package:cofein/layers/drivers/dependencies.dart';
import 'package:cofein/layers/services/api/gateway.dart';
import 'package:cofein/layers/services/api/impl/gateway.dart';
import 'package:get_it/get_it.dart';

Future<void> setupApiDependencies(Config config) async {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ApiGateway>(
    () => ApiGatewayImpl(
      resolveDependency<DioClient>(),
    ),
  );
}
