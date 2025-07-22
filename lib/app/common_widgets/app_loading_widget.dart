import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppOverlayLoaderWidget extends StatelessWidget {
  const AppOverlayLoaderWidget(
      {super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
           BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            // opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black38),
          ),
        if (isLoading) const Center(child: AppLoadingWidget()),
      ],
    );
  }
}


class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget(
      {super.key,
        this.color,
        this.isIosLoader,
        this.strokeWidth = 2,
        this.text = 'Loading...',
        this.isCircularBar = true,
        this.isText = false});
  final Color? color;
  final String? text;
  final bool? isText;
  final bool? isIosLoader;
  final double strokeWidth;
  final bool isCircularBar;

  @override
  Widget build(BuildContext context) {
    if (isIosLoader == true) return const CupertinoActivityIndicator();
    if (!isCircularBar) {
      return LinearProgressIndicator(color: color);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
                color: color, strokeWidth: strokeWidth)),
        if (isText!)
          Padding(padding: const EdgeInsets.only(left: 12), child: Text(text!))
      ],
    );
  }
}