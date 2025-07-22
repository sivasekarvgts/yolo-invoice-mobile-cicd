import 'package:flutter/material.dart';

class AppOutsideFocusRemover extends StatelessWidget {
  final Widget child;

  AppOutsideFocusRemover({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: this.child),
    );
  }
}

