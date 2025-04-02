import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Axis axis;

  DashedLinePainter(this.axis);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    const double dashWidth = 2, dashSpace = 6;
    double start = 0;

    if (axis == Axis.vertical) {
      canvas.drawCircle(Offset(size.width / 2, 0), 3, dotPaint);
    } else {
      canvas.drawCircle(Offset(0, size.height / 2), 3, dotPaint);
    }

    while (start < (axis == Axis.vertical ? size.height : size.width)) {
      if (axis == Axis.vertical) {
        canvas.drawLine(
          Offset(size.width / 2, start),
          Offset(size.width / 2, start + dashWidth),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(start, size.height / 2),
          Offset(start + dashWidth, size.height / 2),
          paint,
        );
      }
      start += dashWidth + dashSpace;
    }

    if (axis == Axis.vertical) {
      canvas.drawCircle(Offset(size.width / 2, size.height), 3, dotPaint);
    } else {
      canvas.drawCircle(Offset(size.width, size.height / 2), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedLineWidget extends StatelessWidget {
  final double length;
  final Axis axis;

  const DashedLineWidget({super.key, required this.length, this.axis = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: axis == Axis.vertical ? Size(2, length) : Size(length, 2),
      painter: DashedLinePainter(axis),
    );
  }
}
