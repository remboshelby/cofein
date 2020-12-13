import 'package:cofein/layers/drivers/execeptions/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';
import 'package:serdes_json/annotations.dart';
import 'package:cofein/layers/drivers/json.dart';

part 'schemes.g.dart';

@SerdesJson(convertToSnakeCase: true)
class CafeScheme {
  int id;
  String name;
  Optional<String> description;
  double lat;
  double lon;
  bool isWifi;
  Optional<double> rating;
  double reviewCount;
  List<CoffeeImageScheme> images;
  String address;
  String startWorkTime;
  String stopWorkTime;
  String logo;
}
@SerdesJson(convertToSnakeCase: true)
class CafeDetailScheme {
  int id;
  String name;
  Optional<String> description;
  double lat;
  double lon;
  bool isWifi;
  Optional<double> rating;
  List<CoffeeImageScheme> images;
  String address;
  String startWorkTime;
  String stopWorkTime;
  String logo;
}
@SerdesJson(convertToSnakeCase: true)
class CoffeeImageScheme{
  String url;
}