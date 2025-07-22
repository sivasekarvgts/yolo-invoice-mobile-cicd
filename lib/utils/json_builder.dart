mixin JsonBuilderMixin {
  Map<String, dynamic> buildJson(Map<String, dynamic> source) {
    return source..removeWhere((_, value) => value == null);
  }

  dynamic nullIfEmpty(String? value) {
    return (value == null || value.trim().isEmpty) ? null : value;
  }
}
