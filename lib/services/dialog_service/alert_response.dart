class AlertResponse {
  final String? title;
  final int? id;
  final String? subtitle;
  final bool status;
  final dynamic response;

  AlertResponse({
    this.title,
    this.id,
    this.subtitle,
    this.response,
    required this.status,
  });
}
