import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';

import '../../../../../app/common_widgets/network_image_loader.dart';
import '../../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/constants/strings.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/dark_theme.dart';
import 'organization_info_controller.dart';

class OrganizationInfoView extends ConsumerStatefulWidget {
  const OrganizationInfoView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizationInfoViewState();
}

class _OrganizationInfoViewState extends ConsumerState<OrganizationInfoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(organisationInfoControllerProvider.notifier);
      await controller.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(organisationInfoControllerProvider.notifier);
    final state = ref.watch(organisationInfoControllerProvider);
    return Scaffold(
      body: state.isLoading
          ? LoadingOrgInfoShimmerTile()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.basicInfo,
                        style: AppStrings.moTabBarHeading.textStyle,
                      ),
                      gapH16,
                      OrganizationInfoCard(
                        needTail: true,
                        url: controller.organizationInfo?.logo ?? "",
                        onTap: () {},
                        title: AppStrings.photo,
                        subTitle: "",
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(thickness: 1),
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.name,
                        title: AppStrings.organizationName,
                        placeHolder: AppStrings.moWebsitePlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(thickness: 1),
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.businessTypeName,
                        title: AppStrings.businessType,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle:
                            controller.organizationInfo?.businessCategoryName,
                        title: AppStrings.businessCategory,
                        placeHolder:
                            AppStrings.moBusinessCategoryPlaceHolder.text,
                      ),
                      gapH32,
                      Text(
                        AppStrings.contactInfo,
                        style: AppStrings.moTabBarHeading.textStyle,
                      ),
                      gapH16,
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.phone,
                        title: AppStrings.phoneNumber,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.email,
                        title: AppStrings.email,
                        placeHolder: AppStrings.moEmailPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.website,
                        title: AppStrings.website,
                        placeHolder: AppStrings.moWebsitePlaceHolder.text,
                      ),
                      gapH32,
                      Text(
                        AppStrings.address,
                        style: AppStrings.moTabBarHeading.textStyle,
                      ),
                      gapH16,
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.addressDetail
                            ?.inFullAddress(),
                        title: AppStrings.shippingAddress,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.addressDetail
                            ?.inFullAddress(isShipping: false),
                        title: AppStrings.billingAddress,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      gapH32,
                      Text(
                        AppStrings.otherInfo,
                        style: AppStrings.moTabBarHeading.textStyle,
                      ),
                      gapH16,
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle:
                            "${controller.organizationInfo?.country?.emoji} ${controller.organizationInfo?.country?.name}",
                        title: AppStrings.businessLocation,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle:
                            "${controller.organizationInfo?.timeZone?.gmtOffsetName} ${controller.organizationInfo?.timeZone?.tzName} (${controller.organizationInfo?.timeZone?.zoneName})",
                        title: AppStrings.timeZone,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle:
                            "${controller.organizationInfo?.country?.currency} ${controller.organizationInfo?.country?.currencySymbol}",
                        title: AppStrings.currency,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: false,
                        onTap: () {},
                        subTitle: controller.organizationInfo?.fiscalYear,
                        title: AppStrings.fiscalYear,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: DarkTheme.customDivider,
                      ),
                      OrganizationInfoCard(
                        needTail: true,
                        onTap: () {},
                        subTitle:
                            "${controller.organizationInfo?.registrationType == 2 ? controller.organizationInfo?.registrationTypeName : ("${controller.organizationInfo?.registrationTypeName} (${controller.organizationInfo?.gstNum})")}",
                        title: AppStrings.gstStatus,
                        placeHolder: AppStrings.moPhotoPlaceHolder.text,
                      ),
                      gapH35
                    ]),
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class OrganizationInfoCard extends ConsumerStatefulWidget {
  OrganizationInfoCard(
      {super.key,
      required this.needTail,
      this.url = "",
      this.onTap,
      required this.title,
      required this.subTitle,
      required this.placeHolder});
  bool needTail = false;
  String url;
  String title;
  String? subTitle;
  String placeHolder;
  void Function()? onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizationInfoCardState();
}

class _OrganizationInfoCardState extends ConsumerState<OrganizationInfoCard> {
  @override
  Widget build(BuildContext context) {
    ref.watch(organisationInfoControllerProvider.notifier);
    ref.watch(organisationInfoControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppStrings.moCardTitle.textStyle,
              ),
              gapH4,
              if (widget.subTitle == null || widget.subTitle == "")
                Text(
                  widget.placeHolder,
                  style: AppStrings.moPhotoPlaceHolder.textStyle,
                )
              else
                Text(
                  widget.subTitle ?? "UnKnown",
                  style: AppStrings.moText.textStyle,
                ),
              gapW4
            ],
          ),
        ),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () {
              widget.onTap!();
            },
            child: widget.url != ""
                ? Stack(
                    children: [
                      NetworkImageLoader(
                        image: widget.url,
                        borderRadius: BorderRadius.circular(26),
                        height: 52,
                        width: 52,
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: Colors.black54),
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.white,
                        ),
                      )
                    ],
                  )
                : widget.needTail
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      )
                    : SizedBox(),
          ),
        )
      ],
    );
  }
}

class LoadingOrgInfoShimmerTile extends StatelessWidget {
  const LoadingOrgInfoShimmerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _card() {
      return Row(
        children: [
          ShimmerWidget.circular(
            height: 44,
            width: 44,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.text(
                height: 20.h,
                width: 250.w,
              ),
              gapH8,
              ShimmerWidget.text(
                height: 20.h,
                width: 200.w,
              ),
            ],
          ),
        ],
      );
    }

    Widget _textCard() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.text(
            height: 12.h,
            width: 100.w,
          ),
         gapH8,
          ShimmerWidget.text(
            height: 20.h,
            width: double.infinity,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH16,
            Text(
              AppStrings.basicInfo,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH16,
            _textCard(),
            gapH20,
            Divider(thickness: 1),
            gapH20,
            _textCard(),
            gapH20,
            Divider(thickness: 1),
            gapH20,
            _textCard(),
            gapH20,
            Divider(thickness: 1),
            gapH20,
            _textCard(),
            gapH20,
            Text(
              AppStrings.contactInfo,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH20,
            _textCard(),
            gapH16,
            Divider(thickness: 1),
            gapH16,
            _textCard(),
            gapH30,
            Text(
              AppStrings.address,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH16,
            _textCard(),
            gapH16,
            Divider(thickness: 1),
            gapH16,
            _textCard(),
            gapH32,
            Text(
              AppStrings.otherInfo,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH16,
            _textCard(),
            gapH16,
            Divider(thickness: 1),
            gapH16,
            _textCard(),
            gapH16,
          ],
        ),
      ),
    );
  }
}
