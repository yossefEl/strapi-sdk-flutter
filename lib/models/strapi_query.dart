import 'dart:developer';

import '/helper/utils/functions.dart';
import '/helper/utils/query_generator.dart';
import '/models/strapi_file.dart';
import '/helper/enums/strapi_publication_state.dart';
import 'strapi_filter.dart';

class StrapiQuery {
  StrapiQuery.instance();
  StrapiQuery();
  StrapiQuery.params(
      {Map<String, dynamic>? filters = const {},
      String? locale,
      StrapiPublicationState publicationState = StrapiPublicationState.none,
      List<String>? fields = const [],
      List<StrapiFile>? files = const [],
      List<String>? populates = const [],
      List<String> sorts = const [],
      String? orderBy,
      Map<String, dynamic>? paginate}) {
    _filters = StrapiFilter.params(filters: filters ?? {});
    _locale = locale;
    _publicationState = publicationState;
    _fields = fields ?? [];
    _populates = populates ?? [];
    _sorts = sorts;
    _paginate = paginate;
  }
  StrapiQuery.json(Map<String, dynamic> json) {
    _makeQueryFromJson(json);
    _alreadyQuery = true;
  }
  StrapiQuery.query(String query) {
    _query = query;
    _alreadyQuery = true;
  }
  // attributes

  String _query = '';

  bool _alreadyQuery = false;
  StrapiFilter? _filters;
  String? _locale;
  StrapiPublicationState _publicationState = StrapiPublicationState.none;
  List<String> _fields = [];
  List<dynamic> _populates = [];
  List<String> _sorts = [];
  Map<String, dynamic>? _paginate;

  // getters
  StrapiFilter? get filters => _filters;
  String get locale => _locale ?? '';
  StrapiPublicationState get publicationState => _publicationState;
  List<String> get fields => _fields;
  List<dynamic> get populates => _populates;
  List<String> get sorts => _sorts;
  Map<String, dynamic> get paginate => _paginate ?? {};

  //methods
  StrapiQuery filterWith(StrapiFilter filter) {
    _filters = filter;
    return this;
  }

  StrapiQuery ofLocale(String? locale) {
    _locale = locale;
    return this;
  }

  StrapiQuery withPublicationState(StrapiPublicationState publicationState) {
    _publicationState = publicationState;
    return this;
  }

  StrapiQuery select({List<String> fields = const [], bool all = false}) {
    if (all) {
      _fields = ['*'];
    } else {
      _fields = fields;
    }
    return this;
  }

  StrapiQuery populate(dynamic populate) {
    if (populate != null) {
      if (populate is String || populate is Map) {
        _populates = [populate];
      }
      if (populate is List) {
        _populates = populate;
      }
    }
    return this;
  }

  StrapiQuery sortBy(List<String> sorts) {
    _sorts = sorts;
    return this;
  }

  StrapiQuery orderFieldBy(String field, String direction) {
    for (int i = 0; i < _sorts.length; i++) {
      if (_sorts[i].contains(field)) {
        _sorts[i] = _sorts[i].replaceAll(':asc', '').replaceAll(':desc', '').trim() +
            ':' +
            direction.replaceAll(':', '');
        break;
      }
    }
    return this;
  }

  // paginate
  StrapiQuery paginateByPage({
    int page = 1,
    int pageSize = 25,
    bool withCount = true,
  }) {
    _paginate = {'page': page, 'pageSize': pageSize, 'withCount': withCount};
    return this;
  }

  StrapiQuery paginateByOffset({
    int start = 0,
    int limit = 25,
    bool withCount = true,
  }) {
    _paginate = {'offset': start, 'limit': limit, 'withCount': withCount};
    return this;
  }

  toMap() {
    var json = {};
    if (filters != null && filters!.filters.isNotEmpty) json['filters'] = filters?.filters;
    if (locale.isNotEmpty) json['locale'] = locale;
    if (publicationState != StrapiPublicationState.none) {
      json['publicationState'] =
          publicationState == StrapiPublicationState.live ? 'live' : 'preview';
    }
    if (_fields.isNotEmpty) {
      if (_fields.contains('*')) {
        json['fields'] = '*';
      } else {
        json['fields'] = list2Map(_fields);
      }
    }
    if (_populates.isNotEmpty) {
      if (_populates.contains('*')) {
        json['populate'] = '*';
      } else {
        json['populate'] = list2Map(_populates);
      }
    }
    if (_sorts.isNotEmpty) json['sort'] = list2Map(_sorts);
    if (paginate.isNotEmpty) json['pagination'] = _paginate;
    return json;
  }

  String toQueryParams() {
    if (_alreadyQuery) return _query;
    _query = QueryGenerator.objectToQueryString(toMap());
    return _query;
  }

  _makeQueryFromJson(json) {
    _query = QueryGenerator.objectToQueryString(json, sanitize: false);
    _alreadyQuery = true;
  }
}
