import 'package:flutter/material.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/master_model/tds_tcs_section_model.dart';

class TdsTcsTypeSheet extends StatelessWidget {
  const TdsTcsTypeSheet(
      {super.key,
      required this.tdsTcsSectionList,
      required this.selectedTdsTcsModel,
      required this.onTap});
  final List<TdsTcsSectionModel> tdsTcsSectionList;
  final TdsTcsSectionModel selectedTdsTcsModel;
  final Function(TdsTcsSectionModel item) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tdsTcsSectionList.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final item = tdsTcsSectionList[i];
                  return InkWell(
                    onTap: () => onTap(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(item.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.darkBlackFS16FW500),
                          ),
                          if (item.id == selectedTdsTcsModel.id)
                            const Icon(Icons.radio_button_checked_outlined,
                                size: 20, color: AppColors.blueColor)
                          else
                            const Icon(Icons.radio_button_off_outlined,
                                size: 20)
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
