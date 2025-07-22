import 'package:flutter/material.dart';

import '../../styles/text_styles.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key, this.errorText});
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    if (errorText == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Text(
        errorText!,
        style: AppTextStyle.redFS12FW500,
      ),
    );
  }
}
