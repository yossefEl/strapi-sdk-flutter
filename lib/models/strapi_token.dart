import 'package:jwt_decoder/jwt_decoder.dart';

class StrapiToken {
  late String _jwt;
  late Map<String, dynamic> _payload;
  late String _algorithm;
  late String _type;
  late String _issuer;
  bool _isExpired = true;
  static void init(String jwt) {
    _instance = StrapiToken._(jwt);
  }

  static late StrapiToken _instance;

  StrapiToken get instance => _instance;

  StrapiToken._(String token) {
    assert(token != '');
    _jwt = token;
    _payload = JwtDecoder.decode(_jwt);
    _algorithm = _payload['alg'];
    _type = _payload['typ'];
    _issuer = _payload['iss'];
    _isExpired = JwtDecoder.isExpired(token);
  }
  // getters
  String get jwt => _jwt;
  Map<String, dynamic> get payload => _payload;
  String get algorithm => _algorithm;
  String get type => _type;
  String get issuer => _issuer;
  bool get isExpired => _isExpired;
}
