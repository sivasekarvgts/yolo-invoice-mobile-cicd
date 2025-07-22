import '../../../../core/enums/order_type.dart';
import '../../../bill_preview/models/bill_preview_model.dart';

class PaymentParamsRequestModel {
  int? clientId;
  final int? billId;
  final bool isEdit;
  final bool isVendor;
  final String? notes;
  final BillType billType;
  final BillPreviewModel? billDetail;

  PaymentParamsRequestModel({
    this.notes,
    this.clientId,
    this.billId,
    this.billDetail,
    this.isEdit = false,
    this.isVendor = false,
    required this.billType,
  });
}
