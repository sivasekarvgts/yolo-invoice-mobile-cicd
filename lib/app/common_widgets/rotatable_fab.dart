
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

class CircularExpandingFab extends StatefulWidget {
  const CircularExpandingFab({super.key});

  @override
  State<CircularExpandingFab> createState() => _CircularExpandingFabState();
}

class _CircularExpandingFabState extends State<CircularExpandingFab> with SingleTickerProviderStateMixin {
  bool _isFabExpanded = false;
  double _rotationAngle = 0;

  final GlobalKey _menuKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _icons = [
    Svgs.invoice,
    Svgs.order,
    Svgs.receipt,
    Svgs.customer,
    Svgs.purchase,
    Svgs.billTag,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double customFabSize = 55.0;
    final double fabMargin = 16.0;

    final double menuFullDiameter =
        CustomCircularFABMenu.circleRadius * 2 + CustomCircularFABMenu.iconContainerSize;

    final double stackContainerWidth = menuFullDiameter + (fabMargin * 2);
    final double stackContainerHeight = max(customFabSize, menuFullDiameter) + (fabMargin * 2);

    return SizedBox(
      width: stackContainerWidth,
      height: stackContainerHeight,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (_isFabExpanded) {
            final RenderBox? menuRenderBox = _menuKey.currentContext?.findRenderObject() as RenderBox?;
            if (menuRenderBox == null) return;

            final Offset menuCenterGlobal = menuRenderBox.localToGlobal(
                Offset(menuRenderBox.size.width / 2, menuRenderBox.size.height / 2));

            final double dragXRelativeToMenuCenter = details.globalPosition.dx - menuCenterGlobal.dx;
            final double rotationDirectionMultiplier = dragXRelativeToMenuCenter >= 0 ? 1.0 : -1.0;

            setState(() {
              _rotationAngle += details.delta.dy * rotationDirectionMultiplier * 0.01;
            });
          }
        },
        onPanStart: (details) {},
        onPanEnd: (details) {},
        child: Stack(
          children: [
            if (_isFabExpanded || _animationController.isAnimating)
              Positioned(
                left: (stackContainerWidth - menuFullDiameter) / 2,
                bottom: fabMargin + (customFabSize / 2) - (menuFullDiameter / 2),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    alignment: Alignment.center, // <-- CHANGE THIS TO Alignment.center
                    child: CustomCircularFABMenu(
                      key: _menuKey,
                      icons: _icons,
                      rotationAngle: _rotationAngle,
                      onIconTap: (index) {
                        _animationController.reverse().then((_) {
                          setState(() {
                            _isFabExpanded = false;
                            _rotationAngle = 0.0;
                          });
                        });
                      },
                    ),
                  ),
                ),
              ),
            Positioned(
              left: (stackContainerWidth - customFabSize) / 2,
              bottom: fabMargin,
              child: SizedBox(
                width: customFabSize,
                height: customFabSize,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isFabExpanded = !_isFabExpanded;
                      if (_isFabExpanded) {
                        _rotationAngle = -pi / 6;
                        _animationController.forward();
                      } else {
                        _animationController.reverse().then((_) {
                          setState(() {
                            _rotationAngle = 0.0;
                          });
                        });
                      }
                    });
                  },
                  backgroundColor: AppColors.primary,
                  elevation: 5,
                  shape: CircleBorder(),
                  foregroundColor: Colors.white,
                  child: Icon(_isFabExpanded ? Icons.close : Icons.add, size: customFabSize * 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getIconName(String svgPath) {
    if (svgPath == Svgs.invoice) return 'Invoice';
    if (svgPath == Svgs.order) return 'Order';
    if (svgPath == Svgs.receipt) return 'Receipt';
    if (svgPath == Svgs.customer) return 'Customer';
    if (svgPath == Svgs.purchase) return 'Purchase';
    if (svgPath == Svgs.billTag) return 'Bill Tag';
    return 'Unknown Icon';
  }
}

// ... (CustomCircularFABMenu and _HalfCircleClipper code from previous solution) ...
class CustomCircularFABMenu extends StatelessWidget {
  final List<String> icons;
  final double rotationAngle;
  final Function(int) onIconTap;

  static const double circleRadius = 80.0;
  static const double iconSize = 28.0;
  static const double iconPadding = 12.0;
  static const double iconContainerSize = iconSize + (iconPadding * 2);

  const CustomCircularFABMenu({
    super.key,
    required this.icons,
    required this.rotationAngle,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final double containerDiameter = (circleRadius * 2) + iconContainerSize;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: Container(
        width: containerDiameter,
        height: containerDiameter,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipRect(

          clipper: _HalfCircleClipper(),
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(icons.length, (index) {
              final double angle = (2 * pi / icons.length) * index + rotationAngle;
              final double x = circleRadius * cos(angle);
              final double y = circleRadius * sin(angle);

              return Positioned(
                left: (containerDiameter / 2 + x) - (iconContainerSize / 2),
                top: (containerDiameter / 2 + y) - (iconContainerSize / 2),
                child: GestureDetector(
                  onTap: () => onIconTap(index),
                  child: Material(
                    shape: const CircleBorder(),

                    elevation: 5,
                    // shadowColor: Colors.black.withOpacity(0.4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.darkBlackColor,
                          borderRadius: BorderRadius.circular(iconContainerSize / 2),
                          border: Border.all(color: AppColors.boarderWhite)),
                      width: iconContainerSize,
                      height: iconContainerSize,
                      child: Center(
                        child: SvgPicture.asset(
                          icons[index],
                          color: Colors.white,
                          height: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _HalfCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height / 2.0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}


