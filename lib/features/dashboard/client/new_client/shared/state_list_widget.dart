import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class StateListWidget extends ConsumerStatefulWidget {
  const StateListWidget({super.key, this.isShipping = true});
  final bool isShipping;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StateListWidgetState();
}

class _StateListWidgetState extends ConsumerState<StateListWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    ref.watch(newClientControllerProvider);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (controller.stateList.isEmpty)
        const Center(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No Data'),
        ))
      else
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.separated(
              itemBuilder: (_, i) {
                final item = controller.stateList[i];
                return InkWell(
                  onTap: () =>
                      controller.onSelectState(item, widget.isShipping),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item.name!,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bodyMedium),
                        ),
                        if ((widget.isShipping &&
                                controller.shippingStateId ==
                                    item.id.toString()) ||
                            (!widget.isShipping &&
                                controller.billingStateId ==
                                    item.id.toString()))
                          const Icon(Icons.radio_button_checked_outlined,
                              size: 20, color: AppColors.blueColor)
                        else
                          const Icon(Icons.radio_button_off_outlined, size: 20)
                      ],
                    ),
                  ),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.stateList.length,
              separatorBuilder: (_, i) => const Divider(height: 1),
            )),
    ]);
  }
}
