import 'package:equatable/equatable.dart';

class SalesPurchaseModel extends Equatable {
  SalesPurchaseModel({
    required this.monthlyData,
    required this.overallSales,
    required this.overallPurchase,
  });

  final List<MonthlyDatum> monthlyData;
  final double? overallSales;
  final double? overallPurchase;

  factory SalesPurchaseModel.fromJson(Map<String, dynamic> json) {
    return SalesPurchaseModel(
      monthlyData: json["monthly_data"] == null
          ? []
          : List<MonthlyDatum>.from(
              json["monthly_data"]!.map((x) => MonthlyDatum.fromJson(x))),
      overallSales: double.tryParse("${json["overall_sales"] ?? 0}"),
      overallPurchase: double.tryParse("${json["overall_purchase"] ?? 0}"),
    );
  }

  Map<String, dynamic> toJson() => {
        "monthly_data": monthlyData.map((x) => x.toJson()).toList(),
        "overall_sales": overallSales,
        "overall_purchase": overallPurchase,
      };

  @override
  String toString() {
    return "$monthlyData, $overallSales, $overallPurchase, ";
  }

  @override
  List<Object?> get props => [
        monthlyData,
        overallSales,
        overallPurchase,
      ];
}

class MonthlyDatum extends Equatable {
  MonthlyDatum({
    required this.name,
    required this.period,
    required this.year,
    required this.amount,
  });

  final String? name;
  final String? period;
  final int? year;
  final double? amount;

  factory MonthlyDatum.fromJson(Map<String, dynamic> json) {
    return MonthlyDatum(
      name: json["name"],
      period: json["period"],
      year: json["year"],
      amount: double.tryParse("${json["amount"] ?? 0}"),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "period": period,
        "year": year,
        "amount": amount,
      };

  @override
  String toString() {
    return "$name, $period, $year, $amount, ";
  }

  @override
  List<Object?> get props => [
        name,
        period,
        year,
        amount,
      ];
}
