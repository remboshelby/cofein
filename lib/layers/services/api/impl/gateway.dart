import 'package:cofein/layers/drivers/api/dio_client.dart';
import 'package:cofein/layers/services/api/gateway.dart';

class ApiGatewayImpl implements ApiGateway {
  final DioClient _client;

  ApiGatewayImpl(
    this._client,
  );
}
