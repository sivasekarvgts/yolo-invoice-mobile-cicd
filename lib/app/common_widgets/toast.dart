
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastService {
  //final NavigationService _navigationService = locator<NavigationService>();

  showWidget({required Widget child, int? durationInSeconds}) {
    return showToastWidget(
      child,
      //context: _navigationService.navigatorKey.currentContext,
      animation: StyledToastAnimation.slideFromBottom,
      reverseAnimation: StyledToastAnimation.slideToBottom,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 300),
      duration: Duration(seconds: durationInSeconds ?? 3),
      curve: Curves.easeIn,
      isIgnoring: false,
      isHideKeyboard: true,
      reverseCurve: Curves.easeOut,
    );
  }

  showText({String? text}) {
    return showToast(
      text,
      //context: _navigationService.navigatorKey.currentContext,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
