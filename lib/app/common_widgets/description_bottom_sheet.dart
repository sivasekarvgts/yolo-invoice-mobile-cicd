import 'package:flutter/material.dart';
import '../../locator.dart';
import '../constants/app_sizes.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

class DescriptionWidget extends StatelessWidget {
  final String fullDescription;

  const DescriptionWidget({Key? key, required this.fullDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: fullDescription,
          style: AppTextStyle.button.copyWith(
              fontWeight: fontWeight400,
              color: AppColors.greyColor,
              overflow: TextOverflow.clip),
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        if (!isOverflowing) {
          return Text(
            fullDescription,
            style: AppTextStyle.button.copyWith(
                fontWeight: fontWeight400,
                color: AppColors.greyColor,
                overflow: TextOverflow.clip),
          );
        }

        // Calculate available width for truncated text
        final showMoreSpan = TextSpan(
          text: ' ...Show more',
          style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: fontWeight500, color: AppColors.darkBlackColor),
        );
        final showMorePainter = TextPainter(
          text: showMoreSpan,
          textDirection: TextDirection.ltr,
        );
        showMorePainter.layout();

        final availableWidth = constraints.maxWidth - showMorePainter.width;
        final truncatedText =
            _getTruncatedText(fullDescription, availableWidth);

        return GestureDetector(
          onTap: () {
            dialogService.showBottomSheet(
                dismissable: true,
                showCloseIcon: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: AppTextStyle.titleLarge,
                      ),
                      gapH16,
                      Text(
                        fullDescription,
                        style: AppTextStyle.button.copyWith(
                            fontWeight: fontWeight400,
                            color: AppColors.greyColor,
                            overflow: TextOverflow.clip),
                      ),
                    ],
                  ),
                ));
          },
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.clip,
            text: TextSpan(
              style: AppTextStyle.button.copyWith(
                  fontWeight: fontWeight400,
                  color: AppColors.greyColor,
                  overflow: TextOverflow.clip),
              children: [
                TextSpan(text: truncatedText),
                showMoreSpan,
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTruncatedText(String text, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: text,
          style: AppTextStyle.button.copyWith(
              fontWeight: fontWeight400,
              color: AppColors.greyColor,
              overflow: TextOverflow.clip)),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    final positions =
        textPainter.getPositionForOffset(Offset(maxWidth, double.infinity));
    return text.substring(0, positions.offset).trimRight();
  }
}
