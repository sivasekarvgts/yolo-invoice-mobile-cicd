import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/constants/app_sizes.dart';
import '../../app/constants/images.dart';
import '../../app/styles/text_styles.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 250, child: SvgPicture.asset(Svgs.pageNotFound)),
          gapH20,
          Text("Hmm...",
              textScaler: TextScaler.linear(1),
              style: AppTextStyle.titleMedium
                  .copyWith(color: Colors.black, fontSize: 16)),
          gapH10,
          Text('Page Not Found',
              style: AppTextStyle.titleMedium.copyWith(fontSize: 14),
              textAlign: TextAlign.center),
          gapH20,
        ],
      ),
    ));
  }
}
