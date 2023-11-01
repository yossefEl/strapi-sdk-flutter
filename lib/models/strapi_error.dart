class StrapiError {
  final int status;
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
        details: json["details"] ?? {},
      );

  StrapiError.fromClient({int status = 400, String name = 'general', String message = 'Something went wrong', details = const {}})
      : this(
          status: status,
          name: name,
          message: message,
          details: details,
        );

  toJson() {
    return {
      "status": status,
      "name": name,
      "message": message,
      "details": details,
    };
  }
}
