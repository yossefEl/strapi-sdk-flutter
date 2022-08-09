import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strapi_sdk_flutter/helper/auth_storage.dart';
import 'package:strapi_sdk_flutter/models/strapi_error.dart';
import 'package:strapi_sdk_flutter/strapi_sdk_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Strapi.init(endpoint: 'https://app.nardagency.us/api');
  final strapi = Strapi.instance;
  final isLoggedin = await strapi.login(identifier: 'someone@gmail.com', password: '123456dwef');
  print(isLoggedin);
  print(strapi.error is StrapiError);
  
}
