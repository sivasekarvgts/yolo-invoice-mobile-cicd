import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

sealed class DateFormates {
  static final timeFormat = DateFormat("HH:mm:ss.SSS");
  static final yearMonthDayFormat = DateFormat('yyyy-MM-dd');
  static final dayMonthYearFormat = DateFormat('dd/MM/yyyy');
  static final billTimeFormat = DateFormat("h:mm aaa");
  static final billDateFormat = DateFormat("dd MMM, yyyy");
  static final ddMMMYYFormat = DateFormat("dd MMM, yy");
  static final dateMonthTimeFormat = DateFormat("dd MMM,h:mm aaa");
  static final dateMonthTimeFormat2 = DateFormat("dd MMM,hh:mm aaa");
  static final hourMinFormat = DateFormat("hh:mm aaa");
  static final monthDayYearFormat = DateFormat("MMMM dd, yyyy");
  static final dayMonthYearsFormat = DateFormat("dd MMMM, yyyy");
}

class AppDateConstant {
  static DateTime get currentDateTime => DateTime.now();
  DateTime now = DateTime.now();

  DateTime get firstDayOfMonth => DateTime(now.year, now.month, 1);

  DateTime get lastDayOfMonth => DateTime(
      now.year, now.month + 1, 0); // Day 0 of next month = last day of current

  DateTimeRange get currentMonthRange => DateTimeRange(
        start: firstDayOfMonth,
        end: lastDayOfMonth,
      );
}

extension DateTimeExtension on String {
  String toFormattedYearMonthDate() {
    DateTime dateTime = DateTime.parse(this);
    String formattedDateTime = DateFormates.yearMonthDayFormat.format(dateTime);
    return formattedDateTime;
  }

  DateTime toFormattedDateTime() {
    final formattedDateTime = DateFormates.dayMonthYearsFormat.parse(this);
    return formattedDateTime;
  }
}

extension DateTimeNullExtension on DateTime? {
  String? toFormattedYearMonthDate() {
    if (this == null) return null;
    DateTime dateTime = this!;
    String formattedDateTime = DateFormates.yearMonthDayFormat.format(dateTime);
    return formattedDateTime;
  }

  String? toFormattedDateAndTime() {
    if (this == null) return null;
    final date = this;
    final hour = date!.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minutes = date.minute.toString().padLeft(2, '0');

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${date.day} ${months[date.month - 1]}, ${date.year} at ${hour}:$minutes $period';
  }

  String? toTimeAgoLabel() {
    if (this == null) return null;
    final DateTime date = this!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(inputDate).inDays;

    if (difference == 0) {
      return 'TODAY';
    } else if (difference == 1) {
      return 'YESTERDAY';
    } else if (difference < 30) {
      return '$difference DAYS AGO';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months MONTH${months > 1 ? 's' : ''} AGO';
    } else {
      final years = (difference / 365).floor();
      return '$years YEAR${years > 1 ? 's' : ''} AGO';
    }
  }
}

extension DateRangeExtension on DateTimeRange? {
  String? toDDMMYYFormatChange() {
    if (this == null) return null;
    final range = this!;
    final isSameDate = range.duration.inDays <= 0;
    final endDate =
        isSameDate ? '' : ' - ${DateFormates.ddMMMYYFormat.format(range.end)}';
    return '${DateFormates.ddMMMYYFormat.format(range.start)} $endDate'.trim();
  }

  String? toDDMMYYToDate() {
    if (this == null) return null;
    final range = this!;
    final isSameDate = range.duration.inDays <= 0;
    final endDate =
        isSameDate ? '' : '${DateFormates.ddMMMYYFormat.format(range.end)}';
    return endDate.trim();
  }

  String? toDDMMYYFromDate() {
    if (this == null) return null;
    final range = this!;
    return DateFormates.ddMMMYYFormat.format(range.start);
  }
}

extension TimePeriodExtension on DateTime {
  FromDateToDate getFinancialYear() {
    final now = this;
    if (now.month >= 4) {
      final startDate = DateTime(now.year, 4, 1);
      final endDate = DateTime(now.year + 1, 3, 31);
      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    } else {
      final startDate = DateTime(now.year - 1, 4, 1);
      final endDate = DateTime(now.year, 3, 31);

      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    }
  }

  FromDateToDate getQuaterYear() {
    final now = this;
    if (now.month >= 4 && now.month <= 6) {
      final startDate = DateTime(now.year, 4, 1);
      final endDate = DateTime(now.year, 6, 30);
      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    } else if (now.month >= 7 && now.month <= 9) {
      final startDate = DateTime(now.year, 7, 1);
      final endDate = DateTime(now.year, 9, 30);
      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    } else if (now.month >= 10 && now.month <= 12) {
      final startDate = DateTime(now.year, 10, 1);
      final endDate = DateTime(now.year, 12, 31);
      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    } else {
      final startDate = DateTime(now.year, 1, 1);
      final endDate = DateTime(now.year, 3, 31);
      return FromDateToDate(
          startDate: DateFormates.yearMonthDayFormat.format(startDate),
          endDate: DateFormates.yearMonthDayFormat.format(endDate));
    }
  }

  FromDateToDate getThisMonth() {
    final now = this;
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month + 1, 0);
    return FromDateToDate(
        startDate: DateFormates.yearMonthDayFormat.format(startDate),
        endDate: DateFormates.yearMonthDayFormat.format(endDate));
  }
}

class FromDateToDate {
  FromDateToDate({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;
}
