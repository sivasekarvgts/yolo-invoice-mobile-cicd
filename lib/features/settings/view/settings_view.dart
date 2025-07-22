import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoloworks_invoice/app/common_widgets/floating_bottom_nav_fab.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/features/auth/view/manage_organization/organization_info/organization_info_view.dart';
import 'package:yoloworks_invoice/features/settings/view/settings_controller.dart';
import 'package:yoloworks_invoice/router.dart';
import 'package:yoloworks_invoice/utils/utils.dart';

import '../../../app/common_widgets/brief_tile.dart';
import '../../../locator.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(settingsControllerProvider.notifier);
    final state = ref.watch(settingsControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          InkWell(
              onTap: controller.showLogOutConfirm,
              child: Icon(
                CupertinoIcons.power,
                color: AppColors.redColor,
              )),
          gapW16
        ],
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Divider(
              height: 1,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12.w,
            16.w,
            12.w,
            110.h,
          ),
          child: Column(
            spacing: 16.h,
            children: [
              Container(
                decoration: AppUiConstants.salesCardDecoration
                    .copyWith(borderRadius: BorderRadius.circular(14)),
                child: BriefTile(
                  onTap: null,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  trailingOnCenter: true,
                  hideDivider: true,
                  trailing: Icon(
                    CupertinoIcons.forward,
                    size: 20,
                    color: AppColors.greyColor500,
                  ),
                  title: "Santhosh",
                  subTitle: "santhosh@yoloworks.com",
                ),
              ),
              WrappedCard(
                children: [
                  SettingsCardWidget(
                      onTap: () {
                        navigationService.pushNamed(Routes.manageOrganization);
                      },
                      iconPath: Svgs.vendor,
                      subTitle: "Basic Info ,Contact Info and Address",
                      title: "Organization Profile"),
                  SettingsCardWidget(
                      onTap: () {
                        navigationService.pushNamed(Routes.selectOrganization);
                      },
                      icon: CupertinoIcons.arrow_swap,
                      subTitle: 'Change your Organization',
                      title: "Switch Organization"),
                  SettingsCardWidget(
                      onTap:null,
                      isEnabled: false,
                      subTitle: "Coming soon",
                      icon: CupertinoIcons.settings,
                      title: "Bill Settings"),
                  SettingsCardWidget(
                      onTap:null,
                      isEnabled: false,
                      subTitle: "Coming soon",
                      isLast: true,
                      icon: CupertinoIcons.house_alt,
                      title: "Branches & Warehouses"),
                ],
              ),
              if(false)  WrappedCard(children: [
                SettingsCardWidget(
                    onTap:null,
                    // isEnabled: false,
                    subTitle: "Coming soon",
                    icon: CupertinoIcons.person, title: "User"),
                SettingsCardWidget(
                    onTap:null,
                    // isEnabled: false,
                    subTitle: "Coming soon",
                    icon: CupertinoIcons.lock, title: "Role"),
                SettingsCardWidget(
                    onTap:null,
                    // isEnabled: false,
                    subTitle: "Coming soon",
                    iconPath: Svgs.billTag, title: "Taxes"),
                SettingsCardWidget(
                    onTap:null,
                    // isEnabled: false,
                    subTitle: "Coming soon",
                    icon: CupertinoIcons.money_dollar,
                    title: "Currency"),
                SettingsCardWidget(
                    isLast: true,
                    onTap:null,
                    // isEnabled: false,
                    subTitle: "Coming soon",
                    icon: CupertinoIcons.lock,
                    title: "Privacy & Security"),
              ]),
              WrappedCard(children: [
                SettingsCardWidget(
                    onTap: () {
                      String playStoreUrl = appConfigService.config.appUpdate?.android?.url??"";
                      String appStoreUrl = appConfigService.config.appUpdate?.iOS?.url??"";
                      // TODO add id
                      String link ="${playStoreUrl}&reviewId=0";
                      if(Platform.isIOS){
                        link = "${appStoreUrl}?action=write-review";
                      }
                      launchUrl(Uri.parse(link));
                    }, icon: CupertinoIcons.star, title: "Rate",subTitle: "Share your feedback",),
                SettingsCardWidget(
                    onTap: () {

                       String playStoreUrl = appConfigService.config.appUpdate?.android?.url??"";
                       String appStoreUrl = appConfigService.config.appUpdate?.iOS?.url??"";

                      SharePlus.instance.share(
                          ShareParams(
                              title: "Download Yolo Invoice app!",
                              text: 'Check out this awesome app!\n\nPlay Store: $playStoreUrl\nApp Store: $appStoreUrl')
                      );
                      }, icon: CupertinoIcons.share, title: "Share",subTitle: "Share this app to your friends and family",),
                SettingsCardWidget(
                    isLast: true,
                    onTap: () {
                      final link ="https://yoloworks.com/";
                      launchUrl(Uri.parse(link));
                    },
                    icon: CupertinoIcons.question_circle,
                  subTitle: "yoloworks.com",
                    title: "About",),
              ]),
              Center(
                child: Text(
                    'Version - ${deviceService.packageInfo?.version}+${deviceService.packageInfo?.buildNumber}',
                    style: AppTextStyle.greyFS12FW500),
              ),
              // Divider(),
              // SettingsCardWidget(onTap: (){}, icon:CupertinoIcons.power, title: "Logout"),
            ],
          ),
        ),
      ),
    );
  }
}

class WrappedCard extends StatelessWidget {
  const WrappedCard({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUiConstants.salesCardDecoration
          .copyWith(borderRadius: BorderRadius.circular(14)),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget(
      {super.key,
      required this.onTap,
      this.iconPath,
      this.subTitle,
      this.icon,
      required this.title,
      this.isLast = false,
      this.isEnabled = true,
      });
  final String title;
  final String? subTitle;
  final String? iconPath;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLast;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            gapW10,
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                color:!isEnabled?AppColors.greyColor300: AppColors.darkBlackColor,
              ),
            if (icon != null)
              Icon(
                icon,
                color:!isEnabled?AppColors.greyColor300: AppColors.darkBlackColor,
                size: 22,
              ),
            gapW20,
            Expanded(
              child: Column(
                children: [
                  gapH5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyle.darkBlackFS16FW500.copyWith(
                              color: !isEnabled?AppColors.greyColor300:null
                            ),
                          ),
                          Text(
                            subTitle??title,
                            style: AppTextStyle.greyFS14FW500
                                .copyWith(color:!isEnabled?AppColors.greyColor300: AppColors.greyColor500),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          CupertinoIcons.forward,
                          color:!isEnabled?AppColors.greyColor300: AppColors.greyColor500,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  gapH5,
                  if (!isLast)
                    Divider(
                      height: 1,
                    ),
                  if (isLast) gapH5,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
