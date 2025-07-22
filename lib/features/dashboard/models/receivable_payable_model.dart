import 'package:equatable/equatable.dart';

class ReceivablePayableModel extends Equatable {
  ReceivablePayableModel({
    required this.receivable,
    required this.payable,
  });

  final Receivable? receivable;
  final Payable? payable;

  factory ReceivablePayableModel.fromJson(Map<String, dynamic> json) {
    return ReceivablePayableModel(
      receivable: json["receivable"] == null
          ? null
          : Receivable.fromJson(json["receivable"]),
      payable:
          json["payable"] == null ? null : Payable.fromJson(json["payable"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "receivable": receivable?.toJson(),
        "payable": payable?.toJson(),
      };

  @override
  String toString() {
    return "$receivable, $payable,";
  }

  @override
  List<Object?> get props => [receivable, payable];
}

class Payable extends Equatable {
  Payable({
    required this.count,
    required this.payableAmount,
    required this.overdue,
  });

  final int? count;
  final double? payableAmount;
  final double? overdue;

  factory Payable.fromJson(Map<String, dynamic> json) {
    return Payable(
      count: json["count"],
      payableAmount: double.tryParse("${json["payable_amount"] ?? 0}"),
      overdue: double.tryParse("${json["overdue"] ?? 0}"),
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "payable_amount": payableAmount,
        "overdue": overdue,
      };

  @override
  String toString() {
    return "$count, $payableAmount, $overdue, ";
  }

  @override
  List<Object?> get props => [
        count,
        payableAmount,
        overdue,
      ];
}

class Receivable extends Equatable {
  Receivable({
    required this.count,
    required this.receivableAmount,
    required this.overdue,
  });

  final int? count;
  final double? receivableAmount;
  final double? overdue;

  factory Receivable.fromJson(Map<String, dynamic> json) {
    return Receivable(
      count: json["count"],
      receivableAmount: double.tryParse("${json["receivable_amount"] ?? 0}"),
      overdue: double.tryParse("${json["overdue"] ?? 0}"),
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "receivable_amount": receivableAmount,
        "overdue": overdue,
      };

  @override
  String toString() {
    return "$count, $receivableAmount, $overdue, ";
  }

  @override
  List<Object?> get props => [
        count,
        receivableAmount,
        overdue,
      ];
}

/*
{
	"receivable": {
		"count": 14,
		"receivable_amount": 3979154951.17,
		"overdue": 2501316254.02
	},
	"payable": {
		"count": 4,
		"payable_amount": 11179050450,
		"overdue": 0
	}
}*/