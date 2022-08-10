library query_generator;

///A simple Flutter / Dart Utility class for converting complex objects to uri and query strings
///by Joshua Opata. opatajoshua@gmail.com
class QueryGenerator {
  static Uri uri(String url, dynamic param) {
    // combine the url with the generated query string
    final urlString = "$url?${objectToQueryString(param)}";
    //create a Uri object from the urlString and return
    return Uri.parse(urlString);
  }

  /// converts a dart object to a query string
  static String objectToQueryString(dynamic json, {bool sanitize = true}) {
    //if no param we return an empty string
    if (json == null) {
      return "";
    }
    //keep the list of parameters to transform
    List<String> queries = [];
    //lets handle map params
    if (json is Map) {
      //we loop through all the map properties by their keys
      for (var key in json.keys) {
        //if property value is a nested map we call our method that handles nested maps
        if (json[key] is Map) {
          _generateInnerMap(queries, "$key", json[key]);
        }
        //if value is an array we call our method that handles inner list
        else if (json[key] is List) {
          _generateInnerList(queries, "$key", json[key]);
        }
        //else we add the string conversion for the property. eg. name=joshua
        else {
          queries.add("$key=${json[key]}");
        }
      }
    }
    //lets handle list param by calling our method that handles inner list
    else if (json is List) {
      _generateInnerList(queries, "", json);
    }
    //lets join all transformed properties as a single string and urlEncode the string
    if (sanitize) {
      return Uri.encodeFull(queries.join("&"));
    }
    return queries.join("&");
  }

  ///transforms inner map properties and adds them to the query list
  static _generateInnerMap(List<String> queryList, String parentKey, Map innerJson) {
    //loop through each map key
    for (var key in innerJson.keys) {
      // the property is another nested map we call recursive
      if (innerJson[key] is Map) {
        _generateInnerMap(queryList, "$parentKey[$key]", innerJson[key]);
      }
      // if the property is a list then we call the list transformer method
      else if (innerJson[key] is List) {
        _generateInnerList(queryList, "$parentKey[$key]", innerJson[key]);
      }
      // else we transform the primitive property and add to the query list. eg. ageRange[from]=3
      else {
        queryList.add("$parentKey[$key]=${innerJson[key]}");
      }
    }
  }

  ///transforms array properties and adds them to the query list
  static _generateInnerList(List<String> queryList, String parentKey, List<dynamic> innerList) {
    //loop through list items
    for (var item in innerList) {
      //if property is a map object we call our map object transformer
      if (item is Map) {
        _generateInnerMap(queryList, "$parentKey[]", item);
      }
      // else we transform the primitive property and add to the query list. eg. columns[]=firstName
      else {
        queryList.add("$parentKey[]=$item");
      }
    }
  }
}
