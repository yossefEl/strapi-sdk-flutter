class StrapiError {
  final String status;
  final String name;
  final String message;
  final Map<String, dynamic> details;
  StrapiError({
    required this.status,
    required this.name,
    required this.message,
    required this.details,
  });
  factory StrapiError.fromJson(Map<String, dynamic> json) => StrapiError(
        status: json["status"],
        name: json["name"],
        message: json["message"],
        details: json["details"],
      );
}
