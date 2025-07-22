import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/network_image_loader.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/strings.dart';
import 'package:yoloworks_invoice/features/auth/view/select_organization/select_organization_controller.dart';
import 'package:yoloworks_invoice/locator.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../dashboard/client/client_list_view.dart';

class SelectOrganisationView extends ConsumerStatefulWidget {
  const SelectOrganisationView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectOrganisationViewState();
}

class _SelectOrganisationViewState
    extends ConsumerState<SelectOrganisationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller =
          ref.read(selectOrganisationControllerProvider.notifier);
      controller.init();
      controller.fetchData(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(selectOrganisationControllerProvider.notifier);
    final state = ref.watch(selectOrganisationControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.switchOrganization.text),
      ),
      body: state.isLoading
          ? _buildLoadingList()
          : ListView.separated(
              padding: EdgeInsets.only(bottom: 60, left: 12, right: 12),
              itemCount: controller.organizationList.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () async {
                  controller
                      .selectOrganization(controller.organizationList[index]);
                  // await preferenceService.setUserOrg();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: NetworkImageLoader(
                                image:
                                    controller.organizationList[index].logo ??
                                        businessIndividualImages
                                            .randomBusinessImage,
                                height: 45,
                                width: 45,
                              ),
                            ),
                            gapW10,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.organizationList[index].name ??
                                        "Unknown",
                                    style: AppStrings.selectOrgTitle.textStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  gapH4,
                                  Text(
                                    controller.organizationList[index].gstNum ??
                                        "Un Registered",
                                    style:
                                        AppStrings.selectOrgSubTitle.textStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (preferenceService.getUserOrg()?.id ==
                          controller.organizationList[index].id)
                        SizedBox(
                            width: 55,
                            height: 22,
                            child: AppButton.outline(
                                fullSize: false,
                                borderRadius: BorderRadius.circular(8),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                AppStrings.active.text,
                                textStyle: AppStrings.active.textStyle,
                                key: Key("activeee"),
                                onPressed: () {}))
                      else
                        SizedBox(
                            width: 16.w,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CupertinoIcons.forward,
                                  size: 20,
                                )))
                    ],
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: 12,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 17.0),
          child: LoadingCardShimmerTile(), // Extract to separate widget
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}
