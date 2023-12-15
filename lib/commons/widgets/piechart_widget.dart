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

      final segmentAngle = (startAngle - arcAngle / 2);
      final textX = size.width / 3.2;
      final textY = size.height / 3.2;
      final textRadius = (min(textX, textY));
      final segmentX = centerX + textRadius * cos(segmentAngle);
      final segmentY = centerY + textRadius * sin(segmentAngle);

      final textVal = (segment.value / total * 100).toStringAsFixed(2);
      final textDouble = double.parse(textVal);
      const textStyle = TextStyle(color: Colors.white, fontSize: 14);
      final textSpan = TextSpan(text: '$textVal%', style: textStyle);
      if (textDouble > 5) {
        final textPainter =
            TextPainter(text: textSpan, textDirection: TextDirection.ltr);
        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(segmentX - textPainter.width / 2,
              segmentY - textPainter.height / 2),
        );
      }
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
