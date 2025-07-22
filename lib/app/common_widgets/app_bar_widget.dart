import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import '../styles/text_styles.dart';
import 'app_text_field_widgets/app_text_field_widget.dart';

// ignore: must_be_immutable
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {super.key,
      this.constraints,
      this.onChanged,
      this.onClear,
      this.onEditingComplete,
      this.textCtrl,
      this.focusNode,
      this.toolbarHeight,
      this.isSearchBar = false,
      this.elevation,
      required this.isEmptyBar,
      this.title,
      this.titleWidget,
      this.leadingWidget,
      this.leadingWidth,
      this.actions,
      this.backgroundColor,
      this.bottom,
      this.automaticallyImplyLeading});

  AppBarWidget.empty(
      {super.key,
      this.constraints,
      this.onChanged,
      this.onClear,
      this.onEditingComplete,
      this.textCtrl,
      this.focusNode,
      this.toolbarHeight,
      this.elevation,
      this.isEmptyBar = true,
      this.isSearchBar = false,
      this.title,
      this.titleWidget,
      this.leadingWidget,
      this.leadingWidth,
      this.actions,
      this.backgroundColor,
      this.bottom,
      this.automaticallyImplyLeading});

  final bool isEmptyBar;
  bool isSearchBar;
  final double? elevation;
  final String? title;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final double? leadingWidth;
  final double? toolbarHeight;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool? automaticallyImplyLeading;
  final Function()? onEditingComplete;
  final Function()? onClear;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final BoxConstraints? constraints;
  final TextEditingController? textCtrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      leading: leadingWidget,
      leadingWidth: leadingWidth ?? 35.w,
      automaticallyImplyLeading:
          isSearchBar ? false : automaticallyImplyLeading ?? true,
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      centerTitle: false,
      actions: isSearchBar
          ? [
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onClear!();
                },
                icon: Icon(Icons.clear),
              ),
            ]
          : actions,
      title: isSearchBar
          ? AppTextFieldWidget(
              autoFocus: true,
              ctrl: textCtrl,
              hintText: 'Search',
              filled: true,
              cursorHeight: 20,
              textFieldPadding: 0,
              fillColor: AppColors.seaShellGreyColor,
              focusNode: focusNode,
              style: AppTextStyle.titleMedium,
              hintStyle: AppTextStyle.titleSmall,
              contentPadding: EdgeInsets.only(left: 8.w),
              constraints: BoxConstraints(maxHeight: 35.h),
              maxLines: 1,
              inputBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15.r)),
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
            )
          : isEmptyBar
              ? Text(title ?? '', style: AppTextStyle.darkBlackFS16FW500)
              : titleWidget,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
