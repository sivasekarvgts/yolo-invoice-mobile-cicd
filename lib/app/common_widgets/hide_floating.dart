import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

mixin HideFloating {
  ScrollController? hideButtonController;
  bool visibilityOfFloating = true;

  hideButtonListener(void Function() setState) {
    hideButtonController!.addListener(() {
      if (hideButtonController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (visibilityOfFloating == true) {
          visibilityOfFloating = false;
          setState();
        }
      } else {
        if (hideButtonController!.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (visibilityOfFloating == false) {
            visibilityOfFloating = true;
            setState();
          }
        }
      }
    });
  }
}
