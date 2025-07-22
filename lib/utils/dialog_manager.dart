import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../app/constants/app_sizes.dart';
import '../../app/constants/images.dart';
import '../../app/styles/colors.dart';
import '../../app/styles/text_styles.dart';
import '../../locator.dart';
import '../../services/dialog_service/alert_request.dart';
import '../../services/dialog_service/alert_response.dart';
import '../../services/event_bus_service.dart';
import '../app/styles/dark_theme.dart';
import '../router.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final _dialogService = dialogService;

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(
      _showInfoDialog,
      _showCustomAlertDialog,
      _showPositionedDialog,
      _showConfirmationDialog,
      _showSelectDialog,
      _bottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    var haveLogScreen = false;
    return Stack(
      children: [
        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: widget.child),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder(
                stream: eventBusService.eventBus.on<GlobalMessageHandler>(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    GlobalMessageHandler data =
                        snapshot.data as GlobalMessageHandler;
                    if (data.show == true) {
                      return Material(
                        color: Colors.transparent,
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          child: SafeArea(
                              top: false,
                              child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        (snapshot.data as GlobalMessageHandler)
                                            .message,
                                        textScaler: TextScaler.linear(1),
                                        style: AppTextStyle.bodyMedium
                                            .copyWith(color: Colors.white, fontFamily: "Manrope"),
                                      )),
                                      TextButton(
                                          onPressed: () {
                                            eventBusService.eventBus.fire(
                                                GlobalMessageHandler("Success",
                                                    show: false));
                                          },
                                          child: const Text("Close"))
                                    ],
                                  ))),
                        ),
                      );
                    }
                  }
                  return Container();
                })),
        if (appConfigService.envString != "PROD")
          DraggableFab(
            initPosition: Offset(MediaQuery.sizeOf(context).width - 60, 100),
            child: FloatingActionButton(
              elevation: 0.5,
              backgroundColor: Colors.white,
              onPressed: () {
                if (haveLogScreen) {
                  navigationService.pop();
                  return;
                }
                haveLogScreen = true;
                navigationService.pushNamed(Routes.showLogMessages)?.then((v) {
                  haveLogScreen = false;
                });
              },
              child: Image.asset(
                Images.appIcon,
                height: 40,
                width: 40,
              ),
            ),
          ),
      ],
    );
  }

  void _showInfoDialog(AlertRequest request) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: request.dismissable,
        builder: (context) {
          return PopScope(
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop)
                  _dialogService.dialogComplete(AlertResponse(status: false));
              },
              child: CupertinoAlertDialog(
                title: Text(
                  request.title ?? '',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope",
                      color: AppColors.textOnBackground,
                      letterSpacing: 0.5),
                ),
                content: Text(request.description ?? '',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Manrope",
                        color: AppColors.textOnBackground,
                        letterSpacing: 0.5)),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      request.buttonTitle ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Manrope",
                          color: AppColors.primary,
                          letterSpacing: 0.5),
                    ),
                    onPressed: () {
                      _dialogService
                          .dialogComplete(AlertResponse(status: true));
                    },
                  ),
                ],
              ));
        });
  }

  void _showSelectDialog(AlertRequest request) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: request.dismissable,
        builder: (context) {
          return PopScope(
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop)
                  _dialogService.dialogComplete(AlertResponse(status: false));
              },
              child: CupertinoAlertDialog(
                  title: Row(
                    children: [
                      Text(
                        request.title ?? '',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Manrope",
                            color: AppColors.textOnBackground,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: request.contentWidget,
                  )
                  // actions: <Widget>[
                  //   CupertinoDialogAction(
                  //     child: Text(
                  //       request.buttonTitle ?? '',
                  //       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.primary, letterSpacing: 0.5),
                  //     ),
                  //     onPressed: () {
                  //       _dialogService.dialogComplete(AlertResponse(status: true));
                  //     },
                  //   ),
                  // ],
                  ));
        });
  }

  void _showConfirmationDialog(AlertRequest request) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return PopScope(
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop)
                  _dialogService.dialogComplete(AlertResponse(status: false));
              },
              child: CupertinoAlertDialog(
                title:
                    Text(request.title ?? '', style: AppTextStyle.titleSmall.copyWith(fontFamily: "Manrope")),
                content: (request.description == '' ||
                        request.description == null)
                    ? SizedBox.shrink()
                    : Text(request.description ?? '',
                        style: AppTextStyle.titleSmall.copyWith(fontSize: 13,fontFamily: "Manrope"),),
                actions: <Widget>[
                  if (request.secondaryButtonTitle != null)
                    CupertinoDialogAction(
                      child: Text(
                        request.secondaryButtonTitle ?? '',
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Manrope",
                            fontWeight: FontWeight.normal,
                            color: AppColors.primary,
                            letterSpacing: 0.5),
                      ),
                      onPressed: () {
                        _dialogService
                            .dialogComplete(AlertResponse(status: false));
                      },
                    ),
                  CupertinoDialogAction(
                    child: Text(
                      request.buttonTitle ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Manrope",
                          color: AppColors.primary,
                          letterSpacing: 0.5),
                    ),
                    onPressed: () {
                      _dialogService
                          .dialogComplete(AlertResponse(status: true));
                    },
                  ),
                ],
              ));
        });
  }

  void _showPositionedDialog(AlertRequest request) {
    showGeneralDialog(
      context: context,
      barrierDismissible: request.dismissable,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black38, // Background dim
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: GestureDetector(
            // DONOT REMOVE ONTAP
            onTap: (){  _dialogService
                .dialogComplete(AlertResponse(status: true));},
            child: Stack(
              children: [
                Positioned(
                  right: request.right,
                  left: request.left,
                  bottom: request.bottom??100,
                  top: request.top,
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: (){},
                      child: Center(
                        child: CupertinoPopupSurface(
                          child: Container(
                            width:request.width ??200,
                            padding: const EdgeInsets.all(16),
                            color: CupertinoColors.systemBackground,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Row(
                                //   children: [
                                //     Text(
                                //       request.title ?? '',
                                //       style: const TextStyle(
                                //           fontSize: 17,
                                //           fontWeight: FontWeight.w500,
                                //           color: AppColors.textOnBackground,
                                //           letterSpacing: 0.5),
                                //     ),
                                //   ],
                                // ),
                                request.contentWidget??SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showCustomAlertDialog(AlertRequest request) {
    showDialog(
        context: context,
        builder: (context) {
          return PopScope(
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop)
                _dialogService.dialogComplete(AlertResponse(status: false));
            },
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              content: Container(
                height: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.appIcon,
                      width: 100,
                      height: 100,
                    ),
                    gapH30,
                    Text(
                      request.title ?? '',
                      textScaler: TextScaler.linear(1),
                      style: AppTextStyle.headlineMedium.copyWith(fontFamily: "Manrope"),
                    ),
                    gapH20,
                    Text(
                      request.description ?? '',
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(1),
                      style: AppTextStyle.titleMedium.copyWith(fontFamily: "Manrope"),
                    ),
                    gapH20,
                    // TODO Button
                    // Button(request.buttonTitle ?? '', width: double.infinity, key: const Key('btnPrimary'), onPressed: () {
                    //   _dialogService.dialogComplete(AlertResponse(status: true));
                    // }),
                    request.secondaryButtonTitle != null
                        ? MaterialButton(
                            onPressed: () {
                              _dialogService
                                  .dialogComplete(AlertResponse(status: false));
                            },
                            child: Text(
                              request.secondaryButtonTitle ?? '',
                              textScaler: TextScaler.linear(1),
                              style: AppTextStyle.bodyMedium
                                  .copyWith(color: AppColors.primary, fontFamily: "Manrope"),
                            ))
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _bottomSheet(AlertRequest request) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: request.dismissable,
        enableDrag: request.dismissable,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              padding: MediaQuery.of(context).viewInsets,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.bottom > 0
                      ? MediaQuery.of(context).viewPadding.bottom
                      : 25),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              child: Wrap(
                children: [
                  if (request.showActionBar == true)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 4.h,
                        width: 63.w,
                        margin: EdgeInsets.only(top: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.boarderWhite,
                          borderRadius: BorderRadius.all(Radius.circular(25.r)),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 5.w, top: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (request.title != null)
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            child: Text(request.title ?? '',
                                textScaler: TextScaler.linear(1),
                                style: AppTextStyle.blackFS16FW600.copyWith(fontFamily: "Manrope")),
                          )),
                        if (request.iconWidget != null)
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: request.iconWidget,
                          ),
                        if (request.showCloseIcon == true)
                          IconButton(
                            onPressed: () {
                              _dialogService
                                  .dialogComplete(AlertResponse(status: false));
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.boarderWhite)),
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (request.isDivider == true) DarkTheme.customDivider,
                  SingleChildScrollView(
                      child: Wrap(
                    children: [
                      SafeArea(
                          child: request.contentWidget ?? const SizedBox()),
                    ],
                  )),
                ],
              ),
            ));
  }

  void bottomSheetList(AlertRequest request) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: request.dismissable,
        enableDrag: request.dismissable,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: request.contentWidget));
  }

  void showLogModlBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) => SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 20,
                child: ListView.separated(
                    itemCount: loggerService.logHistory.length,
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loggerService.logHistory[index].type,
                                    textScaler: TextScaler.linear(1),
                                    style: AppTextStyle.bodyMedium.copyWith(
                                        color: loggerService
                                            .logHistory[index].color, fontFamily: "Manrope"),
                                  ),
                                  gapW10,
                                  Text(
                                    loggerService.logHistory[index].time,
                                    textScaler: TextScaler.linear(1),
                                    style: AppTextStyle.titleSmall.copyWith(fontFamily: "Manrope"),
                                  ),
                                ],
                              ),
                              gapH5,
                              InkWell(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => Scaffold(
                                              appBar: AppBar(
                                                automaticallyImplyLeading:
                                                    false,
                                                elevation: 0,
                                                actions: [
                                                  IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ],
                                              ),
                                              body: SafeArea(
                                                child: ListView(
                                                  padding: EdgeInsets.all(5),
                                                  children: [
                                                    InkWell(
                                                        onLongPress: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: loggerService
                                                                      .logHistory[
                                                                          index]
                                                                      .message));
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Copied to Clipboard",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors
                                                                      .black54,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0);
                                                        },
                                                        child: Text(
                                                            loggerService
                                                                .logHistory[
                                                                    index]
                                                                .message))
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: Text(
                                    loggerService.logHistory[index].message,
                                    textScaler: TextScaler.linear(1),
                                    maxLines:
                                        loggerService.logHistory[index].expanded
                                            ? null
                                            : 3,
                                    style: AppTextStyle.bodyMedium.copyWith(fontFamily: "Manrope"),
                                  ))
                            ],
                          ));
                    }),
              ),
            ));
  }
}
