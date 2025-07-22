import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class SalutationWidget extends ConsumerStatefulWidget {
  const SalutationWidget({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalutationWidgetState();
}

class _SalutationWidgetState extends ConsumerState<SalutationWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const AppBottomSheetTitleWidget(title: 'GST Status'),
        if (controller.salutationList.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Data'),
          ))
        else
          Flexible(
              child: ListView.separated(
            itemBuilder: (_, i) {
              final item = controller.salutationList[i];
              return InkWell(
                onTap: () => controller.onSelectSalutation(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name!, style: AppTextStyle.bodyMedium),
                      if (controller.selectedSalutationValue.id == item.id)
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
            itemCount: controller.salutationList.length,
            separatorBuilder: (_, i) => const Divider(height: 1),
          )),
      ],
    );
  }
}
