import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../core/models/text_class.dart';
import '../styles/text_styles.dart';

class AppStrings {
  static TextClass SessionStart =
      TextClass(text: 'Text', textStyle: AppTextStyle.bodyMedium);

// select organization
  static TextClass switchOrganization = TextClass(
      text: 'Switch Organization', textStyle: AppTextStyle.bodyMedium);
  static TextClass selectOrgTitle =
      TextClass(text: '', textStyle: AppTextStyle.titleMedium);
  static TextClass selectOrgSubTitle =
      TextClass(text: '', textStyle: AppTextStyle.labelSmall);
  static TextClass active = TextClass(
      text: 'ACTIVE',
      textStyle: AppTextStyle.labelExtraSmall
          .copyWith(color: AppColors.primary, fontSize: 10));

// Manage Organization
  static TextClass manageOrganization = TextClass(
      text: 'Manage Organization', textStyle: AppTextStyle.bodyMedium);

// dashboard
  static TextClass dashboardTitle = TextClass(
      text: '',
      textStyle: AppTextStyle.titleMedium.copyWith(
          fontWeight: fontWeight600,
          fontFamily: "Manrope",
          color: AppColors.white),
      maxLines: 1);
  static TextClass dashboardSubTitle = TextClass(
      text: '',
      textStyle: AppTextStyle.labelSmall.copyWith(
        color: AppColors.white,
        fontWeight: fontWeight600,
      ));

  static TextClass receivables = TextClass(
      text: 'Receivables',
      textStyle: AppTextStyle.labelExtraSmall.copyWith(
        color: AppColors.white,
        fontWeight: fontWeight600,
      ));
  static TextClass payables = TextClass(
      text: 'Payables',
      textStyle: AppTextStyle.labelExtraSmall.copyWith(
        color: AppColors.white,
        fontWeight: fontWeight600,
      ));
  static TextClass titleAmount = TextClass(
      text: '',
      textStyle: AppTextStyle.bodyExtraLarge.copyWith(
        color: AppColors.white,
        fontWeight: fontWeight600,
      ));
  static TextClass quickLink = TextClass(
      text: 'Quick Links',
      textStyle: AppTextStyle.bodyMedium.copyWith(fontWeight: fontWeight600));

  //  GridView QuickLinks
  static TextClass invoice =
      TextClass(text: 'INVOICE', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass order =
      TextClass(text: 'ORDER', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass receipt =
      TextClass(text: 'RECEIPT', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass customer =
      TextClass(text: 'CUSTOMER', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass item =
      TextClass(text: 'ITEM', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass purchase =
      TextClass(text: 'PURCHASE', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass po =
      TextClass(text: 'PO', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass payment =
      TextClass(text: 'PAYMENT', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass vendor =
      TextClass(text: 'VENDOR', textStyle: AppTextStyle.labelExtraSmall);

  static TextClass service =
      TextClass(text: 'SERVICE', textStyle: AppTextStyle.labelExtraSmall);

// Charts Text
  static TextClass incomeAndExpense = TextClass(
      text: 'INCOME AND EXPENSE',
      textStyle:
          AppTextStyle.labelExtraSmall.copyWith(color: AppColors.greyColor));
  static TextClass cash =
      TextClass(text: 'CASH', textStyle: AppTextStyle.labelSmall);
  static TextClass accrual =
      TextClass(text: 'ACCRUAL', textStyle: AppTextStyle.labelSmall);
  static TextClass graphLabel = TextClass(
      text: '',
      textStyle:
          AppTextStyle.labelExtraSmall.copyWith(color: AppColors.greyColor));
  static TextClass totalIncome = TextClass(
      text: 'TOTAL INCOME',
      textStyle:
          AppTextStyle.labelExtraSmall.copyWith(color: AppColors.greyColor));

  static TextClass totalExpense = TextClass(
      text: 'TOTAL EXPENSE',
      textStyle:
          AppTextStyle.labelExtraSmall.copyWith(color: AppColors.greyColor));

  // Manage Organization - mo
  static TextClass moOrganizationTitle = TextClass(
      text: '',
      textStyle: AppTextStyle.titleMedium.copyWith(fontWeight: fontWeight600));

  static TextClass moOrganizationSubTitle = TextClass(
      text: '',
      textStyle: AppTextStyle.titleSmall.copyWith(color: AppColors.greyColor));

  static TextClass moTabBarName = TextClass(
      text: '',
      textStyle: AppTextStyle.titleSmall.copyWith(color: AppColors.greyColor));

  static final String basicInfo = "Basic Info";
  static final String contactInfo = "Contact Info";
  static final String address = "Address";
  static final String otherInfo = "Other Info";
  static final String generalSettings = "GENERAL SETTINGS";

  static TextClass moTabBarHeading = TextClass(
      text: '',
      textStyle: AppTextStyle.titleLarge.copyWith(color: AppColors.greyColor));

  static final String photo = "PHOTO";
  static final String organizationName = "ORGANIZATION NAME";
  static final String businessType = "BUSINESS TYPE";
  static final String businessCategory = "BUSINESS CATEGORY";
  static final String phoneNumber = "PHONE NUMBER";
  static final String email = "EMAIL";
  static final String website = "WEBSITE";
  static final String shippingAddress = "SHIPPING ADDRESS";
  static final String billingAddress = "BILLING ADDRESS";
  static final String businessLocation = "BUSINESS LOCATION";
  static final String timeZone = "TIME ZONE";
  static final String openingBalance = "OPENING BALANCE";
  static final String currency = "CURRENCY";
  static final String fiscalYear = "FISCAL YEAR";
  static final String gstStatus = "GST STATUS";
  static final String taxType = "TAX TYPE";
  static final String discountApplication = "DISCOUNT APPLICATION";
  static final String roundingOffInSalesTransactions =
      "ROUNDING OFF IN SALES TRANSACTIONS";
  static final String purchaseSaleOrder = "PURCHASE & SALE ORDER";

  static const purchaseOrderNotCreated = 'Purchase Order is not created.';
  static const purchaseOrderNotUpdated = 'Purchase Order is not updated.';
  static const orderNotCreated = 'Sales Order is not created.';
  static const orderNotUpdate = 'Sales Order is not updated.';
  static const invoiceNotCreated = 'Sales Invoice is not created.';
  static const paymentNotCreated = 'Payment is not created.';

  static const totalAmtError =
      'Please ensure that the total amount is greater than or equal to zero.';
  static const schemeError = 'Please select scheme';
  static const totalAmtDigitError =
      'Please ensure that there are no more than 10 digits in total.';
  static const selectItemError = 'Please select item.';
  static const itemQtyZeroError = 'Item qty cannot be zero.';

  static TextClass moCardTitle = TextClass(
      text: '',
      textStyle:
          AppTextStyle.labelExtraSmall.copyWith(color: AppColors.greyColor));

  static TextClass moText = TextClass(
      text: 'Sri Sakthi Traders',
      textStyle: AppTextStyle.bodyMedium.copyWith(
          color: AppColors.darkBlackColor, fontWeight: fontWeight600));

  static TextClass moPhotoPlaceHolder = TextClass(
      text:
          'You and others can easily identify organization when it has a logo',
      textStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.fuscousGreyColor,
      ));

  static TextClass moBusinessCategoryPlaceHolder = TextClass(
      text:
          'Choose a business category that most accurately describes your business\'s industry',
      textStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.fuscousGreyColor,
      ));

  static TextClass moEmailPlaceHolder = TextClass(
      text:
          'Your email address can be displayed on your bill by entering it here',
      textStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.fuscousGreyColor,
      ));

  static TextClass moWebsitePlaceHolder = TextClass(
      text:
          'You can display the URL of your website on the bill by entering it here',
      textStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.fuscousGreyColor,
      ));
}
