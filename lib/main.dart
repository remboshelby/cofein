import 'package:cofein/app/app.dart';
import 'package:cofein/app/config.dart';
import 'package:cofein/app/configs.dart';
import 'package:cofein/app/dependencies.dart';
import 'package:cofein/layers/ui/colors.dart';
import 'package:cofein/ui/cafes_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = cofienConfig();
  final configuredApp = AppConfig(
    config: config,
    // Also check UIKitPage
    child: CofeinApp(
      home: RouteMapProvider(),
    ),
  );
  await setupDependencies(config);

  runApp(configuredApp);
}

// class Test extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         color: CofeinColors.red,
//       ),
//       onTap: () {
//         Navigator.of(context).push(
//           RouteMapView.route(),
//         );
//       },
//     );
//   }
// }
