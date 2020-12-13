import 'package:cofein/app/config.dart';
import 'package:cofein/layers/di/modules/services/api.dart';
import 'package:cofein/layers/drivers/dependencies.dart';
import 'package:cofein/layers/services/api/gateway.dart';
import 'package:cofein/layers/services/pages/cafe.dart';
import 'package:cofein/layers/services/pages/impl/cafe.dart';
import 'package:get_it/get_it.dart';

Future<void> setupServicesDependencies(Config config) async {
  final sl = GetIt.instance;

  await setupApiDependencies(config);

  sl.registerFactory<CafeService>(
    () => CafeServiceImpl(
      resolveDependency<ApiGateway>(),
    ),
  );


}
