import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class GstStatusWidget extends ConsumerStatefulWidget {
  const GstStatusWidget({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GstStatusWidgetState();
}

class _GstStatusWidgetState extends ConsumerState<GstStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const AppBottomSheetTitleWidget(title: 'GST Status'),
        if (controller.gstList.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Data'),
          ))
        else
          Flexible(
              child: ListView.separated(
            itemBuilder: (_, i) {
              final item = controller.gstList[i];
              return InkWell(
                onTap: () => controller.onSelectGST(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name!, style: AppTextStyle.bodyMedium),
                      if (controller.selectedGSTValue.id == item.id)
                        const Icon(Icons.radio_button_checked_outlined,
                            size: 20, color: AppColors.primary)
                      else
                        const Icon(Icons.radio_button_off_outlined, size: 20)
                    ],
                  ),
                ),
              );
            },
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.gstList.length,
            separatorBuilder: (_, i) => const Divider(height: 1),
          )),
      ],
    );
  }
}
