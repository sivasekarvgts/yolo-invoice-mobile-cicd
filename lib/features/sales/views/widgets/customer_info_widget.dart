import 'package:flutter/material.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/constants/app_sizes.dart';

import '../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../app/common_widgets/network_image_loader.dart';

class CustomerInfoWidget extends StatelessWidget {
  const CustomerInfoWidget(
      {super.key,
      this.onChange,
      this.padding,
      this.unPaidBillText,
      this.isLoading = false,
      this.isEnabled = true,
      required this.image,
      required this.address,
      required this.name});
  final String name;
  final String image;
  final String address;
  final bool isLoading;
  final bool isEnabled;
  final EdgeInsets? padding;
  final void Function()? onChange;
  final List<String>? unPaidBillText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        children: [
          if (isLoading)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerWidget.circular(
                      width: 45,
                      height: 45,
                    ),
                    gapW8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget.text(height: 15, width: 150),
                        gapH4,
                        ShimmerWidget.text(height: 12, width: 70),
                      ],
                    ),
                  ],
                ),
                ShimmerWidget.text(height: 15, width: 70),
              ],
            )
          else
            IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        NetworkImageLoader(
                          width: 35,
                          height: 35,
                          borderRadius: BorderRadius.circular(25),
                          image: image,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.blackFS16FW600),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Text(address,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.greyFS12FW600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEnabled)
                    InkWell(
                        onTap: onChange,
                        child:
                            Text('Change', style: AppTextStyle.blueFS12FW500))
                ],
              ),
            ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
