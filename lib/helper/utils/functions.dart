Map<dynamic, dynamic> list2Map(list) {
  Map<dynamic, dynamic> _result = {};
  if (list.isNotEmpty) {
    for (int i = 0; i < list.length; i++) {
      _result[i.toString()] = list[i] is List ? list2Map(list[i]) : list[i];
    }
  }
  return _result;
}
