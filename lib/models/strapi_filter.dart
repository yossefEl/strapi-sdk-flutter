import 'dart:convert' show json;
import '/helper/utils/functions.dart';
import '/helper/utils/query_generator.dart';

extension Operation on Map {
  insertOperation(String key, String operation, dynamic value) {
    if (this[key] == null) {
      this[key] = {};
    }
    this[key][operation] = value;
  }
}

class StrapiFilter {
  StrapiFilter() {
    _filters = {};
  }
  StrapiFilter.instance() {
    _filters = const {};
  }
  StrapiFilter.params({Map<String, dynamic> filters = const {}}) {
    _filters = filters;
  }
  StrapiFilter.query(String query) {
    _query = query;
  }

  late Map<String, dynamic> _filters;
  String _query = '';

  Map<String, dynamic> get filters => _filters;
  String get query => _query;

  // $eq	| Equal
  StrapiFilter whereEq(String field, dynamic value) {
    _filters.insertOperation(field, '\$eq', value);
    return this;
  }

  // $eqi	Equal (case-insensitive)
  StrapiFilter whereNotEqExactly(String field, dynamic value) {
    _filters.insertOperation(field, '\$eqi', value);
    return this;
  }

  // $ne	Not equal
  StrapiFilter whereNotEq(String field, dynamic value) {
    _filters.insertOperation(field, '\$ne', value);
    return this;
  }

  // $lt	Less than
  StrapiFilter whereLessThan(String field, dynamic value) {
    _filters.insertOperation(field, '\$lt', value);
    return this;
  }

  // $lte	Less than or equal to
  StrapiFilter whereLessThanOrEqualTo(String field, dynamic value) {
    _filters.insertOperation(field, '\$lte', value);
    return this;
  }

  // $gt	Greater than
  StrapiFilter whereGreaterThan(String field, dynamic value) {
    _filters.insertOperation(field, '\$gt', value);
    return this;
  }

  // $gte	Greater than or equal to
  StrapiFilter whereGreaterThanOrEqualTo(String field, dynamic value) {
    _filters.insertOperation(field, '\$gte', value);
    return this;
  }

  // $in	Included in an array
  StrapiFilter whereIn(String field, List values) {
    assert(values.isNotEmpty);
    _filters.insertOperation(field, '\$in', list2Map(values));
    return this;
  }

  // $notIn	Not included in an array
  StrapiFilter whereNotIn(String field, List values) {
    assert(values.isNotEmpty);
    _filters.insertOperation(field, '\$notIn', list2Map(values));
    return this;
  }

  // $contains	Contains
  StrapiFilter whereContains(String field, dynamic value) {
    _filters.insertOperation(field, '\$contains', value);
    return this;
  }

//  $notContains	Does not contain
  StrapiFilter whereNotContains(String field, dynamic value) {
    _filters.insertOperation(field, '\$notContains', value);
    return this;
  }

  // $containsi	Contains (case-insensitive)
  StrapiFilter whereContainsExactly(String field, dynamic value) {
    _filters.insertOperation(field, '\$containsi', value);
    return this;
  }

  // $notContainsi	Does not contain (case-insensitive)
  StrapiFilter whereNotContainsExactly(String field, dynamic value) {
    _filters.insertOperation(field, '\$notContainsi', value);
    return this;
  }

  // $null	Is null
  StrapiFilter whereNull(String field) {
    _filters.insertOperation(field, '\$null', null);
    return this;
  }

  // $notNull	Is not null
  StrapiFilter whereNotNull(String field) {
    _filters.insertOperation(field, '\$notNull', null);
    return this;
  }

  // $between	Is between
  StrapiFilter whereBetween(String field, List values) {
    assert(values.length == 2);
    _filters.insertOperation(field, '\$between', list2Map(values));
    return this;
  }

  // $startsWith	Starts with
  StrapiFilter whereStartsWith(String field, dynamic value) {
    _filters.insertOperation(field, '\$startsWith', value);
    return this;
  }

  // $endsWith	Ends with
  StrapiFilter whereEndsWith(String field, dynamic value) {
    _filters.insertOperation(field, '\$endsWith', value);
    return this;
  }

  StrapiFilter where({required String field, required dynamic value, required String op}) {
    _filters.insertOperation(field, op, value);
    return this;
  }

  // $or	Joins the filters in an "or" expression
  StrapiFilter orWithFilter(StrapiFilter filter) {
    _filters['\$or'] = filter._filters;
    return this;
  }

  // $and	Joins the filters in an "and" expression
  StrapiFilter andWithFilter(StrapiFilter filter) {
    _filters['\$and'] = filter._filters;
    return this;
  }

  toJson() {
    return json.encode(_filters);
  }

  toQueryParams() {
    return QueryGenerator.objectToQueryString({'filters': _filters});
  }
}
