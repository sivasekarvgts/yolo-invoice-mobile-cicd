import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';

import '../../styles/text_styles.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, this.physics, this.reducePercent, this.msg ="No Data !", this.isLogo=true});

  final ScrollPhysics? physics;
  final double? reducePercent;
  final bool isLogo;
  final String msg;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final reducePercentValue = (reducePercent ?? 0).clamp(0, 100);
    final adjustedHeight =
        height * (1 - reducePercentValue / 100) - (kTextTabBarHeight * 2);

    return SingleChildScrollView(
      physics: physics,
      child: SizedBox(
        height: adjustedHeight,
        child: Column(
mainAxisAlignment: MainAxisAlignment.center,
         children: [
           if (isLogo)
              Center(
                child: SvgPicture.asset(
                  Svgs.noData,
                 height: 70,
                 width: 70,
                  color: Colors.grey,
                             ),
              ),
           const SizedBox(height: 12),
           Text(
             msg,
             maxLines: 2,
             textAlign: TextAlign.center,
             style: AppTextStyle.greyFS16FW500,
           )
         ],
        ),
      ),
    );
  }
}
