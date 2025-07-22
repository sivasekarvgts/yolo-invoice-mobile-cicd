import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_outside_focus_remover.dart';

import '../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

import '../../../../core/enums/user_type.dart';
import '../../../../router.dart';
import 'new_client_controller.dart';

class AddNewClientView extends ConsumerStatefulWidget {
  AddNewClientView({super.key, this.addNewCustomerRouteArg});
  final AddNewClientRouteArg? addNewCustomerRouteArg;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddNewClientViewState();
}

class _AddNewClientViewState extends ConsumerState<AddNewClientView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(newClientControllerProvider.notifier);

      await controller.onInit(widget.addNewCustomerRouteArg);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return AppOutsideFocusRemover(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            controller.isContactEdit == true
                ? (controller.usersType == UsersType.customer
                    ? 'Customer Contact'
                    : 'Vendor Contact')
                : (controller.usersType == UsersType.customer
                    ? 'New Customer'
                    : 'New Vendor'),
          ),
          bottom: (controller.isContactEdit == true || controller.clientType == 2)
              ? null
              : PreferredSize(
                  preferredSize: Size.zero,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 2,
                      width: MediaQuery.of(context).size.width /
                          controller.completedPercent,
                      child: const ColoredBox(color: AppColors.primary),
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: state.isLoading
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (controller.selectedIndex > 0 &&
                            !(controller.selectedIndex > 2))
                          Expanded(
                            flex: 0,
                            child: Row(
                              children: [
                                AppButton.outline(
                                  fullSize: false,
                                  'Back',
                                  textStyle: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColors.fuscousGreyColor),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  borderColor: AppColors.fuscousGreyColor,
                                  icon: const Icon(Icons.arrow_back_outlined,
                                      color: AppColors.fuscousGreyColor,
                                      size: 18),
                                  onPressed: () {
                                    if (controller.selectedIndex == 1) {
                                      return controller.onNext(0);
                                    }
                                    controller.onNext(1);
                                  },
                                  key: Key("customerCreateBack"),
                                ),
                                const SizedBox(width: 16)
                              ],
                            ),
                          ),
                        Expanded(
                          flex: 1,
                          child: AppButton(
                              key: Key("add_customer"),
                              iconAlignment: Alignment.centerRight,
                              controller.isContactEdit == true
                                  ? 'Save'
                                  : controller.completedPercent == 1
                                      ? 'Save'
                                      : 'Next',
                              height: 50,
                              width: MediaQuery.of(context).size.width * .5,
                              icon: controller.isContactEdit == true
                                  ? null
                                  : const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 18),
                              isLoading: state.isLoading, onPressed: () {
                            if (controller.isContactEdit == true) {
                              controller.contactUpload();
                              return;
                            }
                            if (controller.selectedIndex == 0) {
                              controller.onSaveBasicInfo();
                              return;
                            } else if (controller.selectedIndex == 1) {
                              controller.onSaveContactDetails();
                              return;
                            } else if (controller.selectedIndex == 2) {
                              controller.onSaveGST();
                              return;
                            } else if (controller.selectedIndex == 3) {
                              controller.onSaveIndividualClient();
                              return;
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        body: state.isLoading
            ? const Center(child: AppLoadingWidget())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: controller.formWidgets[controller.selectedIndex]),
      ),
    );
  }
}
