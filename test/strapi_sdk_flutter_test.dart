import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strapi_sdk_flutter/helper/auth_storage.dart';
import 'package:strapi_sdk_flutter/models/strapi_error.dart';
import 'package:strapi_sdk_flutter/strapi_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Strapi.init(endpoint: 'https://app.nardagency.us/api');
  final strapi = Strapi.instance;
  test('test 1: is API initialized', () async {
    expect(strapi.confirgutation.jwtStoreKey, 'jwt');
    expect(strapi.endpoint, 'https://app.nardagency.us/api');
  });
  test('test 2: login', () async {
    final isLoggedin = await strapi.login(identifier: 'someone@gmail.com', password: '123456dwef');
    expect(isLoggedin, false);
    expect(strapi.error is StrapiError, true);
  });
}
