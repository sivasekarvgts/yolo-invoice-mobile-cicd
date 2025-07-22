import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class BusinessCategoryWidget extends ConsumerStatefulWidget {
  const BusinessCategoryWidget({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BusinessCategoryWidgetState();
}

class _BusinessCategoryWidgetState
    extends ConsumerState<BusinessCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.businessCategoryList.isEmpty)
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(controller.selectedBusinessType == 0
                ? 'Please Select Business Type'
                : 'No Data'),
          ))
        else
          SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.separated(
                itemBuilder: (_, i) {
                  final item = controller.businessCategoryList[i];
                  return InkWell(
                    onTap: () => controller.onSelectBusinessCategory(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name!, style: AppTextStyle.bodyMedium),
                          if (controller.selectedBusinessCategory == item.id)
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.businessCategoryList.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
              )),
      ],
    );
  }
}
