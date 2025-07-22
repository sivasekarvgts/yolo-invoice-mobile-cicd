import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../new_client_controller.dart';

class CountryListWidget extends ConsumerStatefulWidget {
  const CountryListWidget({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CountryListWidgetState();
}

class _CountryListWidgetState extends ConsumerState<CountryListWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    final state = ref.watch(newClientControllerProvider);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      // const AppBottomSheetTitleWidget(title: 'Choose State'),
      if (controller.countryList.isEmpty)
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
                final item = controller.countryList[i];
                return InkWell(
                  onTap: () => controller.onSelectCountry(
                    item,
                  ),
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
                        if (controller.selectedCountry.id == item.id)
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
              itemCount: controller.countryList.length,
              separatorBuilder: (_, i) => const Divider(height: 1),
            )),
    ]);
  }
}
