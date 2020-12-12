import 'package:cofein/layers/drivers/execeptions/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:serdes_json/annotations.dart';
import 'package:cofein/layers/drivers/json.dart';

part 'schemes.g.dart';

@SerdesJson(convertToSnakeCase: true)
class AssetsResponseScheme {
  List<String> result;
}
