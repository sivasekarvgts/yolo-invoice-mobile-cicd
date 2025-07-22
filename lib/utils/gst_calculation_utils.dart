import '../app/constants/app_constants.dart';
import 'logger.dart';

sealed class GSTCalculationUtils {
  /// * INCLUSIVE FORMULA *
  /// Amount * (TaxPercentage / (TaxPercentage + 100))
  static double inclusiveTax(Map input) {
    final amount = input['amount'] as double;
    final percentage = input['taxPercentage'] as double;
    return amount * (percentage / (percentage + 100));
  }

  static double findSingleItemPercentage(Map input) {
    final amount = input['price'] as double;
    final totalAmt = input['totalAmt'] as double;
    return (amount / totalAmt) * 100;
  }

  static double findSingleItemPercentWithDiscountAmt(Map input) {
    final discount = input['discount'] as double;
    final singleItemPercent = input['percent'] as double;
    return (singleItemPercent / 100) * discount;
  }

  static double deductionWithItemPrice(Map input) {
    final originalPrice = input['price'] as double;
    final itemDiscount = input['discount'] as double;
    return originalPrice - itemDiscount;
  }

  static double calculateTaxAmt(Map input) {
    final taxPercent = double.parse(
        input['percent'] != null ? input['percent'].toString() : '0');
    final deductionAmt = input['amount'] as double;
    return deductionAmt * (taxPercent / 100);
  }

  static double subAmtFormatValue(String price) =>
      double.tryParse(AppConstants.textSymbolRemover(price)) ?? 0;

  static (double, double) overAllDiscountForSalesItem(Map<String, dynamic> data,
      [bool isUpload = false]) {
    double subTotalAmt = data['subTotalAmt'] as double;
    double itemSubTotalAmt = data['itemSubTotalAmt'] as double;
    double disAmount = data['disAmount'] as double;
    double taxPercentage = data['taxPercentage'] as double;
    bool isPercent = data['isPercent'] as bool;
    bool isInclusive = data['isInclusive'] as bool;
    double orgPrice = subTotalAmt;
    double singleItemPercent = 0.0;
    double singleItemPercentDiscountAmt = 0.0;
    double discount = 0.0;

    if (isInclusive) {
      final tax =
          inclusiveTax({'amount': subTotalAmt, 'taxPercentage': taxPercentage});
      orgPrice = subTotalAmt - tax;
    }

    if (!isPercent) {
      singleItemPercent = findSingleItemPercentage(
          {'price': orgPrice, 'totalAmt': itemSubTotalAmt});

      singleItemPercentDiscountAmt = findSingleItemPercentWithDiscountAmt(
          {'percent': singleItemPercent, 'discount': disAmount});
    } else {
      discount = (orgPrice * (disAmount / 100));
    }

    final deductionAmt = deductionWithItemPrice({
      'price': orgPrice,
      'discount': !isPercent ? singleItemPercentDiscountAmt : discount
    });

    final calculateTaxAmt = GSTCalculationUtils.calculateTaxAmt(
        {'percent': taxPercentage, 'amount': deductionAmt});

    final totalAmt = (deductionAmt + calculateTaxAmt);
    Logger.d('calculateTaxAmt $calculateTaxAmt, totalAmt $totalAmt');
    if (isUpload) return (deductionAmt, calculateTaxAmt);
    if (isInclusive) return (totalAmt, calculateTaxAmt);
    return (deductionAmt, calculateTaxAmt);
  }

  static Map taxBreakDown(Map gstBreakDown) {
    double newPrice = gstBreakDown['price'];
    double taxRate = gstBreakDown['taxRate'] ?? 0;
    double cessRate = gstBreakDown['cessRate'] ?? 0;
    double taxPercentage = gstBreakDown['taxPercentage'];
    final isLineItemDisInclusive = gstBreakDown['isLineItemDisInclusive'];
    final lineItemDiscountValue = gstBreakDown['lineItemDiscountValue'];
    bool isSalesTaxExclusive = gstBreakDown['isSalesTaxExclusive'] as bool;

    if (isLineItemDisInclusive == true || isSalesTaxExclusive == true) {
      final gstTaxAmt = newPrice * (taxRate / 100);
      final cessAmt = newPrice * (cessRate / 100);
      return {
        'gstTaxAmt': gstTaxAmt,
        'cessAmt': cessAmt,
        'cessTax': cessRate,
        'gstTax': taxRate
      };
    }

    if (lineItemDiscountValue == null) {
      newPrice =
          newPrice - (newPrice * (taxPercentage / (100 + taxPercentage)));
    }

    final gstTaxAmt = newPrice * (taxRate / 100);
    final cessAmt = newPrice * (cessRate / 100);
    return {
      'gstTaxAmt': gstTaxAmt,
      'cessAmt': cessAmt,
      'cessTax': cessRate,
      'gstTax': taxRate
    };
  }

  static List getGSTBreakDownList(
      List salesItemList, Map sales, Map billState) {
    List<Map<dynamic, dynamic>> gstBreakDowns = [];
    for (final e in salesItemList) {
      final taxPercentage =
          double.parse(((e['cess'] ?? 0) + (e['tax'] ?? 0)).toString());
      final isInclusive = e['is_exclusive_tax'] == false;

      // overall-discount applied
      if (sales['discount'] != null && sales['discount'] != 0) {
        final gstValue = overAllDiscountForSalesItem({
          'subTotalAmt': sales['sub_total'],
          'itemSubTotalAmt': e['total_amount'],
          'isPercent': sales['is_discount_percentage'],
          'disAmount': sales['discount'],
          'isInclusive': isInclusive,
          'taxPercentage': taxPercentage
        }, true);

        gstBreakDowns.add({
          'gstTaxAmt': calculateTaxAmt(
              {'percent': e['tax'] ?? 0, 'amount': gstValue.$1}),
          'cessAmt': calculateTaxAmt(
              {'percent': e['cess'] ?? 0, 'amount': gstValue.$1}),
          'cessTax': e['cess'],
          'gstTax': e['tax']
        });
      } else {
        gstBreakDowns.add(taxBreakDown({
          'price': e['total_amount'],
          'taxRate': e['tax'],
          'cessRate': e['cess'],
          'taxPercentage': taxPercentage,
          'isSalesTaxExclusive': isInclusive,
          'isLineItemDisInclusive':
              e['discount_amount'] == 0 ? isInclusive : null,
          'lineItemDiscountValue': e['discount_amount'],
        }));
      }
    }

    return getBreakDownList(gstBreakDowns, billState);
  }

  static List getBreakDownList(
      List<Map<dynamic, dynamic>> salesList, Map billState) {
    final isGstSameState = isGSTSameState(
        billState['orgStateCode'], billState['customerStateCode']);
    final gstTaxList = _getUniqueBreakDownList(
        'gstTax', 'gstTaxAmt', salesList, isGstSameState);

    final cessTaxList =
        _getCessUniqueBreakDownList(salesList, (w) => w['cessTax'], 'cessAmt');

    if (cessTaxList.isNotEmpty) {
      cessTaxList.removeWhere((w) => w['taxAmt'] == 0);
    }

    final breakDownList = [...gstTaxList, ...cessTaxList];
    return breakDownList;
  }

  static List _getCessUniqueBreakDownList<T>(
      List items, T Function(Map) keySelector, String sumField) {
    Map<T, Map> grouped = {};

    for (var item in items) {
      T key = keySelector(item);

      if (grouped.containsKey(key)) {
        grouped[key]![sumField] += item[sumField];
      } else {
        grouped[key] = Map.from(item);
      }
    }

    return grouped.values
        .map((e) => {
              'taxName': 'CESS',
              'taxPercent': e['cessTax'],
              'taxAmt': double.parse((e['cessAmt']).toStringAsFixed(2))
            })
        .toList();
  }

  static List _getUniqueBreakDownList(String taxKey, String taxAmtKey,
      List<Map<dynamic, dynamic>> salesList, bool isGstSameState,
      [bool isCess = false]) {
    Map<double, List<Map>> breakDown = {};
    List breakDownList = [];

    for (final item in salesList) {
      if (breakDown.containsKey(item[taxKey])) {
        breakDown[item[taxKey]]!.add(item);
      } else if (item[taxKey] != null) {
        breakDown[item[taxKey]] = [item];
      }
    }

    breakDown.forEach((number, list) {
      final taxAmt =
          (list.map((w) => w[taxAmtKey] as double).reduce((a, b) => a + b));
      if (isCess) {
        final taxPercentTotal =
            (list.map((w) => w[taxKey] as double).reduce((a, b) => a + b));
        final taxPercentage = !isGstSameState || list.length == 1
            ? taxPercentTotal
            : taxPercentTotal / 2;
        breakDownList.add({
          'taxName': 'CESS',
          'taxPercent': taxPercentage,
          'taxAmt': double.parse((taxAmt).toStringAsFixed(2))
        });
      } else if (!isGstSameState) {
        final tax = double.parse((taxAmt).toStringAsFixed(2));
        final taxPercentage = (list.first[taxKey] as double);
        breakDownList.add(
            {'taxName': 'IGST', 'taxPercent': taxPercentage, 'taxAmt': tax});
      } else {
        final tax = double.parse((taxAmt / 2).toStringAsFixed(2));
        final taxPercentAmt = (list.first[taxKey] as double);
        final taxPercentage = (taxPercentAmt / 2);
        breakDownList.addAll([
          {'taxName': 'CGST', 'taxPercent': taxPercentage, 'taxAmt': tax},
          {'taxName': 'SGST', 'taxPercent': taxPercentage, 'taxAmt': tax}
        ]);
      }
    });
    return breakDownList;
  }

  static bool isGSTSameState(int orgStateCode, int customerStateCode) =>
      orgStateCode == customerStateCode;
}
