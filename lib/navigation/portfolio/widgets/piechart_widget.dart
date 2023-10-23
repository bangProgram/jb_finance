import 'dart:math';

import 'package:flutter/material.dart';

class PiechartWidget extends StatelessWidget {
  final double size;
  final List<PieChartSegment> values;

  const PiechartWidget({
    super.key,
    required this.size,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PieChartPainter(values),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<PieChartSegment> values;

  PieChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final rectPoint =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = (min(centerX, centerY));
    final rectCircle =
        Rect.fromCircle(center: const Offset(10, 10), radius: radius);

    double total = 0.0;

    for (final segment in values) {
      total += segment.value;
    }

    double startAngle = -pi / 2;

    for (final segment in values) {
      final arcAngle = 2 * pi * (segment.value / total);
      canvas.drawArc(rectPoint, startAngle, arcAngle, true,
          Paint()..color = segment.color);
      startAngle += arcAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PieChartSegment {
  final double value;
  final Color color;

  PieChartSegment(this.value, this.color);
}
