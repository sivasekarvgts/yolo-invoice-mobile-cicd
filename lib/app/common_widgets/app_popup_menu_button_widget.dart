import 'package:flutter/material.dart';

class AppPopupMenuButtonWidget extends StatelessWidget {
  const AppPopupMenuButtonWidget(
      {super.key,
      this.tooltip,
      this.child,
      this.icon,
      this.offset = Offset.zero,
      required this.menuItems,
      this.onSelected});

  final Widget? child;
  final Widget? icon;
  final String? tooltip;
  final Offset offset;
  final void Function(dynamic)? onSelected;
  final List<PopupMenuEntry> menuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton(
        icon: icon,
        tooltip: tooltip,
        onSelected: onSelected,
        itemBuilder: (_) => menuItems,
        offset: offset,
        child: child,
        iconSize: 20,
      ),
    );
  }
}
