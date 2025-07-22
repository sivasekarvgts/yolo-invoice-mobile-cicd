import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final Widget child;
  bool isHeading = false;

  ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height,
    this.child = const SizedBox(),
  }) : this.shapeBorder =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));

  ShimmerWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.child = const SizedBox(),
      this.shapeBorder = const CircleBorder()});

  ShimmerWidget.text({
    this.width = double.infinity,
    this.height = 10.0,
    this.child = const SizedBox(),
  }) : this.shapeBorder =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  ShimmerWidget.heading(
      {this.width = 0,
      this.height = 0,
      this.shapeBorder = const CircleBorder(),
      required this.child,
      this.isHeading = true});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.grey[300]!,
        period: const Duration(seconds: 3),
        child: isHeading
            ? child
            : Container(
                width: width,
                height: height,
                decoration: ShapeDecoration(
                  color: Colors.grey[400]!,
                  shape: shapeBorder,
                ),
              ),
      );
}
