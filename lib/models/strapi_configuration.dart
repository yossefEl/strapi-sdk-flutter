import 'package:strapi_sdk_flutter/helper/auth_storage.dart';

class StrapiConfirgutation {
  StrapiConfirgutation({
    String jwtStoreKey = 'jwt',
    Map<String, String>? headers,
  }) {
    _jwtStoreKey = jwtStoreKey;
    if (headers != null) {
      _headers = {..._headers, ...headers};
    }
  }
  late String _jwtStoreKey;

  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String get jwtStoreKey => _jwtStoreKey;
  Future<Map<String, String>> get headers async {
    final _token = await AuthStorage.instance.getToken();
    if (_token != null) {
      _headers['Authorization'] = 'Bearer ${_token.jwt}';
    }
    return _headers;
  }

  set setHeaders(Map<String, String> headers) {
    _headers = headers;
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
  }

  void removeHeader(String key) {
    _headers.remove(key);
  }
}
