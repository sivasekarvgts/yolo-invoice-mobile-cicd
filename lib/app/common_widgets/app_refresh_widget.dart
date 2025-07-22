import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class AppRefreshWidget extends StatelessWidget {
  const AppRefreshWidget(
      {super.key,
      this.controller,
      this.onRefresh,
      this.onLoad,
      required this.childBuilder});
  final FutureOr<dynamic> Function()? onLoad;
  final FutureOr<dynamic> Function()? onRefresh;
  final EasyRefreshController? controller;
  final Widget Function(BuildContext, ScrollPhysics)? childBuilder;
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: controller,
      header: const CupertinoHeader(),
      footer:  ClassicFooter(
        messageBuilder: (context, state, text, dateTime) => const SizedBox(),
        textBuilder: (context, state, text) => const Text("Loading"),
      ),
      onLoad: onLoad,
      onRefresh: onRefresh,
      childBuilder: childBuilder,
    );
  }
}
