import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class BusinessTypeWidget extends ConsumerStatefulWidget {
  const BusinessTypeWidget({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BusinessTypeWidgetState();
}

class _BusinessTypeWidgetState extends ConsumerState<BusinessTypeWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const AppBottomSheetTitleWidget(title: 'Business Type'),
        if (controller.businessTypeList.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Data'),
          ))
        else
          Flexible(
              child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (_, i) {
              final item = controller.businessTypeList[i];
              return InkWell(
                onTap: () => controller.onSelectBusinessType(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name!, style: AppTextStyle.bodyMedium),
                      if (controller.selectedBusinessType == item.id)
                        const Icon(Icons.radio_button_checked_outlined,
                            size: 20, color: AppColors.primary)
                      else
                        const Icon(Icons.radio_button_off_outlined, size: 20)
                    ],
                  ),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.businessTypeList.length,
            separatorBuilder: (_, i) => const Divider(height: 1),
          )),
      ],
    );
  }
}
