import 'package:intl/intl.dart';

import '../../features/sales/models/item_model/sales_line_item.dart';

extension NullCurrencyExtension on double? {
  String? toCurrencyFormatString() {
    if (this == null) return null;
    return priceFormat(this);
  }
}

extension CurrencyExtension on double {
  String toCurrencyFormatString() {
    return priceFormat(this);
  }

  String removeZero() {
    final list = this.toString().split('.');
    if (list.last == '0') {
      return list.first;
    }
    return this.toString();
  }
}

String priceFormat(dynamic price) =>
    NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
        .format(price);

extension DoubleToCurrencyExtension on double {
  String toCurrencyFormat() {
    NumberFormat formatter = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 2,
      symbol: '₹',
    );
    return formatter.format(this);
  }
}

extension DoubleToCurrencyExtensionWithoutsymbol on double {
  String toCurrencyFormatwithoutsymbol() {
    NumberFormat formatter = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 2,
      symbol: '',
    );
    return formatter.format(toInt());
  }
}

extension DoubleToCurrencyExtensionint on int {
  String toCurrencyFormatint() {
    NumberFormat formatter = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 0,
      symbol: '₹',
    );
    return formatter.format(toInt());
  }
}

extension SalesLineItemSubTotExtension on List<SalesLineItem> {
  double calCulateSubTotal() {
    List<SalesLineItem> lineItem = this;
    if (lineItem.isEmpty) return 0;
    double totalPrice = 0;

    totalPrice = lineItem.map((w) {
      if (w.lineItemDiscountValue != null) {
        final lineItemDisPrice = w.isLineItemDisInclusive == true
            ? w.lineItemDiscountAmt + w.gstTaxValue
            : w.lineItemDiscountAmt;
        return (lineItemDisPrice * (w.qty ?? 0));
      }
      return (w.price ?? 0) * (w.qty ?? 0);
    }).reduce((p, q) => p + q);

    return totalPrice;
  }

  double calCulateTotalTax() {
    List<SalesLineItem> lineItem = this;
    if (lineItem.isEmpty) return 0;
    double tax = lineItem.map((e) => e.qtyGstValue).reduce((p, q) => p + q);
    return tax;
  }
}
