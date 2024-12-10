import 'package:flutter/material.dart';

class CollaborativeDrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> strokes;

  CollaborativeDrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      final points = stroke['points'] as List<Offset>;
      final color = stroke['color'] as Color;
      final thickness = stroke['thickness'] as double;

      final paint = Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness;

      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}