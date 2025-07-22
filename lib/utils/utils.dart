import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/locator.dart';

class Utils {
  BuildContext? get cxt => navigationService.navigatorKey.currentContext;

  // Get full screen height
  double get screenHeight => MediaQuery.of(cxt!).size.height;

  // Get safe area padding
  double get bottomSize => MediaQuery.of(cxt!).padding.bottom;

  double get topSize => MediaQuery.of(cxt!).padding.top;

  // Get app bar height (customize based on your app)
  double get appBarHeight => kToolbarHeight; // Standard height (56.0)

  // Get bottom navigation height (customize based on your app)
  double get bottomNavHeight =>
      kBottomNavigationBarHeight; // Standard height (56.0)

  // Available height for content
  double get availableHeight =>
      screenHeight - topSize - bottomSize - appBarHeight;
}
