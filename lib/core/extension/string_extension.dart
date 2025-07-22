extension StringExtension on String? {
  String? get capitalizeFirst {
    final value = this;
    if (value == null) return null;
    if (value == " ") return value;
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }
}
