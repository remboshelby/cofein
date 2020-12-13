import 'package:cofein/layers/services/api/gateway.dart';
import 'package:cofein/layers/services/api/schemes.dart';
import 'package:cofein/layers/services/pages/cafe.dart';

class CafeServiceImpl implements CafeService {
  final ApiGateway apiGateway;

  CafeServiceImpl(this.apiGateway);

  @override
  Future<CafeDetail> getCafeById(int id) {
    return apiGateway.getCafeById(id);
  }

  @override
  Future<List<Cafe>> getCafeList() async {
    final response = await apiGateway.getCafeList();
    return response.results;
  }
}
