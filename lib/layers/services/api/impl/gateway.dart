import 'package:cofein/layers/drivers/api/dio_client.dart';
import 'package:cofein/layers/services/api/gateway.dart';
import 'package:cofein/layers/services/api/page.dart';
import 'package:cofein/layers/services/api/schemes.dart';

class ApiGatewayImpl implements ApiGateway {
  final DioClient _client;

  ApiGatewayImpl(
    this._client,
  );

  @override
  Future<CafeDetail> getCafeById(int id) async {

    final response = await _client.get(
      '/CafeDetail/?id=$id',
    );
    return CafeDetail.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<Page<Cafe>> getCafeList() async {
    final response = await _client.get(
      '/CafeView'
    );
    return Page.fromJson(
        _client.getJsonBody(response), (it) => Cafe.fromJson(it));
  }
}
