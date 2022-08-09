import 'package:strapi_sdk_flutter/models/strapi_file.dart';

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
      String? paginate}) {
    _filters = StrapiFilter.params(filters: filters ?? {});
    _locale = locale;
    _publicationState = publicationState;
    _fields = fields ?? [];
    _files = files ?? [];
    _populates = populates ?? [];
    _sorts = sorts;
    _orderBy = orderBy;
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
  List<StrapiFile> _files = const [];
  List<String> _populates = [];
  List<String> _sorts = [];
  String? _orderBy = 'asc';
  String? _paginate;

  // getters
  StrapiFilter? get filters => _filters;
  String? get locale => _locale;
  StrapiPublicationState get publicationState => _publicationState;
  List<String> get fields => _fields;
  List<StrapiFile>? get files => _files;
  List<String> get populates => _populates;
  List<String> get sorts => _sorts;
  String? get orderBy => _orderBy;
  String? get paginate => _paginate;

  //methods
  StrapiQuery filterWith(StrapiFilter filter) {
    _filters = filter;
    return this;
  }

  StrapiQuery forLocale(String? locale) {
    _locale = locale;
    return this;
  }

  StrapiQuery withPublicationState(StrapiPublicationState publicationState) {
    _publicationState = publicationState;
    return this;
  }

  StrapiQuery withFields({List<String> fields = const [], bool all = false}) {
    if (all) {
      _fields = ['*'];
    } else {
      _fields = fields;
    }
    return this;
  }

  StrapiQuery withFiles({List<StrapiFile> files = const []}) {
    _files = files;
    return this;
  }

  StrapiQuery addFile(StrapiFile file) {
    _files.add(file);
    return this;
  }

  StrapiQuery removeFile(StrapiFile file) {
    _files.remove(file);
    return this;
  }

  StrapiQuery removeWithName(String name) {
    for (final file in _files) {
      if (file.name == name) {
        _files.remove(file);
      }
    }
    return this;
  }

  StrapiQuery populate(populates, {bool all = false}) {
    if (all) {
      _populates = ['*'];
    } else {
      _populates = populates;
    }
    return this;
  }

  StrapiQuery sortBy({List<String> sorts = const [], all = false}) {
    _sorts = sorts;
    return this;
  }

  // order by
  StrapiQuery orderAllBy(String order) {
    _orderBy = order;
    return this;
  }

  StrapiQuery orderFieldBy(String field, String direction) {
    _sorts.add('$field $direction');
    return this;
  }

  // paginate
  StrapiQuery paginateByPage({
    int page = 1,
    int pageSize = 25,
    bool withCount = true,
  }) {
    // pagination[page]=1&pagination[pageSize]=10
    _paginate =
        'pagination[page]=$page&pagination[pageSize]=$pageSize&pagination[withCount]=$withCount';
    return this;
  }

  StrapiQuery paginateByOffset({
    int start = 0,
    int limit = 25,
    bool withCount = true,
  }) {
    // pagination[offset]=0&pagination[limit]=10
    _paginate =
        'pagination[start]=$start&pagination[limit]=$limit&pagination[withCount]=$withCount';
    return this;
  }

  String getAsQueryParams() {
    if (_alreadyQuery) return _query;
    return _query;
  }

  _makeQueryFromJson(json) {}
}
