import 'package:strapi_sdk_flutter/models/strapi_query.dart';

void main(List<String> args) {
  final query = StrapiQuery().populate({
    'company': {'populate': 'name'}
  });
  print(Uri.decodeComponent(query.toQueryParams()));
}
