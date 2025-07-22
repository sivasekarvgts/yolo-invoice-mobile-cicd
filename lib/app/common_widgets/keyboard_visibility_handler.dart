// // ignore_for_file: must_be_immutable
//
// import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//
// class KeyboardVisibilityWidget extends StatefulWidget {
//   // double keyboardPadding;
//   ScrollController scrollController;
//
//   BuildContext parentBuildContext;
//   final Widget Function(bool isKeyboardVisible, double keyboardPadding) builder;
//   //
//   KeyboardVisibilityWidget({required this.scrollController, required this.parentBuildContext, required this.builder, super.key});
//
//   @override
//   State<KeyboardVisibilityWidget> createState() => _KeyboardVisibilityWidgetState();
// }
//
// class _KeyboardVisibilityWidgetState extends State<KeyboardVisibilityWidget> {
//   double keyboardPadding = 0;
//
//   void scrollToEnd(BuildContext context) async {
//     final position = widget.scrollController.position.maxScrollExtent;
//     await widget.scrollController.animateTo(
//       position,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
//
//   addKeyboardPadding(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Future.delayed(const Duration(milliseconds: 200));
//       setState(() {
//         keyboardPadding = EdgeInsets.fromViewPadding(
//               View.of(context).viewInsets,
//               View.of(context).devicePixelRatio,
//             ).bottom -
//             50;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyboardVisibilityBuilder(
//       builder: (p0, isKeyboardVisible) {
//         if (isKeyboardVisible) addKeyboardPadding(context);
//
//         if (widget.scrollController.hasClients) scrollToEnd(context);
//         return widget.builder(isKeyboardVisible, keyboardPadding);
//       },
//     );
//   }
// }
