import 'package:strapi_sdk_flutter/helper/auth_storage.dart';

class StrapiConfirgutation {
  StrapiConfirgutation({
    String jwtStoreKey = 'jwt',
    Map<String, String> headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  }) {
    _jwtStoreKey = jwtStoreKey;
    _headers = headers;
  }
  late String _jwtStoreKey;
  late Map<String, String> _headers;

  String get jwtStoreKey => _jwtStoreKey;
  Future<Map<String, String>> get headers async {
    final _jwt = await AuthStorage.instance.getToken();
    if (_jwt != null) {
      _headers['Authorization'] = 'Bearer $_jwt';
    }
    return _headers;
  }
}
