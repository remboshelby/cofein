import 'package:cofein/app/config.dart';
import 'package:cofein/layers/di/modules/network.dart';
import 'package:cofein/layers/di/modules/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

Future<void> setupDependencies(Config config) async {
  final sl = GetIt.instance;
  sl.registerSingleton<Config>(config);

  await setupNetworkDependencies(config);
  await setupServicesDependencies(config);
}

NavigatorState rootNavigator() => GetIt.instance
    .get<GlobalKey<NavigatorState>>(instanceName: 'RootNavigator')
    .currentState;