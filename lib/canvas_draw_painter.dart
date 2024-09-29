import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_draw_vertices/widget_painter.dart';

class CanvasDrawPainter extends CustomPainter {
  static final Random _random = Random();

  final Size size;

  CanvasDrawPainter({required int count, required this.size, required Listenable animation})
      : super(repaint: animation) {
    squares = List.generate(
      count,
      (index) {
        final x = _random.nextDouble() * size.width;
        final y = _random.nextDouble() * size.height;
        return Offset(x, y);
      },
    );
  }

  final Paint _paint = Paint()..color = Colors.greenAccent;

  late final List<Offset> squares;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < squares.length; i++) {
      squares[i] = updateSquarePosition(i, squares[i], size.height);
    }

    const radius = 5.0;
    for (var position in squares) {
      final path = Path()
        ..moveTo(position.dx, position.dy)
        ..relativeMoveTo(radius, 0)
        ..relativeLineTo(-radius, -radius)
        ..relativeLineTo(-radius, radius)
        ..relativeLineTo(radius, radius)
        ..relativeLineTo(radius, -radius)
        ..close();

      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
