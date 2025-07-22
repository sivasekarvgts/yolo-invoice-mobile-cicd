import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/dialog_service/alert_request.dart';
import '../../services/dialog_service/alert_response.dart';

class DialogService {
  final _dialogNavigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;
  Function(AlertRequest)? _showDialogListener;
  Function(AlertRequest)? _showCustomDialogListener;
  Function(AlertRequest)? _showPositionedDialogListener;
  Function(AlertRequest)? _showConfirmationDialogListener;
  Function(AlertRequest)? _showSelectDialogListener;
  Function(AlertRequest)? _bottomSheetListener;

  Completer<AlertResponse>? _dialogCompleter;

  bool get hasActiveDialog => _dialogCompleter != null;

  void registerDialogListener(
    Function(AlertRequest) showDialogListener,
    Function(AlertRequest) showCustomDialogListener,
    Function(AlertRequest) showPositionedDialogListener,
    Function(AlertRequest) showConfirmationDialogListener,
    Function(AlertRequest) showSelectDialogListener,
    Function(AlertRequest) bottomSheetListener,
  ) {
    _showDialogListener = showDialogListener;
    _showCustomDialogListener = showCustomDialogListener;
    _showPositionedDialogListener = showPositionedDialogListener;
    _showConfirmationDialogListener = showConfirmationDialogListener;
    _showConfirmationDialogListener = showConfirmationDialogListener;
    _showSelectDialogListener = showSelectDialogListener;
    _bottomSheetListener = bottomSheetListener;
  }

  Future<AlertResponse>? showDialog(
      {String title = 'Message',
      String description = '',
      String buttonTitle = 'OK',
      bool dismissable = true}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener!(AlertRequest(
        description: description,
        buttonTitle: buttonTitle,
        title: title,
        dismissable: dismissable));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? showCustomAlertDialog(
      {String? image,
      String? title,
      String? subtitle,
      String primaryButton = 'OK',
      String? secondaryButton}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showCustomDialogListener!(AlertRequest(
        image: image,
        description: subtitle,
        buttonTitle: primaryButton,
        secondaryButtonTitle: secondaryButton,
        title: title));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? showPositionedAlertDialog(
      {String? title, Widget? child, bool dismissable = true,double? left,double? right,double? top,double? bottom,double? width,}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showPositionedDialogListener!(AlertRequest.position(
        title: title, contentWidget: child, dismissable: dismissable,left: left,right: right,bottom: bottom,top: top,width: width ));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? showConfirmationAlertDialog(
      {String? image,
      String? title,
      String? subtitle,
      String primaryButton = 'OK',
      String? secondaryButton,
      bool dismissable = true}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showConfirmationDialogListener!(AlertRequest(
        image: image,
        description: subtitle,
        buttonTitle: primaryButton,
        secondaryButtonTitle: secondaryButton,
        title: title,

        dismissable: dismissable));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? showSelectDialog(
      {String? title, Widget? child, bool dismissable = true}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showSelectDialogListener!(AlertRequest(
        title: title, contentWidget: child, dismissable: dismissable));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? showBottomSheet(
      {String? title,
      Widget? iconWidget,
      required Widget child,
      bool dismissable = true,
      bool showActionBar = true,
      bool showCloseIcon = true,
      bool isDivider = true}) {
    _dialogCompleter = Completer<AlertResponse>();
    _bottomSheetListener!(AlertRequest(
        title: title,
        iconWidget: iconWidget,
        dismissable: dismissable,
        contentWidget: child,
        showActionBar: showActionBar,
        showCloseIcon: showCloseIcon,
        isDivider: isDivider));

    return _dialogCompleter?.future;
  }

  Future<AlertResponse>? bottomSheetList({required Widget child}) {
    _dialogCompleter = Completer<AlertResponse>();
    _bottomSheetListener!(AlertRequest(contentWidget: child));

    return _dialogCompleter?.future;
  }

  void dialogComplete(AlertResponse alertResponse) {
    _dialogCompleter?.complete(alertResponse);
    _dialogNavigationKey.currentState?.pop(alertResponse);
    _dialogCompleter = null;
  }

  void dialogMaybeComplete(AlertResponse alertResponse) {
    _dialogCompleter?.complete(alertResponse);
    _dialogNavigationKey.currentState?.maybePop(alertResponse);
    _dialogCompleter = null;
  }
}
