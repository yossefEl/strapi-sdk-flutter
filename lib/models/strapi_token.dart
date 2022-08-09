import 'package:jwt_decoder/jwt_decoder.dart';

class StrapiToken {
  late String _jwt;
  late Map<String, dynamic> _payload;
  late int _userId;
  late int _issuedAtTs;
  late int _expiredAtTs;
  bool _isExpired = true;
  StrapiToken(String token) {
    assert(token != '');
    _jwt = token;
    _payload = JwtDecoder.decode(_jwt);
    _isExpired = JwtDecoder.isExpired(token);
    _userId = _payload['id'] as int;
    _issuedAtTs = _payload['iat'] as int;
    _expiredAtTs = _payload['exp'] as int;
  }

  // getters
  String get jwt => _jwt;
  Map<String, dynamic> get payload => _payload;
  bool get isExpired => _isExpired;
  int get issuedAtTs => _issuedAtTs;
  int get expiredAtTs => _expiredAtTs;
  DateTime get issuedAtDate => DateTime.fromMillisecondsSinceEpoch(_issuedAtTs*1000);
  DateTime get expiredAtDate => DateTime.fromMillisecondsSinceEpoch(_expiredAtTs*1000);
  int get userId => _userId;
}
