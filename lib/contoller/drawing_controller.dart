import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingController extends GetxController {
  final strokes = <Map<String, dynamic>>[].obs;
  final penColor = Colors.black.obs;
  final penThickness = 4.0.obs;

  final List<List<Map<String, dynamic>>> undoHistory =
      <List<Map<String, dynamic>>>[].obs;
  final List<List<Map<String, dynamic>>> redoHistory =
      <List<Map<String, dynamic>>>[].obs;

  final DatabaseReference ref =
      FirebaseDatabase.instance.ref('drawings/session_1');

  // Zoom control variables
  final horizontalZoom = 1.0.obs; // Horizontal zoom level
  final verticalZoom = 1.0.obs; // Vertical zoom level

  @override
  void onInit() {
    super.onInit();
    _listenToFirebaseUpdates();
  }

  void _listenToFirebaseUpdates() {
    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final newStrokes = data.values.map((stroke) {
          final points = (stroke['points'] as List<dynamic>? ?? [])
              .map((point) => Offset((point['x'] as num).toDouble(),
                  (point['y'] as num).toDouble()))
              .toList();
          final color = Color(int.parse(stroke['color'], radix: 16));
          final thickness = (stroke['thickness'] as num).toDouble();
          return {
            'points': points,
            'color': color,
            'thickness': thickness,
          };
        }).toList();

        strokes.assignAll(newStrokes);
      }
    });
  }

  void saveStroke(List<Offset> points) {
    strokes.add({
      'points': points,
      'color': penColor.value,
      'thickness': penThickness.value,
    });

    List<Map<String, double>> pointsData =
        points.map((point) => {"x": point.dx, "y": point.dy}).toList();

    ref.push().set({
      "points": pointsData,
      "color": penColor.value.value.toRadixString(16),
      "thickness": penThickness.value,
    });

    undoHistory.add(List.from(strokes));
    redoHistory.clear();
  }

  void undo() {
    if (undoHistory.isNotEmpty) {
      redoHistory
          .add(List.from(strokes)); // Save current strokes to redo history
      strokes.assignAll(undoHistory.removeLast()); // Get the previous state
    }
  }

  void redo() {
    if (redoHistory.isNotEmpty) {
      undoHistory
          .add(List.from(strokes)); // Save current strokes to undo history
      strokes.assignAll(redoHistory.removeLast()); // Get the next state
    }
  }

  // Set zoom levels for horizontal and vertical zoom
  void setZoom(double horizontal, double vertical) {
    horizontalZoom.value = horizontal;
    verticalZoom.value = vertical;
  }
}