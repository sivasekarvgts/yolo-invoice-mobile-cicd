import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/features/dashboard/view/dashboard_controller.dart';

import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../locator.dart';
import 'customizable_links_page.dart';

class CustomizableCardWidget extends StatefulWidget {
  const CustomizableCardWidget({super.key,this.quickLinkCard});
  final List<QuickLickModel>? quickLinkCard;
  @override
  State<CustomizableCardWidget> createState() => _CustomizableCardWidgetState();
}

class _CustomizableCardWidgetState extends State<CustomizableCardWidget> {
  double _offset = 0;
  final double _maxOffset = 85.w;


  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset -= details.delta.dx;
      if (_offset < 0) _offset = 0;
      if (_offset > _maxOffset) _offset = _maxOffset;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _offset = _offset > _maxOffset / 2 ? _maxOffset : 0;
    });
  }

  Future<void> onActionTap() async {
    setState(() {
      _offset = 0;
    });
    await  dialogService.showBottomSheet(
        isDivider: false,
        showCloseIcon: false,
        dismissable: true,
        showActionBar: false,
        child:CustomizableLinksPage()
    );
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final  quickLinkCards = widget.quickLinkCard ?? preferenceService.getDashboardLink().where((element) => element.enabled==true,).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Stack(
        children: [
          // Action Buttons behind card
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               InkWell(
                 onTap:(){
                   onActionTap();
                 } ,
                 child: Column(
                   children: [
                     Container(
                       height: MediaQuery.of(context).size.width / 7,
                       width: MediaQuery.of(context).size.width / 7,
                       decoration: BoxDecoration(
                           color: AppColors.primary.withOpacityValue(.3),
                           borderRadius: BorderRadius.circular(
                               MediaQuery.of(context).size.width / 3),
                           border: Border.all(
                               color: AppColors.boarderWhite)),
                       child: Padding(
                         padding: const EdgeInsets.all(16),
                         child: SvgPicture.asset(
                           Svgs.tune,
                           height: 22.h,
                           colorFilter: ColorFilter.mode(
                               AppColors.darkBlackColor,
                               BlendMode.srcIn),
                         ),
                       ),
                     ),
                     gapH4,
                     Text(
                       "CUSTOMIZE",
                       style:
                       AppTextStyle.labelExtraSmall,
                     )
                   ],
                 )
               ),

              ],
            ),
          ),

          // The Card
          GestureDetector(
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: AnimatedContainer(
              color: AppColors.scaffoldBackground,
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.translationValues(-_offset, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            navigationService.pushNamed(
                              quickLinkCards[index].route,
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 7,
                            width: MediaQuery.of(context).size.width / 7,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width / 3),
                                border: Border.all(
                                    color: AppColors.boarderWhite)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: (quickLinkCards.length<4&&(index+1)>quickLinkCards.length)?
                                  Icon(CupertinoIcons.question,size: 23,):
                              SvgPicture.asset(
                                quickLinkCards[index].image,
                                colorFilter: ColorFilter.mode(
                                    AppColors.darkBlackColor,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                        gapH4,
                        Text(
                          (quickLinkCards.length<4&&(index+1)>quickLinkCards.length)?"": quickLinkCards[index].name,
                          style:
                          AppTextStyle.labelExtraSmall,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
