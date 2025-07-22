import 'package:flutter/material.dart';

import '../styles/colors.dart';

class AppRecepitDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = AppColors.dividerGreyColor.withOpacity(1.0)
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);

    bool isZigzagUp = true;
    double zigzagDepth = 3;
    double segmentLength = 6;

    for (double i = 0; i <= size.width; i += segmentLength) {
      if (isZigzagUp) {
        path.lineTo(i, -zigzagDepth);
      } else {
        path.lineTo(i, 0);
      }
      isZigzagUp = !isZigzagUp;
    }

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    isZigzagUp = false;
    for (double i = size.width; i >= 0; i -= segmentLength) {
      if (isZigzagUp) {
        path.lineTo(i, size.height + zigzagDepth);
      } else {
        path.lineTo(i, size.height);
      }
      isZigzagUp = !isZigzagUp;
    }

    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
