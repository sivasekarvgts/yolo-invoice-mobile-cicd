import 'package:flutter/cupertino.dart';

class AlertRequest {
  final String? image;
  final String? title;
  final String? description;
  final String? buttonTitle;
  final String? secondaryButtonTitle;
  final bool dismissable;

  final Widget? iconWidget;
  final Widget? contentWidget;
  final bool? showActionBar;
  final bool? isDivider;
  final bool? showCloseIcon;
    double? right;
    double? left;
    double? top;
    double? bottom;
    double? width;

  AlertRequest(
      {this.image,
      this.title,
      this.description,
      this.buttonTitle,
      this.secondaryButtonTitle,
      this.dismissable = true,
      this.isDivider = false,
      this.iconWidget,
      this.contentWidget,
      this.showActionBar,
      this.showCloseIcon});

  AlertRequest.position(
      {this.image,
      this.title,
      this.description,
      this.buttonTitle,
      this.secondaryButtonTitle,
      this.dismissable = true,
      this.isDivider = false,
      this.iconWidget,
      this.contentWidget,
      this.showActionBar,
      this.showCloseIcon,
      this.right,
      this.left,
      this.bottom,
      this.top,
      this.width ,
      });
}
