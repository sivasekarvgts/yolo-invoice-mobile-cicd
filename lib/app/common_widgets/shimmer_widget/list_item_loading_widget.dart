import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_ui_constants.dart';
import 'shimmer_effect.dart';

class ListItemLoadingWidget extends StatelessWidget {
  const ListItemLoadingWidget({super.key, this.noIcon = true});

  final bool noIcon;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (_, i) {
          return Container(
              decoration: AppUiConstants.salesCardItemDecoration,
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!noIcon) ShimmerWidget.rectangular(height: 40, width: 40),
                  if (!noIcon) gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.text(height: 15, width: 100),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 4,
                              children: [
                                if (!noIcon)
                                  ShimmerWidget.text(height: 10, width: 40),
                                ShimmerWidget.text(height: 15, width: 70),
                              ],
                            ),
                          ],
                        ),
                        gapH4,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.text(height: 12, width: 130),
                            ShimmerWidget.text(height: 12, width: 100),
                          ],
                        ),
                        if (noIcon) gapH8,
                        if (noIcon)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerWidget.text(height: 12, width: 80),
                              ShimmerWidget.text(height: 12, width: 100),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}
