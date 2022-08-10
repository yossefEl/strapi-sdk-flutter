import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strapi_sdk_flutter/models/strapi_filter.dart';
import 'package:strapi_sdk_flutter/strapi_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Strapi.init(endpoint: 'https://app.nardagency.us/api');
  final strapi = Strapi.instance;
  test('test 1: is API initialized', () {
    expect(strapi.confirgutation.jwtStoreKey, 'jwt');
    expect(strapi.endpoint, 'https://app.nardagency.us/api');
  });
  test('test 2: Filters', () {
    final filter = StrapiQuery.params(filters: {'id': 1}, sorts: ['title', 'id:asc'])
        .orderFieldBy('title', 'desc');
    expect(Uri.decodeComponent(filter.toQueryParams()),
        'filters[id]=1&sort[0]=title:desc&sort[1]=id:asc');
  });
  test('test 2: populate', () {
    final filter = StrapiQuery().populate([
      'avatar',
      {
        'author': {
          'populate': ['company'],
        }
      }
    ]);
    expect(Uri.decodeComponent(filter.toQueryParams()),
        'populate[0]=avatar&populate[1][author][populate][0]=company');
  });
}
