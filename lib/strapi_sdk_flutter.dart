library strapi_sdk_flutter;

import 'dart:convert';
import 'package:strapi_sdk_flutter/helper/auth_storage.dart';
import 'package:strapi_sdk_flutter/models/strapi_error.dart';
import 'package:strapi_sdk_flutter/models/strapi_token.dart';
import 'models/strapi_base_user.dart';
import 'models/strapi_configuration.dart';
import 'models/strapi_query.dart';
import 'package:http/http.dart' as http;
export 'models/strapi_error.dart';
export 'models/strapi_token.dart';
export 'models/strapi_base_user.dart';
export 'models/strapi_configuration.dart';
export 'models/strapi_query.dart';
export 'models/strapi_meta.dart';
export 'models/strapi_filter.dart';

//TO be upgraded
class Strapi {
  Strapi._(String endpoint, String? apiToken, {StrapiConfirgutation? confirgutation}) {
    _endpoint = endpoint;
    _apiToken = apiToken;
    _confirgutation = confirgutation ?? StrapiConfirgutation();
    AuthStorage.init(_confirgutation.jwtStoreKey);
  }

  static late Strapi _strapi;

  static Strapi get instance {
    return _strapi;
  }

  static Future<void> init({required String endpoint, String? apiToken, StrapiConfirgutation? confirgutation}) async {
    assert(endpoint != '');
    if (endpoint.endsWith('/')) {
      endpoint = endpoint.substring(0, endpoint.length - 1);
    }
    _endpoint = endpoint;
    _apiToken = apiToken;
    _strapi = Strapi._(_endpoint, apiToken, confirgutation: confirgutation ?? StrapiConfirgutation());
    instance.fetchUser();
  }

  static late String _endpoint;
  static String? _apiToken;
  StrapiConfirgutation _confirgutation = StrapiConfirgutation();
  StrapiQuery query = StrapiQuery.instance();
  StrapiError? _error;
  static StrapiUser? _user;
  http.Response _response = http.Response('{}', 400);

  // getters
  String get endpoint => _endpoint;
  String? get apiToken => _apiToken;
  StrapiConfirgutation get confirgutation => _confirgutation;
  StrapiError? get error => _error;
  StrapiUser? get user => _user;
  bool get isLogged => _user != null;
  http.Client get client => http.Client();
  http.Response get response => _response;

  //methos
  Uri __getEndpoint(String collection, {String? documentId, StrapiQuery? query}) {
    String _url = '$_endpoint/$collection';
    if (documentId != null) {
      _url = '$_url/$documentId';
    }
    if (query != null) {
      _url = '$_url?${query.toQueryParams()}';
    }
    return Uri.parse(_url);
  }

  void hanldeError(http.Response response) {
    final _json = json.decode(response.body);
    try {
      if (_json is Map && _json.containsKey('error')) {
        _error = StrapiError.fromJson(_json['error']);
      } else {
        _error = null;
      }
    } catch (e) {
      _error = StrapiError.fromClient();
    }
  }

  void _init() {
    _error = null;
    _response = http.Response('{}', 400);
    query = StrapiQuery.instance();
  }

  Future request(method, String url, [successStatusCode = 200, fields = const {}, files = const [], headers = const {}]) async {
    try {
      _init();
      http.StreamedResponse? response;
      final request = http.MultipartRequest("POST", Uri.parse(url));
      request.fields.addAll(fields);
      request.headers.addAll(headers);
      for (final file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          file['name'],
          file['path'],
        ));
      }
      response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      if (response.statusCode == successStatusCode) {
        return jsonData;
      } else {
        throw (jsonData);
      }
    } catch (e) {
      rethrow;
    }
  }

//  CRUD methods
  // find
  Future<List<T>?>? find<T>(collection, {StrapiQuery? query, required T Function(Map<String, dynamic> json) converter}) async {
    _init();
    final Uri url = __getEndpoint(collection, query: query);
    final headers = await _confirgutation.headers;
    _response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      if (decodedJson is Map && decodedJson.containsKey('data')) {
        List<T> _result = <T>[];
        for (final item in decodedJson['data']) {
          _result.add(converter(item));
        }
        return _result;
      }
      return <T>[];
    }
    hanldeError(response);
    return null;
  }

  // find One
  Future<T?> findOne<T>(collection, {String? documentId, required T Function(Map<String, dynamic> json) converter}) async {
    _init();
    final Uri url = __getEndpoint(collection, documentId: documentId);
    _response = await http.get(url, headers: await _confirgutation.headers);
    if (response.statusCode == 200) {
      return converter(json.decode(response.body));
    }
    hanldeError(response);
    return null;
  }

  // create
  Future<T?> create<T>(String collection, {Map<String, dynamic>? data, T Function(Map<String, dynamic> json)? converter}) async {
    _init();
    final Uri url = __getEndpoint(collection);

    _response = await http.post(
      url,
      body: json.encode(data),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 201) {
      if (converter != null) {
        return converter(json.decode(response.body));
      }
      return null;
    }
    hanldeError(response);
    return null;
  }

  // update
  Future<T?> update<T>(String collection, String documentId,
      {Map<String, dynamic>? data, required T Function(Map<String, dynamic> json) converter}) async {
    _init();
    final Uri url = __getEndpoint(collection, documentId: documentId);
    _response = await http.put(
      url,
      body: json.encode(data),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      return converter(json.decode(response.body));
    }
    hanldeError(response);
    return null;
  }

  // delete
  Future<bool> delete(String collection, String documentId) async {
    _init();
    final Uri url = __getEndpoint(collection, documentId: documentId);
    _response = await http.delete(
      url,
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      return true;
    }
    hanldeError(response);
    return false;
  }

  // register : registers a user and sets the token
  Future<bool> register(String email, String password) async {
    _init();
    final Uri url = Uri.parse('$_endpoint/auth/local/register');
    _response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('jwt')) {
        await AuthStorage.instance.setToken(jsonData['jwt']);
        _user = StrapiUser.fromJson(jsonData['user']);
        return true;
      }
    }
    hanldeError(response);
    return false;
  }

  // login
  Future<bool> login({required String identifier, required String password}) async {
    _init();
    final Uri url = Uri.parse('$_endpoint/auth/local');
    _response = await http.post(
      url,
      body: json.encode({
        'identifier': identifier,
        'password': password,
      }),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('jwt')) {
        await AuthStorage.instance.setToken(jsonData['jwt']);
        _user = StrapiUser.fromJson(jsonData['user']);
        return true;
      }
    }
    hanldeError(response);
    return false;
  }

  // forgotPassword
  Future<bool> forgotPassword({required String email}) async {
    _init();
    final Uri url = Uri.parse('$_endpoint/auth/forgot-password');
    _response = await http.post(
      url,
      body: json.encode({
        'email': email,
      }),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      return true;
    }
    hanldeError(response);
    return false;
  }

  // resetPassword
  Future<bool> resetPassword({required String code, required String password, required String passwordConfirmation}) async {
    _init();
    final Uri url = Uri.parse('$_endpoint/auth/reset-password');
    _response = await http.post(
      url,
      body: json.encode({
        'code': code,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      }),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      return true;
    }
    hanldeError(response);
    return false;
  }

  // sendEmailConfirmation
  Future<bool> sendEmailConfirmation({required String email, required String confirmationUrl}) async {
    _init();
    final Uri url = Uri.parse('$_endpoint/auth/email-confirmation');
    _response = await http.post(
      url,
      body: json.encode({
        'email': email,
      }),
      headers: await _confirgutation.headers,
    );
    if (response.statusCode == 200) {
      return true;
    }
    hanldeError(response);
    return false;
  }

  // getProviderAuthenticationUrl

  String getProviderAuthenticationUrl({required String provider}) {
    return '$_endpoint/connect/$provider';
  }

  //logout
  Future<bool> logout() async {
    _init();
    await AuthStorage.instance.deleteToken();
    _user = null;
    _confirgutation.setHeaders = await _confirgutation.headers
      ..remove('Authorization');
    return true;
  }

  // fetchUser
  Future<bool> fetchUser({String? populates}) async {
    _init();
    String __url = '$_endpoint/users/me';
    if (populates != null) {
      __url += '?populate=$populates';
    }
    final Uri url = Uri.parse(
      __url,
    );

    final header = await _confirgutation.headers;
    _response = await http.get(
      url,
      headers: header,
    );
    if (response.statusCode == 200) {
      final _json = json.decode(response.body);
      _user = StrapiUser.fromJson(_json);
      return true;
    }
    hanldeError(response);
    return false;
  }

  set setUser(StrapiUser user) {
    _user = user;
  }

  //getToken
  Future<StrapiToken?> getToken() async {
    return await AuthStorage.instance.getToken();
  }

  // strapi.setToken(token);/
  Future<bool> setToken(String token) async {
    try {
      await AuthStorage.instance.setToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  //removeToken
  Future<bool> removeToken() async {
    try {
      await AuthStorage.instance.deleteToken();
      return true;
    } catch (e) {
      return false;
    }
  }
}
