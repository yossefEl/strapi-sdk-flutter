class StrapiDocument<T> {
  StrapiDocument(
      {required this.id,
      required this.attributes,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.locale,
      this.model});

  int? id;
  Map<String, dynamic> attributes;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? locale;
  T? model;

  factory StrapiDocument.fromJson(
          Map<String, dynamic> json, Function(Map<String, dynamic> json) converter) =>
      StrapiDocument(
        id: json["id"],
        attributes: json["attributes"],
        createdAt: DateTime.parse(json['attributes']['createdAt']),
        updatedAt: DateTime.parse(json['attributes']['updatedAt']),
        publishedAt: DateTime.parse(json['attributes']['publishedAt']),
        locale: json['attributes'].containsKey('locale') ? json['attributes']['locale'] : null,
        model: converter(json),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes,
      };
}
