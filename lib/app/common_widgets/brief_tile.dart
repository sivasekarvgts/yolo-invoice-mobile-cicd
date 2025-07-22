import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/button.dart';

import '../../features/dashboard/client/client_list_view.dart';
import '../constants/app_sizes.dart';
import '../constants/strings.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'network_image_loader.dart';

class BriefTile extends ConsumerWidget {
  const BriefTile(
      {super.key,
      required this.title,
      this.image,
      this.padding,
      this.needStatus = false,
      this.hideDivider = false,
      this.onTap,
      this.onLeadingTap,
      this.onTitle = true,
      this.trailingBackGroundColor,
      this.secondSubTitle,
      this.trailingForegroundColor,
      this.onTrailingTap,
      this.subTitle,
      this.trailing,
      this.leading,
      this.isLoading = false,
      this.trailingStatus,
      this.trailingOnCenter = false});

  final void Function()? onTap;
  final void Function()? onLeadingTap;
  final void Function()? onTrailingTap;
  final Widget? leading;
  final String title;
  final String? image;
  final String? subTitle;
  final String? secondSubTitle;
  final Widget? trailing;
  final String? trailingStatus;
  final Color? trailingForegroundColor;
  final Color? trailingBackGroundColor;
  final bool needStatus;
  final bool hideDivider;
  final bool onTitle;
  final bool trailingOnCenter;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading)
      return Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 14.h),
        child: LoadingCardShimmerTile(),
      );
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: padding ?? EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                    flex: 0,
                    child: InkWell(
                        onTap: onLeadingTap,
                        child: leading ??
                            NetworkImageLoader(
                              image: image ?? "",
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(25.r),
                              fit: BoxFit.cover,
                            ))),
                gapW10,
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              title,
                                              style: AppTextStyle.darkBlackFS16FW600,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (needStatus)
                                            Expanded(
                                              flex: 0,
                                              child: Row(
                                                children: [
                                                  gapW8,
                                                  AppButton(
                                                      height: 22,
                                                      color:
                                                          trailingBackGroundColor ??
                                                              AppColors
                                                                  .lightBlueColor,
                                                      fullSize: false,
                                                      borderColor: AppColors
                                                          .lightBlueColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                      ),
                                                      trailingStatus ??
                                                          AppStrings
                                                              .active.text,
                                                      textStyle: AppStrings
                                                          .active.textStyle
                                                          .copyWith(
                                                              color: trailingForegroundColor ??
                                                                  AppColors
                                                                      .darkBlackColor),
                                                      key: Key("activeuyee"),
                                                      onPressed: () {}),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )),
                                  if (!trailingOnCenter)
                                    Expanded(
                                        flex: 0,
                                        child: InkWell(
                                          onTap: onTrailingTap,
                                          child: trailing ??
                                              Icon(
                                                CupertinoIcons.forward,
                                              ),
                                        ))
                                ],
                              ),
                            ),
                            if (subTitle != null && subTitle != "")
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        subTitle!,
                                        style: AppTextStyle.titleSmall.copyWith(
                                            color: AppColors.greyColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (secondSubTitle != null &&
                                        secondSubTitle!.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        width: 1,
                                        height: 14,
                                        color: AppColors.greyDivider,
                                      ),
                                    if (secondSubTitle != null &&
                                        secondSubTitle!.isNotEmpty)
                                      Flexible(
                                        child: Text(
                                          secondSubTitle!,
                                          style: AppTextStyle.titleSmall
                                              .copyWith(
                                                  color: AppColors.greyColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      if (trailingOnCenter)
                        Expanded(
                            flex: 0,
                            child: InkWell(
                              onTap: onTrailingTap,
                              child: trailing ??
                                  Icon(
                                    CupertinoIcons.forward,
                                  ),
                            ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          // gapH5,
          if (!hideDivider) Divider(height: 1),
        ],
      ),
    );
  }
}
