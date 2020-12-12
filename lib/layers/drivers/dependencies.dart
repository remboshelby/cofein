import 'package:get_it/get_it.dart';

T resolveDependency<T>({String instanceName}) =>
    GetIt.instance.get<T>(instanceName: instanceName);
