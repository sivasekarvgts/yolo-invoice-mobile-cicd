import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/colors.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    this.needTrailing = false,
    required this.visibilityOfFloating,
    this.label,
    this.icon,
    this.padding,
    this.needAddButton=true,
    this.onTap,
    this.openDropdown,
  });

  final bool visibilityOfFloating;
  final bool needTrailing;
  final bool needAddButton;
  final String? label;
  final IconData? icon;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final void Function()? openDropdown;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 52,
      child: FloatingActionButton(onPressed:onTap,
      backgroundColor: AppColors.greyColor,
        child: Icon(icon??Icons.add,color: AppColors.white,),
      ),
    );
  }
}




class OutlineFloatingButton extends StatelessWidget {
  const OutlineFloatingButton({
    super.key,
    this.needTrailing = false,
    required this.visibilityOfFloating,
    this.label,
    this.icon,
    this.padding,
    this.onTap,
    this.size,
    this.openDropdown,
  });

  final bool visibilityOfFloating;
  final bool needTrailing;
  final String? label;
  final double? size;
  final IconData? icon;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final void Function()? openDropdown;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: padding ?? EdgeInsets.all(10.h),
        height:size?? 48,
        width:size?? 48,
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child:Icon(Icons.add_card,color: AppColors.white,)
      ),
    );
  }
}





// import 'package:flutter/material.dart';
//
// import '../styles/colors.dart';
//
// class FloatingButton extends StatelessWidget {
//   const FloatingButton({
//     super.key,
//     this.needTrailing = false,
//     required this.visibilityOfFloating,
//     this.label,
//     this.icon,
//     this.padding,
//     this.needAddButton=true,
//     this.onTap,
//     this.openDropdown,
//   });
//
//   final bool visibilityOfFloating;
//   final bool needTrailing;
//   final bool needAddButton;
//   final String? label;
//   final IconData? icon;
//   final EdgeInsets? padding;
//   final void Function()? onTap;
//   final void Function()? openDropdown;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: padding ?? EdgeInsets.all(10.h),
//         height: 48,
//         decoration: BoxDecoration(
//           // color: AppColors.primary,
//           borderRadius: BorderRadius.circular(100.r),
//           border: Border.all(color: AppColors.primary,)
//         ),
//         child: Row(
//           children: [
//             if (needTrailing) const Spacer(flex: 3),
//             Expanded(
//               flex: 10,
//               child: Row(
//                 spacing: 8.h,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if(needAddButton) Icon(Icons.add, size: 16.h, color: AppColors.primary),
//
//                   Text(label ?? "", style: AppTextStyle.blueFS14FW500),
//                 ],
//               ),
//             ),
//             if (needTrailing)
//               Expanded(
//                 flex: 3,
//                 child: InkWell(
//                   onTap: openDropdown,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                         child: VerticalDivider(
//                           width: 2.w,
//                           thickness: 1,
//                           color: AppColors.white,
//                         ),
//                       ),
//                       gapW8,
//                       Icon(Icons.keyboard_arrow_down,
//                           size: 16.h, color: AppColors.white),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// class OutlineFloatingButton extends StatelessWidget {
//   const OutlineFloatingButton({
//     super.key,
//     this.needTrailing = false,
//     required this.visibilityOfFloating,
//     this.label,
//     this.icon,
//     this.padding,
//     this.onTap,
//     this.openDropdown,
//   });
//
//   final bool visibilityOfFloating;
//   final bool needTrailing;
//   final String? label;
//   final IconData? icon;
//   final EdgeInsets? padding;
//   final void Function()? onTap;
//   final void Function()? openDropdown;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: padding ?? EdgeInsets.all(10.h),
//         height: 48,
//         width: 48,
//         decoration: BoxDecoration(
//           color: AppColors.greyColor,
//           borderRadius: BorderRadius.circular(100.r),
//         ),
//         child:Icon(Icons.add,color: AppColors.white,)
//       ),
//     );
//   }
// }
//
//
//

//
// import 'package:flutter/material.dart';
//
// import '../styles/colors.dart';
//
// class FloatingButton extends StatelessWidget {
//   const FloatingButton({super.key,required this.onTap,this.label,required this.visibilityOfFloating,this.icon});
//
//
//   final void Function()? onTap;
//   final bool visibilityOfFloating;
//   final String? label;
//   final IconData? icon;
//   @override
//   Widget build(BuildContext context) {
//     return
//       Container(
//       margin: EdgeInsets.all(10.h),
//       height: 48,
//       width: 48,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: AppColors.primary)
//       ),
//       child:
//     );
    //   FloatingActionButton(
    //   backgroundColor: Colors.white,
    //   elevation: 2.6,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(12))),
    //   onPressed: onTap,
    //   child: Icon(icon??Icons.add,size:  visibilityOfFloating?null:0,),
    // );
//   }
// }
