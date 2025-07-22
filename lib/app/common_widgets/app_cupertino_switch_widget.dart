import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

class AppCupertinoSwitchWidget extends StatefulWidget {
  final bool value;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  const AppCupertinoSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<AppCupertinoSwitchWidget> createState() => _AppCupertinoSwitchWidgetState();
}

class _AppCupertinoSwitchWidgetState extends State<AppCupertinoSwitchWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.value ? AppColors.primary : Colors.grey.shade400,
        ),
        alignment:
        widget.value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Container(
            key: ValueKey(widget.value),
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
