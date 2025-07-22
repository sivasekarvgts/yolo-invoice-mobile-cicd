import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_bar_widget.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';

import '../../../../app/common_widgets/brief_tile.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/common_widgets/network_image_loader.dart';
import '../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../app/common_widgets/tab_bar_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/strings.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/dark_theme.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../core/enums/user_type.dart';
import 'client_info_controller.dart';

class ClientInfoView extends ConsumerStatefulWidget {
  const ClientInfoView({
    super.key,
    required this.clientId,
    required this.usersType,
  });

  final int clientId;
  final UsersType usersType;

  @override
  ConsumerState createState() => _ClientInfoViewState();
}

class _ClientInfoViewState extends ConsumerState<ClientInfoView>
    with SingleTickerProviderStateMixin {
  late TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(clientInfoControllerProvider.notifier);
      await controller.onInit(
        widget.usersType,
        widget.clientId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget(
        isEmptyBar: false,
        titleWidget: BriefTile(
          leading: SizedBox(),
          title: controller.transactionData?.displayName ?? "",
          subTitle:
              controller.transactionData?.addressDetail?.toCityAddressOne(),
          trailing: NetworkImageLoader(
            image: controller.transactionData?.logo ?? "",
            height: 40,
            width: 40,
            borderRadius: BorderRadius.circular(25),
            fit: BoxFit.cover,
          ),
          trailingOnCenter: true,
          onTrailingTap: () {
            controller.detailView(widget.clientId);
          },
        ),
      ),
      body: Column(
        children: [
          TabBarHeaderWidget(
            tabController: tabController,
            tabs: controller.tabs,
            color: Colors.white,
            activeColor: AppColors.darkBlackColor,
          ),
          Expanded(
            child: TabBarBodyWidget(
              tabController: tabController,
              tabs: controller.tabs,
            ),
          )
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
