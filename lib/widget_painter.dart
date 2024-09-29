import 'dart:math';

import 'package:flutter/material.dart';

class WidgetPainter extends StatefulWidget {
  final int count;
  final Size size;
  final Listenable animation;

  const WidgetPainter({super.key, required this.count, required this.size, required this.animation});

  @override
  State<WidgetPainter> createState() => _WidgetPainterState();
}

class _WidgetPainterState extends State<WidgetPainter> {
  static final Random _random = Random();

  final double _sideLength = sqrt(50);

  @override
  void initState() {
    super.initState();
    squares = List.generate(
      widget.count,
      (index) {
        final x = _random.nextDouble() * widget.size.width;
        final y = _random.nextDouble() * widget.size.height;
        return Offset(x, y);
      },
    );
    widget.animation.addListener(_tick);
  }

  @override
  void didUpdateWidget(covariant WidgetPainter oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.animation.removeListener(_tick);
    squares = List.generate(
      widget.count,
      (index) {
        final x = _random.nextDouble() * widget.size.width;
        final y = _random.nextDouble() * widget.size.height;
        return Offset(x, y);
      },
    );
    widget.animation.addListener(_tick);
  }

  void _tick() {
    setState(() {
      for (var i = 0; i < squares.length; i++) {
        squares[i] = updateSquarePosition(i, squares[i], widget.size.height);
      }
    });
  }

  @override
  void dispose() {
    widget.animation.removeListener(_tick);
    super.dispose();
  }

  late List<Offset> squares;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        SizedBox.fromSize(size: widget.size),
        for (final square in squares)
          Positioned(
            left: square.dx,
            top: square.dy,
            child: Transform.rotate(
              angle: pi / 4,
              child: ColoredBox(
                color: color,
                child: SizedBox(width: _sideLength, height: _sideLength),
              ),
            ),
          ),
      ],
    );
  }
}

Offset updateSquarePosition(int index, Offset position, double maxHeight) {
  final square = position;
  if (square.dy > maxHeight) {
    return Offset(position.dx, 0);
  }

  double speed = 0.3 + Random().nextDouble();
  return Offset(position.dx, position.dy + speed);
}
