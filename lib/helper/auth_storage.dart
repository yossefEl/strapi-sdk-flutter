import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strapi_sdk_flutter/models/strapi_token.dart';

class AuthStorage {
  static late String _jwtStoreKey;
  AuthStorage._();
  static init(String jwtStoreKey) {
    _jwtStoreKey = jwtStoreKey;
  }

  static final AuthStorage _instance = AuthStorage._();
  static AuthStorage get instance => _instance;
  final storage = const FlutterSecureStorage();
  Future<StrapiToken?> getToken() async {
    final token = await storage.read(key: _jwtStoreKey);
    if (token == null) {
      return null;
    }
    return StrapiToken(token);
  }

  Future<void> setToken(String token) async {
    return await storage.write(key: _jwtStoreKey, value: token);
  }

  Future<void> deleteToken() async {
    return await storage.delete(key: _jwtStoreKey);
  }
}
