import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = min(size.width, size.height) / 2;

    // Draw animated concentric circles
    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (0.5 + i * 0.3 + animation.value * 0.2);
      canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
