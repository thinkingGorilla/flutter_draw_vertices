import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_draw_vertices/widget_painter.dart';

class VerticesRawDrawPainter extends CustomPainter {
  static final Random _random = Random();

  final Size size;

  VerticesRawDrawPainter({required int count, required this.size, required Listenable animation})
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

  final Paint _paint = Paint()..color = Colors.redAccent;

  late final List<Offset> squares;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < squares.length; i++) {
      squares[i] = updateSquarePosition(i, squares[i], size.height);
    }

    const radius = 5.0;
    for (var position in squares) {
      final x = position.dx;
      final y = position.dy;

      final vertices = Vertices.raw(
        VertexMode.triangles,
        Float32List.fromList([
          //@formatter:off
          x - radius, y,
          x, y - radius,
          x + radius, y,
          x, y + radius,
          //@formatter:on
        ]),
        indices: Uint16List.fromList([
          //@formatter:off
          1, 2, 3,
          1, 3, 0,
          //@formatter:on
        ]),
      );
      canvas.drawVertices(vertices, BlendMode.color, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
