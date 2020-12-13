 import 'package:cofein/layers/services/api/schemes.dart';

abstract class CafeService {
  Future<List<Cafe>> getCafeList();

  Future<CafeDetail> getCafeById(int id);
}
