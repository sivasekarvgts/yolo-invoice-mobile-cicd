import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/services/event_bus_service.dart';

import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/images.dart';
import '../../../app/constants/strings.dart';
import '../../../app/styles/colors.dart';
import '../../../app/styles/dark_theme.dart';
import '../../../app/styles/text_styles.dart';
import '../../../core/models/text_class.dart';
import '../../../router.dart';
import '../../../services/dialog_service/alert_response.dart';
import '../../auth/models/organization_model.dart';
import '../../charts_of_account/data/charts_of_accounts_repository.dart';
import '../../charts_of_account/models/charts_of_accounts_list_model.dart';
import '../data/dahboard_repository.dart';
import '../models/receivable_payable_model.dart';
import '../models/sales_purchase_model.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  Organization? get org => preferenceService.getUserOrg();
  SalesPurchaseModel? salesPurchaseData;
  ReceivablePayableModel? receivablePayable;
  int type = 1;

  bool isCashSelected = true;
  DateTime now = DateTime.now();
  SalesPurchaseFilter? selectedFilter;
  List<MonthlyDatum> incomeData = [];
  List<MonthlyDatum> expenseData = [];
  List<SalesPurchaseFilter> filters = [];
  List<ChartsOfAccountListModel> accountsList = [];

  Future<void> init() async {
    //TODOS
    //need to modify this initialized data
    filters = [
      SalesPurchaseFilter(
          text: "This Financial Year", period: now.getFinancialYear()),
      SalesPurchaseFilter(text: "This Quarter", period: now.getQuaterYear()),
      SalesPurchaseFilter(text: "This Month", period: now.getThisMonth()),
      SalesPurchaseFilter(
          text: "Previous Financial Year",
          period:
              DateTime(now.year - 1, now.month, now.day).getFinancialYear()),
      SalesPurchaseFilter(
          text: "Previous Quarter",
          period: DateTime(now.year, now.month - 3, now.day).getQuaterYear()),
      SalesPurchaseFilter(
          text: "Previous Month",
          period: DateTime(now.year, now.month - 1, now.day).getThisMonth()),
      SalesPurchaseFilter(
          text: "Last 6 Months",
          period: FromDateToDate(
            endDate: DateFormates.yearMonthDayFormat.format(now),
            startDate: DateFormates.yearMonthDayFormat
                .format(DateTime(now.year, now.month - 6, now.day)),
          )),
      SalesPurchaseFilter(
          text: "Last 12 Months",
          period: FromDateToDate(
              endDate: DateFormates.yearMonthDayFormat.format(now),
              startDate: DateFormates.yearMonthDayFormat
                  .format(DateTime(now.year - 1, now.month, now.day)))),
    ];
    selectedFilter = filters.first;

    await fetchReceivablesPayable(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.dashboard))
      await fetchReceivablesPayable(refresh: event.isRefresh);
    });
  }

  String get receivableAmt {
    final amt = receivablePayable?.receivable?.receivableAmount
        .toCurrencyFormatString();
    if (amt == null) return '₹0.0';
    return amt;
  }

  String get payableAmt {
    final amt =
        receivablePayable?.payable?.payableAmount.toCurrencyFormatString();
    if (amt == null) return '₹0.0';
    return amt;
  }

  String get totalIncome {
    final amt = salesPurchaseData?.overallSales.toCurrencyFormatString();
    if (amt == null) return '₹0.0';
    return amt;
  }

  String get totalExpense {
    final amt = salesPurchaseData?.overallPurchase.toCurrencyFormatString();
    if (amt == null) return '₹0.0';
    return amt;
  }

  void showFilters() {
    dialogService.showBottomSheet(
        showActionBar: true,
        showCloseIcon: true,
        title: "Select Filter",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final data = filters[index];
              return InkWell(
                onTap: () {
                  selectedFilter = data;
                  fetchGraphData();
                  state = AsyncValue.data(null);
                  dialogService.dialogComplete(AlertResponse(status: true));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                      ),
                      gapW8,
                      Text(
                        data.text,
                        style: AppTextStyle.bodyMedium,
                      ),
                      Spacer(),
                      if (data.text != selectedFilter!.text)
                        Icon(
                          Icons.radio_button_off,
                          color: AppColors.greyColor,
                        )
                      else
                        Icon(
                          Icons.radio_button_on,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return DarkTheme.customDivider;
            },
          ),
        ));
  }

  Future<void> cashAccruelChange() async {
    isCashSelected = !isCashSelected;
    state = AsyncValue.data(null);
    if (isCashSelected) {
      type = 1;
    } else {
      type = 2;
    }
    await fetchGraphData();
  }

  Future<void> fetchGraphData({bool? refresh}) async {
    try {
      if (refresh == true) {
        salesPurchaseData = null;
      }
      if (salesPurchaseData == null) {
        state = const AsyncValue.loading();
      }
      salesPurchaseData = await ref
          .read(dashboardRepositoryProvider)
          .getSalesPurchase(
              startDate: selectedFilter?.period.startDate,
              endDate: selectedFilter?.period.endDate,
              type: type);
      filterSalesPurchase();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future<void> getAccountList() async {
    try {
      accountsList = await ref
          .read(chartsOfAccountsRepositoryProvider)
          .getChartsOfAccountList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future<void> fetchReceivablesPayable({bool? refresh}) async {
    try {
      if (refresh == true) {
        receivablePayable = null;
      }
      if (receivablePayable == null) {
        state = const AsyncValue.loading();
      }
      receivablePayable =
          await ref.read(dashboardRepositoryProvider).getReceivablesPayable();
      await getAccountList();
      await fetchGraphData(refresh: true);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  filterSalesPurchase() {
    List monthlyData = salesPurchaseData?.monthlyData ?? [];
    incomeData = [];
    expenseData = [];
    monthlyData.forEach((v) {
      if (v.name == monthlyData.first.name) {
        incomeData.add(v);
      } else {
        expenseData.add(v);
      }
    });
  }


}

class QuickLickModel {
  QuickLickModel({
    required this.image,
    required this.name,
    required this.route,
    required this.enabled,
  });

  final String image;
  final String name;
  final String route;
   bool enabled;

  factory QuickLickModel.fromJson(Map<String, dynamic> json) => QuickLickModel(
    image: json['image'],
    name: json['name'],
    route: json['route'],
    enabled: json['enabled'],
  );

  Map<String, dynamic> toJson() => {
    'image': image,
    'name': name,
    'route': route,
    'enabled': enabled,
  };
}

class SalesPurchaseFilter {
  SalesPurchaseFilter(
      {required this.text, required this.period, this.isSelected = false});

  final String text;
  final FromDateToDate period;
  final bool isSelected;
}
