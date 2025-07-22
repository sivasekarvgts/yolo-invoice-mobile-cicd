import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';

import '../../../../app/common_widgets/button.dart';
import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_recepit_decoration_painter.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../locator.dart';
import '../../models/master_model/price_list_model.dart';

class SelectPriceList extends StatelessWidget {
  const SelectPriceList(
      {super.key, required this.selectedPriceList, required this.priceList});
  final List<PriceListModel>? priceList;
  final PriceListModel? selectedPriceList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.empty(title: 'Select Price List'),
      body: SingleChildScrollView(
          child: SalesOrderPriceList(
        selectedPriceList: selectedPriceList,
        priceList: priceList ?? [],
      )),
    );
  }
}

class SalesOrderPriceList extends StatelessWidget {
  const SalesOrderPriceList(
      {super.key, required this.selectedPriceList, required this.priceList});
  final List<PriceListModel?> priceList;
  final PriceListModel? selectedPriceList;

  @override
  Widget build(BuildContext context) {
    if (priceList.isEmpty) {
      return const Center(child: Text('No Price List Found'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: priceList.length,
        itemBuilder: (_, i) {
          final item = priceList[i];
          return _PriceListItemCard(
            item!,
            isApplied: selectedPriceList?.id == item.id,
            onApply: () {
              navigationService.pop(returnValue: item);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 20);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _PriceListItemCard extends StatelessWidget {
  PriceListModel item;
  bool isApplied;
  Function onApply;

  _PriceListItemCard(this.item,
      {required this.isApplied, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AppRecepitDecorationPainter(),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.name?.capitalizeFirst}',
                        style: AppTextStyle.blackFS16FW600),
                    const SizedBox(height: 3),
                    if (item.description != null)
                      Text(
                        item.description ?? '-',
                        maxLines: 4,
                        textAlign: TextAlign.start,
                        style: AppTextStyle.fuscousGreyFS14FW400,
                      ),
                  ]),
            ),
            const SizedBox(height: 12),
            const DottedLine(
                dashColor: AppColors.dividerGreyColor,
                dashLength: 5,
                lineThickness: 1.2),
            AppButton.outline(
              isApplied ? 'Applied' : 'Apply',
              key: Key('price-list'),
              borderColor: Colors.white,
              onPressed: () async {
                if (isApplied) return null;
                onApply();
              },
              textStyle: AppTextStyle.blueFS14FW500
                  .copyWith(color: isApplied ? AppColors.greenColor : null),
            ),
          ],
        ),
      ),
    );
  }
}
