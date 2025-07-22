import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/common_widgets/button.dart';
import '../../router.dart';
import '../../locator.dart';
import '../../app/styles/colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/constants/images.dart';
import '../../app/styles/text_styles.dart';

class OfflinePage extends ConsumerWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: PopScope(
      canPop: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SizedBox(
                    width: 250.w,
                    height: 200.h,
                    child: SvgPicture.asset(Svgs.offline))),
            gapH64,
            Text("You're Offline",
                textScaler: TextScaler.linear(1),
                style: AppTextStyle.titleMedium
                    .copyWith(color: Colors.black, fontSize: 16)),
            gapH10,
            Text('Please connect to the interent\nand try again',
                style: AppTextStyle.titleMedium
                    .copyWith(fontSize: 14, color: AppColors.greyColor),
                textAlign: TextAlign.center),
            gapH30,
            AppButton('Refresh',
                fullSize: false,
                key: ValueKey('btnretr'),
                onPressed: () =>
                    navigationService.popAllAndPushNamed(Routes.login)),
          ],
        ),
      ),
    ));
  }
}
