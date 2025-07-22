import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import 'new_client_controller.dart';

class AddAddressView extends ConsumerStatefulWidget {
  const AddAddressView({super.key, this.addNewCustomerRouteArg}) : super();
  final AddNewClientRouteArg? addNewCustomerRouteArg;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends ConsumerState<AddAddressView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(newClientControllerProvider.notifier);
      controller.addNewCustomerRouteArg = widget.addNewCustomerRouteArg;
      if (controller.addNewCustomerRouteArg != null) controller.setData();
      controller.fetchStates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return VGTSForm(
      key: controller.addressKey,

      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool isPoped, _) async {
          if (isPoped) return;
          if (!controller.addressFetched) {
            controller.onClearBilling();
            controller.onClearShipping();
          }
          navigationService.pop();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text((controller.isAddressEdit == true &&
                    widget.addNewCustomerRouteArg?.addressList != null)
                ? 'Edit Address'
                : 'Add Address'),
          ),
          bottomNavigationBar: state.isLoading
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppButton(
                          key: Key("save"),
                          'Save',
                          height: 50,
                          isLoading: controller.isAddressLoading,
                          onPressed: () => controller.onSaveAddress()),
                    )
                  ],
                ),
          body: state.isLoading
              ? const Center(child: AppLoadingWidget())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShippingBillingAddressWidget(
                        latLngText: controller.shippingLat == 0
                            ? null
                            : 'Co-ordinates are  ${controller.shippingLat},${controller.shippingLng}',
                      ),
                      const SizedBox(height: 16),
                      if (controller.usersType != UsersType.vendor)
                        InkWell(
                          onTap: () => controller.onBilling(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                  size: 20,
                                  controller.billingAddress
                                      ? CupertinoIcons.checkmark_square_fill
                                      : CupertinoIcons.square,
                                  color: controller.billingAddress
                                      ? AppColors.blueColor
                                      : Colors.black),
                              gapW5,
                              Flexible(
                                child: Text(
                                    'Use Shipping address as your Billing address',
                                    maxLines: 2,
                                    style: AppTextStyle.bodyMedium
                                        .copyWith(fontWeight: fontWeight500)),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(height: 25),
                      if (!controller.billingAddress)
                        ShippingBillingAddressWidget(
                          isShipping: false,
                          latLngText: controller.billingLat == 0
                              ? null
                              : 'Co-ordinates are  ${controller.billingLat},${controller.billingLng}',
                        )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class ShippingBillingAddressWidget extends ConsumerStatefulWidget {
  const ShippingBillingAddressWidget(
      {super.key, this.isShipping = true, this.latLngText});
  final bool isShipping;
  final String? latLngText;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShippingBillingAddressWidget();
}

class _ShippingBillingAddressWidget
    extends ConsumerState<ShippingBillingAddressWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    ref.watch(newClientControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${(widget.isShipping && controller.usersType == UsersType.customer) ? ('Shipping') : 'Billing'} Address',
                style: AppTextStyle.titleMedium
                    .copyWith(fontWeight: fontWeight600)),
            // InkWell(
            //     onTap: () => controller.mapPicker(isShipping),
            //     child: const Row(
            //       children: [
            //         Text('Pick Map'),
            //         SizedBox(width: 4),
            //         Icon(Icons.location_on, color: AppColors.blueColor)
            //       ],
            //     ))
          ],
        ),
        const SizedBox(height: 20),
        // Text('Pick Location',
        //     style: AppTextStyle.labelSmall.copyWith(
        //      fontWeight: fontWeight500
        //     )),
        // const SizedBox(height: 8),
        // Button.outline(
        //   key: Key("useCurrentLocationnn"),
        //   'Use Current Location',
        //   disabled: widget.isShipping
        //       ? controller.isShippingLocationLoading
        //       : controller.isBillingLocationLoading,
        //   onPressed: () => controller.pickLocation(widget.isShipping),
        //   borderRadius: BorderRadius.circular(15),
        //   height: 45,
        //   isLoading: widget.isShipping
        //       ? controller.isShippingLocationLoading
        //       : controller.isBillingLocationLoading,
        //   icon: const Icon(
        //     Icons.gps_fixed,
        //     color: AppColors.blueColor,
        //     size: 20,
        //   ),
        //
        // ),
        // if (widget.latLngText != null)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 4.0),
        //     child: Text(widget.latLngText!,
        //         style:AppTextStyle.labelSmall.copyWith(
        //             fontWeight: fontWeight500
        //         )),
        //   ),
        // const SizedBox(height: 8),
        AppTextFieldWidget.form(
          label: 'State',
          ctrl: widget.isShipping
              ? controller.shippingStateTextCtrl
              : controller.billingStateTextCtrl,
          onTap: () {
            controller.openStateList(widget.isShipping);
          },
          suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined,
              color: Colors.black, size: 20),
          readOnly: true,
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'State is Required'),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: AppTextFieldWidget.form(
                  label: 'City / Town',
                  maxLength: 50,
                  inputFormatter: [
                    NoLeadingSpaceFormatter(),
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
                  ],
                  textCapitalization: TextCapitalization.sentences,
                  ctrl: widget.isShipping
                      ? controller.shippingCityTextCtrl
                      : controller.billingCityTextCtrl,
                  validator: (val) => InputValidator.emptyValidator(val,
                      requiredText: 'City / Town is Required'),
                )),
            const SizedBox(width: 12),
            Expanded(
                child: AppTextFieldWidget.form(
              label: 'Pin Code',
              textCapitalization: TextCapitalization.sentences,
              keyboardTextType: TextInputType.number,
              ctrl: widget.isShipping
                  ? controller.shippingPincodeTextCtrl
                  : controller.billingPincodeTextCtrl,
              inputFormatter: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (val) => InputValidator.zipCodeValidator(val,
                  requiredText: 'PinCode is Required'),
            )),
          ],
        ),
        const SizedBox(height: 16),
        AppTextFieldWidget.form(
          label: 'Address Line 1',
          inputFormatter: [NoLeadingSpaceFormatter()],
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          ctrl: widget.isShipping
              ? controller.shippingAddress1TextCtrl
              : controller.billingAddress1TextCtrl,
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'Address Line 1 is Required'),
        ),
        const SizedBox(height: 16),
        AppTextFieldWidget.form(
            maxLength: 100,
            label: 'Address Line 2',
            inputFormatter: [NoLeadingSpaceFormatter()],
            textCapitalization: TextCapitalization.sentences,
            isOptional: true,
            ctrl: widget.isShipping
                ? controller.shippingAddress2TextCtrl
                : controller.billingAddress2TextCtrl),
      ],
    );
  }
}
