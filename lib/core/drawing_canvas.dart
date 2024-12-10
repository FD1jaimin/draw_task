
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../contoller/drawing_controller.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatefulWidget {
  final Function(List<Offset> points) onStrokeEnd;

  const DrawingCanvas({required this.onStrokeEnd, Key? key}) : super(key: key);

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          _points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
        widget.onStrokeEnd(_points);
        setState(() {
          _points = [];
        });
      },
      child: CustomPaint(
        painter: DrawingPainter(
            _points,
            Get.find<DrawingController>().penColor.value,
            Get.find<DrawingController>().penThickness.value),
        size: Size.infinite,
      ),
    );
  }
}
