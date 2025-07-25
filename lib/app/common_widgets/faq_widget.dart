// ignore_for_file: must_be_immutable

library flutter_easy_faq;

import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

final class EasyFaq extends StatefulWidget {
  final String question;
  final String answer;
  TextStyle? questionTextStyle;
  Duration? duration = const Duration(milliseconds: 100);
  Widget? expandedIcon;
  Widget? collapsedIcon;
  Color? backgroundColor;
  BorderRadiusGeometry? borderRadius;
  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  EasyFaq({
    super.key,
    required this.question,
    required this.answer,
    this.questionTextStyle,
    this.expandedIcon,
    this.collapsedIcon,
    this.duration,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  State<EasyFaq> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<EasyFaq> with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedSize(
        duration: widget.duration ??
            (isExpanded
                ? const Duration(milliseconds: 120)
                : const Duration(milliseconds: 80)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: widget.questionTextStyle ??
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                  ),
                ),
                if (isExpanded)
                  widget.expandedIcon ??
                      const Icon(
                        Icons.remove,
                        color: Color.fromRGBO(101, 101, 105, 1),
                      )
                else
                  widget.collapsedIcon ??
                      const Icon(
                        Icons.add,
                        color: Color.fromRGBO(101, 101, 105, 1),
                      ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Text(
                widget.answer,
                style: AppTextStyle.bodyMedium
                    .copyWith(color: AppColors.greyColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
