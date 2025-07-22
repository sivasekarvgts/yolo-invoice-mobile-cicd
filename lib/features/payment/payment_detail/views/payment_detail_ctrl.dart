import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/order_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/snackbar_service.dart';
import '../../../../services/event_bus_service.dart';
import '../../payment_create/models/payment_params_request_model.dart';
import '../data/payment_detail_repo.dart';
import '../models/payment_detail_model.dart';
import '../models/payment_template_model.dart';

part 'payment_detail_ctrl.g.dart';

@riverpod
class PaymentDetailCtrl extends _$PaymentDetailCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  Map? paramsReq;

  bool loading = false;
  bool isItemOpen = true;
  bool isReceipt = true;

  PaymentDetailModel? paymentDetailModel;
  PaymentTemplateModel? paymentTemplateModel;

  Future onInit(Map? data) async {
    paramsReq = data;
    await getPaymentDetailInfo();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.paymentDetail))
        await getPaymentDetailInfo();
    });
  }

  Future getPaymentDetailInfo() async {
    try {
      paymentDetailModel =
          await ref.read(paymentDetailsRepoProvider).getPaymentDetails(billId);
      isReceipt = paymentDetailModel?.clientId != null &&
          paymentDetailModel?.clientId.toString().isNotEmpty == true;
      await getPaymentTemplate();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future getPaymentTemplate() async {
    try {
      paymentTemplateModel =
          await ref.read(paymentDetailsRepoProvider).getPaymentTemplate(billId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void openItem() {
    isItemOpen = !isItemOpen;
    setState;
  }

  void editPayment() {
    navigationService.pushNamed(
      isPurchaseInvoice ? Routes.vendorPaymentCreate : Routes.paymentCreate,
      arguments: PaymentParamsRequestModel(
        clientId: isPurchaseInvoice
            ? paymentDetailModel?.vendorId
            : paymentDetailModel?.clientId,
        notes: paymentTemplateModel?.notes,
        isVendor: isPurchaseInvoice,
        isEdit: true,
        billId: billId,
        billType:
            isPurchaseInvoice ? BillType.paymentMade : BillType.paymentReceived,
      ),
    );
  }

  void deleteOrderPopup() async {
    final response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to delete the payment?",
    );
    if (response?.status == true) {
      await _deletePayment();
    }
  }

  Future _deletePayment() async {
    loading = true;
    setState;
    try {
      final res =
          await ref.read(paymentDetailsRepoProvider).deletePayment(billId);
      if (res == null) {
        toastMsg('Payment delete is failed');
        return;
      }
      toastMsg(res['message'].toString(), false);
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: [
        Routes.paymentList,
        Routes.receiptList,
        Routes.dashboard,
        Routes.customerDetail
      ]));
      navigationService.pop();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    loading = false;
    setState;
  }

  int get billId => paramsReq?['id'];
  bool get isPurchaseInvoice => paramsReq?['is_purchase'] == true;

  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }
}
