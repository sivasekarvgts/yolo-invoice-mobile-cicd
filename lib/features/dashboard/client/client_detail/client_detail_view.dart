import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';

import '../../../../app/common_widgets/button.dart';
import '../../../../app/common_widgets/brief_tile.dart';
import '../../../../app/common_widgets/network_image_loader.dart';

import '../../../../app/constants/strings.dart';
import '../../../../app/constants/app_sizes.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/dark_theme.dart';
import '../../../../app/styles/text_styles.dart';

import '../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../app/common_widgets/edit_delete_pop_up_menu_widget.dart';

import '../../../../router.dart';
import '../../../../locator.dart';
import '../../../../core/enums/user_type.dart';
import '../../../auth/view/manage_organization/organization_info/organization_info_view.dart';
import 'client_detail_controller.dart';

class ClientDetailView extends ConsumerStatefulWidget {
  const ClientDetailView({
    super.key,
    required this.clientId,
    required this.usersType,
  });

  final int clientId;
  final UsersType usersType;

  @override
  ConsumerState createState() => _ClientDetailViewState();
}

class _ClientDetailViewState extends ConsumerState<ClientDetailView> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(clientDetailControllerProvider.notifier);
      await controller.onInit(widget.usersType, widget.clientId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 50 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 50 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(clientDetailControllerProvider.notifier);
    final state = ref.watch(clientDetailControllerProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 110.0,
            floating: false,
            pinned: true,
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.customerData?.displayName ?? "",
                    style: AppTextStyle.titleLarge.copyWith(
                        fontWeight: fontWeight600, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  NetworkImageLoader(
                    image: controller.customerData?.logo ?? "",
                    height: 30,
                    width: 30,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BriefTile(
                      title: controller.customerData?.displayName ?? "",
                      image: controller.customerData?.logo ??
                          (controller.customerData?.clientTypeId == 2
                              ? businessIndividualImages.randomIndividualImage
                              : businessIndividualImages.randomBusinessImage),
                      subTitle: controller.customerData?.addressDetail
                          .toCityAddressOne(),
                      trailing: const Icon(
                        CupertinoIcons.delete_simple,
                        color: AppColors.error,
                      ),
                      trailingOnCenter: true,
                      onTrailingTap: () {
                        controller.deleteCustomer(controller.customerData?.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                state.isLoading
                    ? LoadingDetailsShimmerTile()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapH4,
                              Text(
                                AppStrings.contactInfo,
                                style: AppStrings.moTabBarHeading.textStyle,
                              ),
                              if (controller.customerData?.clientTypeId == 2)
                                Column(
                                  children: [
                                    BriefTile(
                                      padding: EdgeInsets.only(top: 12),
                                      title: controller
                                              .customerData?.displayName ??
                                          "",
                                      leading: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.phone,
                                          size: 30,
                                        ),
                                      ),
                                      subTitle: controller.customerData?.phone,
                                      secondSubTitle:
                                          controller.customerData?.email,
                                      trailingStatus: "DEFAULT",
                                      needStatus: false,
                                      onLeadingTap: () {
                                        if (controller.customerData?.phone !=
                                                null ||
                                            controller.customerData!.phone!
                                                .isNotEmpty)
                                          controller.makeCallFun(
                                              controller.customerData!.phone!);
                                      },
                                      trailing: EditDeletePopUpMenuWidget(
                                          isShowDelete: true,
                                          onSelected: (value) async {
                                            if (value == 'edit') {
                                              navigationService
                                                  .pushNamed(
                                                      Routes.addNewClient,
                                                      arguments:
                                                          AddNewClientRouteArg
                                                              .isContactEdit(
                                                        usersType: controller
                                                            .usersType!,
                                                        isContactEdit: true,
                                                        contactId: controller
                                                            .customerData?.id,
                                                        individualTypeEdit:
                                                            true,
                                                        name: controller
                                                            .customerData
                                                            ?.displayName,
                                                        email: controller
                                                            .customerData
                                                            ?.email,
                                                        phone: controller
                                                            .customerData
                                                            ?.phone,
                                                      ))
                                                  ?.then((v) async {
                                                if (v)
                                                  await controller.fetchData();
                                              });

                                              return;
                                            }
                                          }),
                                      onTrailingTap: () {},
                                    )
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.customerData
                                              ?.contactDetail?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final data = controller.customerData
                                            ?.contactDetail![index];
                                        return BriefTile(
                                          title: data?.name ?? "",
                                          image: data?.logo ??
                                              businessIndividualImages
                                                  .randomIndividualImage,
                                          subTitle: data?.phone,
                                          secondSubTitle: data?.email,
                                          trailingStatus: "DEFAULT",
                                          needStatus:
                                              data?.contactDetailDefault ??
                                                  false,
                                          onLeadingTap: () {
                                            if (data?.phone != null ||
                                                data!.phone!.isNotEmpty)
                                              controller
                                                  .makeCallFun(data!.phone!);
                                          },
                                          trailing:
                                              // Icon(Icons.more_vert_outlined),
                                              EditDeletePopUpMenuWidget(
                                                  isShowDelete: (data
                                                          ?.contactDetailDefault ??
                                                      false),
                                                  onSelected: (value) async {
                                                    if (value == 'delete') {
                                                      await controller
                                                          .deleteContact(
                                                              data?.id ?? 0);
                                                      return;
                                                    }
                                                    if (value == 'edit') {
                                                      navigationService
                                                          .pushNamed(
                                                              Routes
                                                                  .addNewClient,
                                                              arguments:
                                                                  AddNewClientRouteArg
                                                                      .isContactEdit(
                                                                usersType:
                                                                    controller
                                                                        .usersType!,
                                                                isContactEdit:
                                                                    true,
                                                                contactId:
                                                                    data?.id,
                                                                name:
                                                                    data?.name,
                                                                email:
                                                                    data?.email,
                                                                phone:
                                                                    data?.phone,
                                                              ))
                                                          ?.then((v) async {
                                                        if (v)
                                                          await controller
                                                              .fetchData();
                                                      });

                                                      return;
                                                    }
                                                  }),
                                          onTrailingTap: () {},
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              DarkTheme.customDivider,
                                    ),
                                    gapH4,
                                    AppButton.outline(
                                      "New Contact",
                                      key: Key("new-contact"),
                                      onPressed: () {
                                        navigationService
                                            .pushNamed(Routes.addNewClient,
                                                arguments: AddNewClientRouteArg(
                                                    usersType:
                                                        controller.usersType!,
                                                    isContactEdit: true,
                                                    customerId: controller
                                                        .customerData?.id))
                                            ?.then((v) async {
                                          if (v) await controller.fetchData();
                                        });
                                      },
                                      borderColor: AppColors.greyColor,
                                      textStyle: AppTextStyle.button
                                          .copyWith(color: AppColors.greyColor),
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              gapH32,
                              Text(
                                AppStrings.address,
                                style: AppStrings.moTabBarHeading.textStyle,
                              ),
                              if (controller.customerData!.addressDetail
                                      ?.isNotEmpty ==
                                  true)
                                Column(
                                  children: [
                                    gapH16,
                                    OrganizationInfoCard(
                                      needTail: false,
                                      onTap: () {},
                                      subTitle: controller
                                          .customerData?.addressDetail
                                          .inFullAddress(),
                                      title: controller.usersType ==
                                              UsersType.customer
                                          ? AppStrings.shippingAddress
                                          : AppStrings.billingAddress,
                                      placeHolder:
                                          AppStrings.moPhotoPlaceHolder.text,
                                    ),
                                    if (controller.usersType ==
                                        UsersType.customer)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: DarkTheme.customDivider,
                                      ),
                                    if (controller.usersType ==
                                        UsersType.customer)
                                      OrganizationInfoCard(
                                        needTail: false,
                                        onTap: () {},
                                        subTitle: controller
                                            .customerData?.addressDetail
                                            .inFullAddress(isShipping: false),
                                        title: AppStrings.billingAddress,
                                        placeHolder:
                                            AppStrings.moPhotoPlaceHolder.text,
                                      ),
                                    gapH16,
                                    AppButton.outline(
                                      "Edit Address",
                                      key: Key("edit-address"),
                                      onPressed: () {
                                        navigationService
                                            .pushNamed(Routes.addAddress,
                                                arguments: AddNewClientRouteArg
                                                    .isAddressEdit(
                                                  usersType:
                                                      controller.usersType!,
                                                  customerId:
                                                      controller.clientId,
                                                  sameAsShipping: controller
                                                      .customerData
                                                      ?.sameAsShippingAddress,
                                                  addressList: controller
                                                      .customerData
                                                      ?.addressDetail,
                                                ))
                                            ?.then((v) async {
                                          if (v == true)
                                            await controller.fetchData();
                                        });
                                      },
                                      borderColor: AppColors.greyColor,
                                      textStyle: AppTextStyle.button
                                          .copyWith(color: AppColors.greyColor),
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AppButton.outline(
                                    "Add Address",
                                    key: Key("add-address"),
                                    onPressed: () {
                                      navigationService
                                          .pushNamed(Routes.addAddress,
                                              arguments: AddNewClientRouteArg(
                                                  usersType:
                                                      controller.usersType!,
                                                  customerId:
                                                      controller.clientId,
                                                  isContactEdit: false))
                                          ?.then((v) async {
                                        if (v == true)
                                          await controller.fetchData();
                                      });
                                    },
                                    borderColor: AppColors.greyColor,
                                    textStyle: AppTextStyle.button
                                        .copyWith(color: AppColors.greyColor),
                                    icon: Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              gapH32,
                              Text(
                                AppStrings.otherInfo,
                                style: AppStrings.moTabBarHeading.textStyle,
                              ),
                              Column(
                                children: [
                                  gapH16,
                                  OrganizationInfoCard(
                                    needTail: false,
                                    onTap: () {},
                                    subTitle:
                                        "${controller.customerData?.country?.emoji} ${controller.customerData?.country?.name}",
                                    title: AppStrings.businessLocation,
                                    placeHolder:
                                        AppStrings.moPhotoPlaceHolder.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DarkTheme.customDivider,
                                  ),
                                  OrganizationInfoCard(
                                    needTail: false,
                                    onTap: () {},
                                    subTitle:
                                        "${controller.customerData?.timeZone?.gmtOffsetName} ${controller.customerData?.timeZone?.tzName} (${controller.customerData?.timeZone?.zoneName})",
                                    title: AppStrings.timeZone,
                                    placeHolder:
                                        AppStrings.moPhotoPlaceHolder.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DarkTheme.customDivider,
                                  ),
                                  OrganizationInfoCard(
                                    needTail: false,
                                    onTap: () {},
                                    subTitle:
                                        "${controller.customerData?.country?.currency} (${controller.customerData?.country?.currencySymbol})",
                                    title: AppStrings.timeZone,
                                    placeHolder:
                                        AppStrings.moPhotoPlaceHolder.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DarkTheme.customDivider,
                                  ),
                                  OrganizationInfoCard(
                                    needTail: false,
                                    onTap: () {},
                                    subTitle:
                                        "${(controller.customerData?.gstNum == null || controller.customerData?.gstNum == "") ? (controller.customerData?.registrationTypeName ?? "UnKnown") : "${controller.customerData?.registrationTypeName} (${controller.customerData?.gstNum})"}",
                                    title: AppStrings.gstStatus,
                                    placeHolder:
                                        AppStrings.moPhotoPlaceHolder.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: DarkTheme.customDivider,
                                  ),
                                  OrganizationInfoCard(
                                    needTail: false,
                                    onTap: () {},
                                    subTitle:
                                        "${(controller.customerData?.country?.currencySymbol ?? "")} ${(controller.customerData?.openingBalance ?? "0")}",
                                    title: AppStrings.openingBalance,
                                    placeHolder:
                                        AppStrings.moPhotoPlaceHolder.text,
                                  ),
                                ],
                              ),
                              gapH35,
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingDetailsShimmerTile extends StatelessWidget {
  const LoadingDetailsShimmerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODOS
    //Avoid thid widget methods
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
                height: 20,
                width: 250,
              ),
              const SizedBox(height: 4),
              ShimmerWidget.text(
                height: 20,
                width: 200,
              ),
            ],
          ),
        ],
      );
    }

    //TODOS
    //Avoid thid widget methods
    Widget _textCard() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.text(
            height: 12,
            width: 100,
          ),
          const SizedBox(height: 8),
          ShimmerWidget.text(
            height: 20,
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
            _card(),
            gapH16,
            Text(
              AppStrings.contactInfo,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH12,
            _card(),
            gapH16,
            DarkTheme.customDivider,
            gapH16,
            _card(),
            gapH10,
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppButton.outline(
                "Add Contact",
                key: Key("add-address"),
                onPressed: () {},
                borderColor: AppColors.graphBaseLine,
                textStyle: AppTextStyle.button
                    .copyWith(color: AppColors.graphBaseLine),
                icon: Icon(
                  Icons.add,
                  color: AppColors.graphBaseLine,
                  size: 20,
                ),
              ),
            ),
            gapH30,
            Text(
              AppStrings.address,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH16,
            _textCard(),
            gapH16,
            DarkTheme.customDivider,
            gapH16,
            _textCard(),
            gapH10,
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppButton.outline(
                "Edit Address",
                key: Key("add-address"),
                onPressed: () {},
                borderColor: AppColors.graphBaseLine,
                textStyle: AppTextStyle.button
                    .copyWith(color: AppColors.graphBaseLine),
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.graphBaseLine,
                  size: 20,
                ),
              ),
            ),
            gapH32,
            Text(
              AppStrings.otherInfo,
              style: AppStrings.moTabBarHeading.textStyle,
            ),
            gapH16,
            _textCard(),
            gapH16,
            DarkTheme.customDivider,
            gapH16,
            _textCard(),
            gapH16,
          ],
        ),
      ),
    );
  }
}
