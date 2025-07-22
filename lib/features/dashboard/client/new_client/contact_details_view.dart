import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/common_widgets/app_text_prefix_widget.dart';
import '../../../../app/common_widgets/button.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/dark_theme.dart';
import '../../../../app/styles/text_styles.dart';

import '../../../../core/enums/user_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../auth/view/manage_organization/organization_info/organization_info_view.dart';
import 'basic_information_view.dart';
import 'new_client_controller.dart';

class ContactDetailsView extends ConsumerStatefulWidget {
  const ContactDetailsView({super.key, this.showBasicInfo = false});
  const ContactDetailsView.basicInformation(
      {super.key, this.showBasicInfo = true});
  final bool showBasicInfo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDetailsViewState();
}

class _ContactDetailsViewState extends ConsumerState<ContactDetailsView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    ref.watch(newClientControllerProvider);
    return VGTSForm(
      key: controller.contactDetailKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showBasicInfo)
            BasicInformationView()
          else
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text('Contact Details',
                    style: AppTextStyle.titleLarge
                        .copyWith(fontWeight: fontWeight700)),
              ),
            ),
          if (controller.isContactEdit == true)
            AppTextFieldWidget.form(
              ctrl: controller.orgNameCtrl,
              maxLength: 15,
              label: 'Contact Name',
              hintText: 'Eg: Manager',
              keyboardTextType: TextInputType.name,
              inputFormatter: InputFormatter.nameFormatter,
              validator: (val) => InputValidator.nameValidator(val,
                  requiredText: 'Contact Name is Required'),
            ),
          AppTextFieldWidget.form(
            ctrl: controller.phoneCtrl,
            maxLength: 15,
            label: (controller.isContactEdit == true || widget.showBasicInfo)
                ? 'Phone Number'
                : 'Organization Phone Number',
            hintText: '98********',
            keyboardTextType: TextInputType.phone,
            prefixIcon: widget.showBasicInfo
                ? TextFieldPrefixWidget(
                    onTap: () {
                      controller.openCountryListWidget();
                    },
                    text:
                        "${controller.selectedCountry.emoji} ${controller.selectedCountry.countryModelPhoneCode}")
                : null,
            inputFormatter: InputFormatter.phoneNoFormatter,
            validator: (val) => InputValidator.phoneValidator(val,
                requiredText: 'Phone Number is Required'),
          ),
          AppTextFieldWidget.form(
              keyboardTextType: TextInputType.emailAddress,
              ctrl: controller.emailCtrl,
              onChanged: controller.emailOnChange,
              validator: (val) => controller.emailOptional
                  ? emailValidator(val, requiredText: 'Email is Required')
                  : null,
              isOptional: true,
              label: (controller.isContactEdit == true || widget.showBasicInfo)
                  ? 'Email Id'
                  : 'Organisation Email',
              hintText: 'example@email.com'),
          if (controller.isContactEdit == false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          widget.showBasicInfo
                              ? 'Address'
                              : 'Organization Address',
                          style: AppTextStyle.titleMedium),
                      if (controller.addressFetched)
                        TextButton(
                            onPressed: () =>
                                navigationService.pushNamed(Routes.addAddress),
                            child: Text(
                              'Edit',
                              style: AppTextStyle.titleSmall,
                            ))
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (controller.addressFetched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrganizationInfoCard(
                    needTail: false,
                    onTap: () {},
                    subTitle: controller.shippingAddress1TextCtrl.text,
                    title: controller.usersType == UsersType.vendor
                        ? "Billing Address"
                        : "Shipping Address:",
                    placeHolder: "",
                  ),
                  if (controller.usersType != UsersType.vendor)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: DarkTheme.customDivider,
                    ),
                  if (controller.usersType != UsersType.vendor)
                    OrganizationInfoCard(
                      needTail: false,
                      onTap: () {},
                      subTitle:
                          (controller.billingAddress1TextCtrl.text.isNotEmpty)
                              ? controller.billingAddress1TextCtrl.text
                              : controller.shippingAddress1TextCtrl.text,
                      title: "Billing Address:",
                      placeHolder: "",
                    ),
                ],
              ),
            )
          else if (controller.isContactEdit == false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AppButton.outline(key: Key("addressButton"), 'Address',
                  onPressed: () {
                controller.addStateText();
                navigationService.pushNamed(Routes.addAddress);
              },
                  height: 45,
                  icon: const Icon(Icons.add, color: AppColors.blueColor)),
            ),
        ],
      ),
    );
  }

  static String? emailValidator(String? value, {String? requiredText}) {
    if (value?.trim().isEmpty != false) return requiredText ?? "Required !";

    if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value!) ==
        true) {
      return "Please enter a valid Email";
    }

    return null;
  }
}
