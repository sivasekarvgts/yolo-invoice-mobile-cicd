import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/business_category_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/business_type_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/country_list_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/gst_status_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/salutation_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/client/new_client/shared/state_list_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/models/customer/customer_request_model.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/services/dialog_service/snackbar_service.dart';

import '../../../../core/models/address_detail.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../data/customer_repository.dart';
import '../../models/customer/country_model.dart';
import '../../models/customer/customer_update_request_model.dart';
import '../../models/customer/state_model.dart';
import '../../models/customer/type_model.dart';
import 'basic_information_view.dart';
import 'contact_details_view.dart';
import 'gst_treatment_view.dart';

part 'new_client_controller.g.dart';

part 'package:yoloworks_invoice/features/dashboard/customer/new_customer/new_customer_controller.dart';

part 'package:yoloworks_invoice/features/dashboard/vendor/new_vendor/new_vendor_controller.dart';

@riverpod
class NewClientController extends _$NewClientController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  final contactDetailKey = GlobalKey<FormState>();
  final basicInfoKey = GlobalKey<FormState>();
  final addressKey = GlobalKey<FormState>();
  final gstKey = GlobalKey<FormState>();
  AddNewClientRouteArg? addNewCustomerRouteArg;
  bool? isContactEdit = false;
  bool? isAddressEdit = false;
  double completedPercent = 0;
  int selectedIndex = 0;
  late List<Widget> formWidgets;
  CustomerRequestModel newCustomerData = CustomerRequestModel();
  CustomerUpdateRequestModel customerUpdateData = CustomerUpdateRequestModel();
  int? clientType;
  UsersType? usersType;

  //basic-info
  List<TypeModel> businessTypeList = [];
  int selectedBusinessType = 0;
  int selectedBusinessCategory = 0;
  List<TypeModel> businessCategoryList = [];
  bool openingBalanceOptional = false;
  final orgNameCtrl = TextEditingController();
  final businessTypeCtrl = TextEditingController();
  final openingBalanceCtrl = TextEditingController();
  final businessCategoryCtrl = TextEditingController();

  //contact
  bool emailOptional = false;

  // ContactDetail? contact;
  // List<ContactDetail>? contactLists;
  final phoneCtrl = TextEditingController();

  // final contactNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  //address
  List<StateModel> stateList = [];
  List<CountryModel> countryList = [];
  CountryModel selectedCountry = CountryModel(
    id: 101,
    name: "India",
    countryModelPhoneCode: "91",
    emoji: "🇮🇳",
  );
  bool addressFetched = false;
  bool isAddressLoading = false;

  // image
  double shippingLat = 0.0;
  double shippingLng = 0.0;
  String shippingStateId = "4035";
  bool billingAddress = true;
  final shippingCityTextCtrl = TextEditingController();
  final shippingCountryTextCtrl = TextEditingController();
  final shippingPincodeTextCtrl = TextEditingController();
  final shippingAddress1TextCtrl = TextEditingController();
  final shippingAddress2TextCtrl = TextEditingController();
  final shippingStateTextCtrl = TextEditingController(text: 'Tamil Nadu');

  double billingLat = 0.0;
  double billingLng = 0.0;
  String billingStateId = "4035";
  bool billingAddress2Optional = false;
  bool isBillingLocationLoading = false;
  bool isShippingLocationLoading = false;
  final billingCityTextCtrl = TextEditingController();
  final billingCountryTextCtrl = TextEditingController();
  final billingPincodeTextCtrl = TextEditingController();
  final billingAddress2TextCtrl = TextEditingController();
  final billingAddress1TextCtrl = TextEditingController();
  final billingStateTextCtrl = TextEditingController(text: 'Tamil Nadu');

  //gst
  List<TypeModel> gstList = [];
  final gstNoTextCtrl = TextEditingController();
  final gstStatusTextCtrl = TextEditingController();
  TypeModel selectedGSTValue = TypeModel();

  // salutation
  List<TypeModel> salutationList = [
    TypeModel(id: 1, name: "Ms."),
    TypeModel(id: 2, name: "Mr.")
  ];
  TypeModel selectedSalutationValue = TypeModel(id: 2, name: "Mr.");

  onInit(_addNewCustomerRouteArg) async {
    addNewCustomerRouteArg = _addNewCustomerRouteArg;
    usersType = addNewCustomerRouteArg?.usersType;
    setLoading;
    if (addNewCustomerRouteArg != null) setData();
    if (clientType == 2) selectedIndex = 3;
    await _onLoadWidget();
    if (clientType == 2)
      await fetchCountry();
    else
      await fetchBusinessTypeList();
    // await _getCustomersOrderNumber();
    // await _onLoadContactDetails();
    // await _onLoadCustomerImages();
    // await _getStateCountryList();
    setState;
  }

  void setData() {
    isContactEdit = addNewCustomerRouteArg?.isContactEdit ?? false;
    isAddressEdit = !(addNewCustomerRouteArg?.isContactEdit ?? true);
    usersType = addNewCustomerRouteArg?.usersType;
    clientType = addNewCustomerRouteArg?.customerType;
    if (isContactEdit == true) {
      if (addNewCustomerRouteArg?.isEdit == true) {
        orgNameCtrl.text = addNewCustomerRouteArg?.name ?? "";
        phoneCtrl.text = addNewCustomerRouteArg?.phone ?? "";
        emailCtrl.text = addNewCustomerRouteArg?.email ?? "";
      }
    } else {
      if (addNewCustomerRouteArg?.isEdit == true) {
        AddressDetail? _shippingAddress =
            addNewCustomerRouteArg?.addressList?.first;
        AddressDetail? _billingAddress =
            addNewCustomerRouteArg?.addressList?.last;

        shippingAddress1TextCtrl.text = _shippingAddress?.address1 ?? "";
        shippingAddress2TextCtrl.text = _shippingAddress?.address2 ?? "";
        shippingCityTextCtrl.text = _shippingAddress?.city ?? "";
        shippingStateTextCtrl.text = _shippingAddress?.stateName ?? "";
        shippingStateId = "${_shippingAddress?.state ?? "4035"}";
        shippingPincodeTextCtrl.text = _shippingAddress?.pincode ?? "";

        if (addNewCustomerRouteArg?.sameAsShipping == false) {
          billingAddress1TextCtrl.text = _billingAddress?.address1 ?? "";
          billingAddress2TextCtrl.text = _billingAddress?.address2 ?? "";
          billingCityTextCtrl.text = _billingAddress?.city ?? "";
          billingStateTextCtrl.text = _billingAddress?.stateName ?? "";
          billingStateId = "${_billingAddress?.state ?? "4035"}";
          billingPincodeTextCtrl.text = _billingAddress?.pincode ?? "";
        }
      }
      // await _getBusinessTypes();
      // await _gstTypeList();
    }
  }

  void _setCustomerRequest() {
    newCustomerData = CustomerRequestModel(
      name: orgNameCtrl.text,
      salutation: clientType == 2 ? selectedSalutationValue.id : null,
      businessType: selectedBusinessType.toString(),
      businessCategory: selectedBusinessCategory.toString(),
      openingBalanceType: "1",
      openingBalance: double.tryParse(openingBalanceCtrl.text),
      country: selectedCountry.id.toString(),
      isDebit: true,
      phone: phoneCtrl.text,
      email: emailCtrl.text,
      shipping: Address(
        address1: shippingAddress1TextCtrl.text,
        address2: shippingAddress2TextCtrl.text,
        city: shippingCityTextCtrl.text,
        state: shippingCityTextCtrl.text.isEmpty ? null : shippingStateId,
        pincode: shippingPincodeTextCtrl.text,
      ),
      billing: Address(
        address1: billingAddress
            ? shippingAddress1TextCtrl.text
            : billingAddress1TextCtrl.text,
        address2: billingAddress
            ? shippingAddress2TextCtrl.text
            : billingAddress2TextCtrl.text,
        city: billingAddress
            ? shippingCityTextCtrl.text
            : billingCityTextCtrl.text,
        state: shippingCityTextCtrl.text.isEmpty
            ? null
            : (billingAddress ? shippingStateId : billingStateId),
        pincode: billingAddress
            ? shippingPincodeTextCtrl.text
            : billingPincodeTextCtrl.text,
      ),
      sameAsShipping: billingAddress,
      clientType: clientType,
      vendorType: clientType,
      registrationType: selectedGSTValue.id,
      gstNum: gstNoTextCtrl.text,
    );
  }

  void _setCustomerUpdateRequest() {
    customerUpdateData = CustomerUpdateRequestModel(
      displayName: orgNameCtrl.text,
      organizationName: clientType == 2 ? null : orgNameCtrl.text,
      clientName: clientType == 2 ? orgNameCtrl.text : null,
      businessType: selectedBusinessType.toString(),
      businessCategory: selectedBusinessCategory.toString(),
      openingBalanceType: "1",
      openingBalance: double.tryParse(openingBalanceCtrl.text),
      isDebit: true,
      phone: phoneCtrl.text,
      email: emailCtrl.text,
      clientType: clientType,
      vendorType: clientType,
      registrationType: selectedGSTValue.id,
      gstNum: gstNoTextCtrl.text,
    );
  }

  Future fetchBusinessTypeList({bool? refresh}) async {
    try {
      if (refresh == true) {
        businessTypeList = [];
      }
      businessTypeList =
          await ref.read(customerRepositoryProvider).getBusinessType();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future fetchBusinessCategory({bool? refresh}) async {
    try {
      if (refresh == true) {
        businessCategoryList = [];
      }
      businessCategoryList = await ref
          .read(customerRepositoryProvider)
          .getBusinessCategory(selectedBusinessType);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future fetchStates({bool? refresh}) async {
    try {
      if (refresh == true) {
        stateList = [];
      }
      stateList = await ref.read(customerRepositoryProvider).getStates();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future fetchCountry({bool? refresh}) async {
    try {
      if (refresh == true) {
        countryList = [];
      }
      countryList = await ref.read(customerRepositoryProvider).getCountries();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future fetchGstList({bool? refresh}) async {
    try {
      if (refresh == true) {
        gstList = [];
      }
      gstList =
          await ref.read(customerRepositoryProvider).getRegistrationType();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future<bool> verifyGst() async {
    try {
      await ref
          .read(customerRepositoryProvider)
          .verifyGstNo(gstNoTextCtrl.text);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
    state = AsyncValue.data(null);
    return true;
  }

  void onClearBilling() {
    billingLat = 0;
    billingLng = 0;
    billingCityTextCtrl.clear();
    billingStateTextCtrl.clear();
    billingCountryTextCtrl.clear();
    billingPincodeTextCtrl.clear();
    billingAddress1TextCtrl.clear();
    billingAddress2TextCtrl.clear();
  }

  void onClearShipping() {
    shippingLat = 0;
    shippingLng = 0;
    shippingCityTextCtrl.clear();
    shippingStateTextCtrl.clear();
    shippingPincodeTextCtrl.clear();
    shippingCountryTextCtrl.clear();
    shippingAddress1TextCtrl.clear();
    shippingAddress2TextCtrl.clear();
  }

  void addStateText() {
    billingStateTextCtrl.text = 'Tamil Nadu';
    shippingStateTextCtrl.text = 'Tamil Nadu';
  }

  void openBusinessType() => dialogService.showBottomSheet(
        title: 'Business Type',
        child: const BusinessTypeWidget(),
      );

  void openBusinessCategory() => dialogService.showBottomSheet(
      title: 'Business Category', child: const BusinessCategoryWidget());

  void openGSTStatus() => dialogService.showBottomSheet(
      title: 'GST Status', child: const GstStatusWidget());

  void openSalutationWidget() => dialogService.showBottomSheet(
      title: 'Choose Salutation', child: const SalutationWidget());

  void openStateList(bool isShipping) => dialogService.showBottomSheet(
      title: 'Choose State', child: StateListWidget(isShipping: isShipping));

  void openCountryListWidget() => dialogService.showBottomSheet(
      title: 'Choose Country', child: CountryListWidget());

  Future<void> _onLoadWidget() async {
    formWidgets = isContactEdit!
        ? const [
            ContactDetailsView(),
          ]
        : const [
            BasicInformationView(),
            ContactDetailsView(),
            GstTreatmentView(),
            ContactDetailsView.basicInformation(),
          ];
    _onDownloadPercent();
  }

  void onNext(int index) {
    selectedIndex = index;
    _onDownloadPercent();
    setState;
  }

  void _onDownloadPercent() {
    if (selectedIndex == 0) {
      completedPercent = 3;
    } else if (selectedIndex == 1) {
      completedPercent = 2;
    } else {
      completedPercent = 1;
    }
  }

  Future contactUpload() async {
    final isValid = contactDetailKey.currentState!.validate();
    if (!isValid) return;

    state = AsyncValue.loading();

    if (isContactEdit == true) {
      if (addNewCustomerRouteArg?.individualTypeEdit == true) {
        await _updateClient();
      } else {
        await updateContact();
      }
      return;
    }
  }

  void _onClearCategory() {
    selectedBusinessCategory = 0;
    businessCategoryCtrl.clear();
  }

  void onSelectBusinessType(TypeModel item) async {
    _onClearCategory();
    selectedBusinessType = item.id!;
    businessTypeCtrl.text = item.name!;
    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
    await fetchBusinessCategory();
  }

  void onSelectBusinessCategory(TypeModel item) async {
    selectedBusinessCategory = item.id!;
    businessCategoryCtrl.text = item.name!;
    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
  }

  void onSelectCountry(CountryModel item) {
    selectedCountry = item;
    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
  }

  void onSelectState(StateModel item, bool isShipping) async {
    // if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    if (isShipping) {
      shippingStateTextCtrl.text = item.name!;
      shippingStateId = (item.id ?? "").toString();
    } else {
      billingStateTextCtrl.text = item.name!;
      billingStateId = (item.id ?? "").toString();
      debugPrint('billingStateId $billingStateId');
    }
    debugPrint('selected item $item');

    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
  }

  void onSelectGST(TypeModel item) async {
    selectedGSTValue = item;
    gstStatusTextCtrl.text = item.name!;
    if (selectedGSTValue.id == 2) {
      gstNoTextCtrl.text = '';
      gstKey.currentState!.validate();
    }
    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
  }

  void onSelectSalutation(TypeModel item) async {
    selectedSalutationValue = item;

    setState;
    dialogService.dialogComplete(AlertResponse(status: true));
  }

  void onSaveBasicInfo() {
    final isValid = basicInfoKey.currentState!.validate();
    debugPrint('isValid $isValid');
    if (!isValid) return;
    onNext(1);
  }

  void onSaveContactDetails() {
    final isValid = contactDetailKey.currentState!.validate();
    debugPrint('isValid $isValid');
    if (!isValid) return;
    onNext(2);
  }

  Future<void> onSaveAddress() async {
    final isValid = addressKey.currentState!.validate();

    if (!isValid) return;
    if (isAddressEdit == true) {
      await updateAddress();
      return;
    }

    addressFetched = true;
    navigationService.pop();
    setState;
  }

  void onSaveGST() async {
    final isValid = gstKey.currentState!.validate();
    if (!isValid) return;
    if (selectedGSTValue.id == 1) {
      bool verify = await verifyGst();
      if (!verify) return;
    }
    state = AsyncValue.loading();
    await _createClient();
  }

  void onSaveIndividualClient() async {
    final isValidDetail = contactDetailKey.currentState!.validate();

    final isValidInfo = basicInfoKey.currentState!.validate();

    if (!(isValidInfo && isValidDetail)) return;
    state = AsyncValue.loading();
    await _createClient();
  }

  void emailOnChange(String value, [bool isShipping = true]) {
    if (value.isEmpty) {
      emailOptional = false;
    } else {
      final lowerCaseValue = value.toLowerCase();
      emailCtrl.text = lowerCaseValue;
      emailOptional = true;
    }
    setState;
  }

  void balanceOnChange(String value) {
    if (value.isEmpty) {
      openingBalanceOptional = false;
    } else {
      openingBalanceOptional = true;
    }
    setState;
  }

  void _setTempBillings() {
    // if (Get.arguments == null ||
    //     (Get.arguments as Map).isEmpty ||
    //     Get.arguments['is_exsiting_address'] == false) {
    //   return;
    // }

    if (newCustomerData.billing == null) return;
    billingAddress1TextCtrl.text = newCustomerData.billing?.address1 ?? "";
    billingAddress2TextCtrl.text = newCustomerData.billing?.address2 ?? "";
    billingStateId = newCustomerData.billing?.state ?? "";
    billingStateTextCtrl.text = newCustomerData.billing?.state ?? "";
    billingCountryTextCtrl.text = newCustomerData.country ?? "";
    billingCityTextCtrl.text = newCustomerData.billing?.city ?? "";
    billingPincodeTextCtrl.text = newCustomerData.billing?.pincode ?? "";
    // billingLat = "tempBillingAddress['lat']";
    // billingLng = tempBillingAddress['lng'];
  }

  void _setBillingsTemp() {
    // tempBillingAddress = {
    //   'lat': billingLat,
    //   'lng': billingLng,
    //   'state_id': billingStateId,
    //   'city': billingCityTextCtrl.text,
    //   'state': billingStateTextCtrl.text,
    //   'country': billingCountryTextCtrl.text,
    //   'pincode': billingPincodeTextCtrl.text,
    //   'address1': billingAddress1TextCtrl.text,
    //   'address2': billingAddress2TextCtrl.text,
    // };
    // Logger.d( 'tempBillingAddress $tempBillingAddress');
  }

  void onBilling() {
    if (!billingAddress) {
      _setBillingsTemp();
      onClearBilling();
    } else {
      _setTempBillings();
      // if (Get.arguments['is_exsiting_address'] == true) {
      //   onClearBilling();
      // }
    }
    billingAddress = !billingAddress;
    setState;
  }

  updateAddress() async {
    if (usersType == UsersType.customer) {
      await updateCustomerAddress();
    } else {
      await updateVendorAddress();
    }
  }

  updateContact() async {
    if (usersType == UsersType.customer) {
      await updateCustomerContact();
    } else {
      await updateVendorContact();
    }
  }

  _createClient() async {
    if (usersType == UsersType.customer) {
      await createCustomers();
    } else {
      await createVendor();
    }
  }

  _updateClient() async {
    if (usersType == UsersType.customer) {
      await updateCustomers();
    } else {
      await updateVendor();
    }
  }

// Future<LocationData?> _getLocation([bool isPop = false]) async =>
//     await LocaitonService.getLocation(isPop);
//
// void pickLocation([bool isShipping = true]) async {
//   // Get.closeAllSnackbars();
//   FocusManager.instance.primaryFocus?.unfocus();
//   _updatePickLocationLoading(true, isShipping);
//   // DebounceUtilis.debounce('get-user-location', () async {
//   final latLng = await _getLocation(true);
//   debugPrint('latLng $latLng');
//   _updatePickLocationLoading(false, isShipping);
//   if (latLng == null) {
//     SnackbarService.toastMsg(
//         'Location permission denied, Please enable locaiton.');
//     return;
//   }
//   if (isShipping) {
//     shippingLat = latLng.latitude!;
//     shippingLng = latLng.longitude!;
//   } else {
//     billingLat = latLng.latitude!;
//     billingLng = latLng.longitude!;
//   }
//   setState;
//   SnackbarService.toastMsg('Locaiton is added.', false);
//   // });
// }
//
// void _updatePickLocationLoading(bool isLoading, bool isShipping) {
//   if (isShipping) {
//     isShippingLocationLoading = isLoading;
//   } else {
//     isBillingLocationLoading = isLoading;
//   }
//   setState;
// }
}
