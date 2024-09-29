import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_draw_vertices/canvas_draw_painter.dart';
import 'package:flutter_draw_vertices/vertices_draw_painter.dart';
import 'package:flutter_draw_vertices/widget_painter.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ValueNotifier<double> _slide;
  late final Animatable<double> _countBySlide;

  int _count = 0;
  ShowMode _currentMode = ShowMode.widget;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(hours: 1));
    _slide = ValueNotifier(0.3)
      ..addListener(
        () {
          super.setState(() => _count = _calculateCount(_slide.value));
        },
      );
    _countBySlide = Tween<double>(
      begin: 1,
      end: pow(2, 15).toDouble(),
    ).chain(CurveTween(curve: Curves.easeInCirc));

    _count = _calculateCount(_slide.value);

    _animationController.forward();
  }

  int _calculateCount(double value) => _countBySlide.transform(_slide.value).toInt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  final size = MediaQuery.of(context).size;

                  return switch (_currentMode) {
                    ShowMode.widget => WidgetPainter(count: _count, size: size, animation: _animationController),
                    _ => CustomPaint(
                        painter: switch (_currentMode) {
                          ShowMode.canvas =>
                            CanvasDrawPainter(count: _count, size: size, animation: _animationController),
                          ShowMode.drawVertices =>
                            VerticesDrawPainter(count: _count, size: size, animation: _animationController),
                          ShowMode.drawVerticesRaw => throw UnimplementedError(),
                          _ => throw ArgumentError(),
                        },
                        size: size,
                      )
                  };
                },
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ModeSwitcher(onChanged: (value) {
                  super.setState(() => _currentMode = value);
                }),
                SizedBox(
                  width: 250,
                  child: ValueListenableBuilder(
                    valueListenable: _slide,
                    builder: (context, value, child) {
                      return Slider(
                        value: value,
                        onChanged: (value) => _slide.value = value,
                      );
                    },
                  ),
                ),
                Text(
                  '(n = $_count)',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

enum ShowMode { widget, canvas, drawVertices, drawVerticesRaw }

class ModeSwitcher extends StatefulWidget {
  const ModeSwitcher({super.key, required this.onChanged});

  final void Function(ShowMode value) onChanged;

  @override
  State<ModeSwitcher> createState() => _ModeSwitcherState();
}

class _ModeSwitcherState extends State<ModeSwitcher> {
  List<bool> selection = _generateSelection(0);

  List<ShowMode> modes = [...ShowMode.values];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.white.withOpacity(0.7),
      borderColor: Colors.white,
      selectedBorderColor: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      isSelected: selection,
      children: modes
          .map(
            (m) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(m.name),
            ),
          )
          .toList(),
      onPressed: (index) {
        setState(() {
          selection = _generateSelection(index);
        });
        widget.onChanged(modes[index]);
      },
    );
  }

  static List<bool> _generateSelection(int index) {
    return [
      for (var i = 0; i < ShowMode.values.length; i++) i == index,
    ];
  }
}
