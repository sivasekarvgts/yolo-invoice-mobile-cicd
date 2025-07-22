import 'package:easy_debounce/easy_debounce.dart';

sealed class Debounce {
  const Debounce._();

  static void debounce(String tag, EasyDebounceCallback onExecute,
      [Duration duration = const Duration(milliseconds: 400)]) {
    EasyDebounce.debounce(tag, duration, () => onExecute());
  }
}
