import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/features/dashboard/view/widgets/customizable_links_controller.dart';
import 'package:yoloworks_invoice/services/dialog_service/alert_response.dart';

import '../../../../app/common_widgets/button.dart';
import '../../../../app/constants/images.dart';
import '../../../../app/styles/colors.dart';
import '../../../../locator.dart';
import '../dashboard_controller.dart';
import 'customizable_card_widget.dart';

class CustomizableLinksPage extends ConsumerStatefulWidget {
  const CustomizableLinksPage({super.key});

  @override
  ConsumerState createState() => _CustomizableLinksPageState();
}

class _CustomizableLinksPageState extends ConsumerState<CustomizableLinksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(customizableLinksControllerProvider.notifier);
      controller.onInit();
    });
  }



  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customizableLinksControllerProvider.notifier);
    final state = ref.watch(customizableLinksControllerProvider);
    final List<QuickLickModel> quickLinks = controller.allQuickLinks;
    final sortedLinks =(quickLinks.where((element) => element.enabled == true,).toList());
    return SizedBox(
      height: MediaQuery.of(context).size.height-kBottomNavigationBarHeight-kToolbarHeight,
      child: Column(
        children: [
          gapH15,
          Row(
            children: [
              gapW10,
              SvgPicture.asset(Svgs.quickLink),
              gapW12,
              Text(
                "Quick Links",
                style: AppTextStyle.blackFS16FW600,
              ),
              Spacer(),
              InkWell(
                  onTap: (){
                    dialogService.dialogComplete(AlertResponse(status: false));
                  },
                  child: Icon(CupertinoIcons.xmark_circle,color: Colors.black87,)), gapW16,
            ],
          ),
          Spacer(),
          IgnorePointer(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: AppUiConstants.salesCardDecoration.copyWith(color: AppColors.scaffoldBackground),
                width: MediaQuery.of(context).size.width*.95,
                child: CustomizableCardWidget(quickLinkCard: sortedLinks)),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  "Select any 4 modules",
                  style: AppTextStyle.darkBlackFS14FW500,
                ),
              ),Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.onClearAll,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Clear All",
                      style: AppTextStyle.darkBlackFS14FW500.copyWith(color: AppColors.redColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          gapH8,
          Container(
            height: MediaQuery.of(context).size.height*.5,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16),),
            ),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              physics: ClampingScrollPhysics(),
              itemCount: quickLinks.length,
              separatorBuilder: (context, index) => gapH8,
              itemBuilder: (context, index) {
                final data = quickLinks[index];
                return Container(
                  decoration:!data.enabled? null:AppUiConstants.salesCardItemDecoration.copyWith(border: Border.all(color: AppColors.primary.withOpacityValue(.3))),
                  child: InkWell(
                    onTap: () {
                      controller.onSelect(index);
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r)
                                ,color: AppColors.scaffoldBackground
                          ),
                          child: SvgPicture.asset(
                            data.image,
                           height: 20,
                            color: Colors.black,
                          ),
                        ),
                        gapW15,
                        Text(
                          data.name,
                          style: AppTextStyle.bodyMedium,
                        ),
                        Spacer(),
                        if (!data.enabled)
                          Icon(
                            Icons.radio_button_off,
                            color: AppColors.greyColor,
                          )
                        else
                          Icon(
                            Icons.radio_button_on,
                            color: AppColors.primary,
                          ),
                        gapW8,
                      ],
                    ),
                  ),
                );
              },),
          ),
          Divider(),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(child: Text("${controller.quickLinks.length}/4  Selected")),
                Expanded(
                  child: AppButton(
                    key: Key("save_custom"),
                  'Save',
                    height: 35.h,
                    borderRadius: BorderRadius.circular(8.r),
                    onPressed: controller.onSave,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
