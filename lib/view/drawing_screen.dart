import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:test_001/core/collaborative_drawing_paintert.dart';
import '../contoller/drawing_controller.dart';
import '../core/drawing_canvas.dart';

class CollaborativeDrawingScreen extends StatelessWidget {
  final DrawingController controller = Get.put(DrawingController());

  CollaborativeDrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawing Task"),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: controller.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: controller.redo,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => _selectColor(context),
          ),
          IconButton(
            icon: const Icon(Icons.brush),
            onPressed: () => _selectThickness(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.strokes.isEmpty) {
              return const Center(
                child: Text(
                  "No drawing yet, start drawing now!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              return InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.5,
                maxScale: 4.0,
                child: CustomPaint(
                  painter:
                      CollaborativeDrawingPainter(controller.strokes.value),
                  size: Size.infinite,
                ),
              );
            }
          }),
          DrawingCanvas(onStrokeEnd: controller.saveStroke),
          // _buildZoomControls(context), // Add the zoom controls here
        ],
      ),
    );
  }

  Widget _buildZoomControls(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Zoom Horizontal",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: controller.horizontalZoom.value,
            min: 0.5,
            max: 4.0,
            divisions: 30,
            label: controller.horizontalZoom.value.toStringAsFixed(1),
            onChanged: (value) {
              controller.horizontalZoom.value = value;
              // Update the zoom scale here
            },
          ),
          const Text(
            "Zoom Vertical",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: controller.verticalZoom.value,
            min: 0.5,
            max: 4.0,
            divisions: 30,
            label: controller.verticalZoom.value.toStringAsFixed(1),
            onChanged: (value) {
              controller.verticalZoom.value = value;
              // Update the zoom scale here
            },
          ),
        ],
      ),
    );
  }

  void _selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: controller.penColor.value,
            onColorChanged: (color) {
              controller.penColor.value = color;
              Get.back();
            },
          ),
        ),
      ),
    );
  }

  void _selectThickness(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Select Brush Thickness",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.blue[100],
                    thumbColor: Colors.blue,
                    overlayColor: Colors.blue.withOpacity(0.2),
                    valueIndicatorColor: Colors.blueAccent,
                    trackHeight: 4.0,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                    valueIndicatorShape:
                        const PaddleSliderValueIndicatorShape(),
                  ),
                  child: Slider(
                    value: controller.penThickness.value,
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    label: controller.penThickness.value.toStringAsFixed(1),
                    onChanged: (value) {
                      controller.penThickness.value = value;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Thickness: ${controller.penThickness.value.toStringAsFixed(1)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}