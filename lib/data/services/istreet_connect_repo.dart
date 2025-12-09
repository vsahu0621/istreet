import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';

class IStreetConnectRepo {
  final ApiClient api = ApiClient();

  Future<dynamic> fetchConnectData() async {
    final res = await api.get(Endpoints.istreetConnect);
    return res;
  }
}
