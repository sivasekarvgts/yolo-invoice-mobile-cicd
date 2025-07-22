import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

class GenericSheet<T> extends StatelessWidget {
  const GenericSheet({
    super.key,
    required this.onTap,
    required this.dataList,
    required this.selectedData,
    required this.nameExtractor,
    this.bottomWidget,
  });

  final List<T> dataList;
  final T? selectedData;
  final String? Function(T) nameExtractor;
  final void Function(T) onTap;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dataList.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(child: Text('No Data Found')),
          )
        else
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: dataList.length > 8
                    ? MediaQuery.of(context).size.height * 0.5
                    : null,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dataList.length,
                  itemBuilder: (_, i) {
                    final item = dataList[i];
                    return InkWell(
                      onTap: () {
                        onTap(item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(nameExtractor(item) ?? "-",
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.darkBlackFS16FW500),
                            ),
                            if (selectedData == item)
                              const Icon(Icons.radio_button_checked_outlined,
                                  size: 20, color: AppColors.blueColor)
                            else
                              const Icon(Icons.radio_button_off_outlined,
                                  size: 20)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        bottomWidget ?? SizedBox()
      ],
    );
  }
}

class AddWidgetOnBottom extends StatelessWidget {
  const AddWidgetOnBottom(
      {super.key, required this.label, this.prefix, this.onTap});
  final String label;
  final Widget? prefix;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: prefix ??
                        Icon(
                          Icons.add,
                          color: AppColors.primary,
                          size: 24,
                        ),
                  ),
                  Text(
                    label,
                    style: AppTextStyle.blueFS14FW500.copyWith(fontSize: 16.sp),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
