class StrapiMeta {
  _StrapiPagination? _pagination = _StrapiPagination.empty();
  _StrapiPagination? get pagination => _pagination;

  StrapiMeta();
  StrapiMeta.fromJson(Map<String, dynamic> json) {
    _pagination =
        json.containsKey('pagination') ? _StrapiPagination.fromJson(json['pagination']) : null;
  }
}

class _StrapiPagination {
  _StrapiPagination({
    this.page = 1,
    this.pageSize = 10,
    this.pageCount = 25,
    this.total = 0,
    this.start = 0,
    this.limit = 25,
  });

  _StrapiPagination.empty() : this();

  factory _StrapiPagination.fromJson(Map<String, dynamic> json) => _StrapiPagination(
        page: json.containsKey('page') ? json["page"] : 1,
        pageSize: json.containsKey("pageSize") ? json["pageSize"] : 10,
        pageCount: json.containsKey('pageCount') ? json["pageCount"] : 25,
        total: json.containsKey('total') ? json["total"] : 0,
        start: json.containsKey('start') ? json["start"] : 0,
        limit: json.containsKey('limit') ? json["limit"] : 25,
      );

  final int page;
  final int pageSize;
  final int pageCount;
  final int total;
  final int start;
  final int limit;
}
