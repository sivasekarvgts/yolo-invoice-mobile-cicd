import 'package:flutter/material.dart';

import '../locator.dart';

sealed class DatePickerService {
  static Future<DateTimeRange?> pickDateRange(
      DateTimeRange? selectedDateRange) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: navigationService.navigatorKey.currentContext!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: selectedDateRange,
    );
    return picked;
  }

  static Future datePicker({
    required DateTime firstDate,
    required DateTime initialDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: navigationService.navigatorKey.currentContext!,
      firstDate: firstDate,
      initialDate: initialDate,
      lastDate: lastDate ?? DateTime(2101),
    );
  }
}
