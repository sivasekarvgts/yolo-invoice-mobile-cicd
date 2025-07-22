import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

class PaymentListModel {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final int? perPage;
  final List<PaymentDatum>? data;
  final PaymentTotalValues? paymentTotalValues;

  PaymentListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.perPage,
    this.data,
    this.paymentTotalValues,
  });

  factory PaymentListModel.fromJson(Map<String, dynamic> json) =>
      PaymentListModel(
        count: json["count"],
        numPages: json["num_pages"],
        pageSize: json["page_size"],
        currentPage: json["current_page"],
        pageRange: json["page_range"] == null
            ? []
            : List<int>.from(json["page_range"]!.map((x) => x)),
        perPage: json["per_page"],
        data: json["data"] == null
            ? []
            : List<PaymentDatum>.from(
                json["data"]!.map((x) => PaymentDatum.fromJson(x))),
        paymentTotalValues: json["total_values"] == null
            ? null
            : PaymentTotalValues.fromJson(json["total_values"]),
      );

// Map<String, dynamic> toJson() => {
//       "count": count,
//       "num_pages": numPages,
//       "page_size": pageSize,
//       "current_page": currentPage,
//       "page_range": pageRange == null
//           ? []
//           : List<dynamic>.from(pageRange!.map((x) => x)),
//       "per_page": perPage,
//       "data": data == null
//           ? []
//           : List<dynamic>.from(data!.map((x) => x.toJson())),
//       "total_values": paymentTotalValues?.toJson(),
//     };
}

class PaymentDatum {
  final int? id;
  final String? paymentNumber;
  final DateTime? date;
  final String? displayName;
  final int? clientId;
  final int? vendorId;
  final double? total;
  final double? receivedAmount;
  final String? logo;
  final double? excessAmount;
  final int? paymentModeId;
  final String? paymentMode;

  PaymentDatum({
    this.id,
    this.paymentNumber,
    this.date,
    this.displayName,
    this.clientId,
    this.vendorId,
    this.total,
    this.receivedAmount,
    this.logo,
    this.excessAmount,
    this.paymentModeId,
    this.paymentMode,
  });

  String? get dateFormatted => date?.toFormattedYearMonthDate();

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
        id: json["id"],
        paymentNumber: json["payment_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        displayName: json["display_name"],
        clientId: json["client_id"],
        vendorId: json["vendor_id"],
        total: json["total"]?.toDouble(),
        receivedAmount: json["received_amount"]?.toDouble(),
        logo: json["logo"],
        excessAmount: json["excess_amount"]?.toDouble(),
        paymentModeId: json["payment_mode_id"],
        paymentMode: json["payment_mode"],
      );

// Map<String, dynamic> toJson() => {
//       "id": id,
//       "payment_number": paymentNumber,
//       "date":
//           "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//       "display_name": displayName,
//       "client_id": clientId,
//       "total": total,
//       "received_amount": receivedAmount,
//       "logo": logo,
//       "excess_amount": excessAmount,
//       "payment_mode_id": paymentModeId,
//       "payment_mode": paymentMode,
//     };
}

class PaymentTotalValues {
  final int? totalCount;
  final double? totalReceivedAmount;
  final double? totalExcessAmount;

  PaymentTotalValues({
    this.totalCount,
    this.totalReceivedAmount,
    this.totalExcessAmount,
  });

  factory PaymentTotalValues.fromJson(Map<String, dynamic> json) =>
      PaymentTotalValues(
        totalCount: json["total_count"],
        totalReceivedAmount: json["total_received_amount"]?.toDouble(),
        totalExcessAmount: json["total_excess_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "total_received_amount": totalReceivedAmount,
        "total_excess_amount": totalExcessAmount,
      };
}
