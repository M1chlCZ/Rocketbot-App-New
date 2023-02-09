import 'package:flutter/material.dart';
import "dart:math" as math;
class SpinningCircleWidget extends StatefulWidget {
  final int selectedSlice;
  final List<Color> sliceColors;
  final Duration duration;

  const SpinningCircleWidget({super.key,
    required this.selectedSlice,
    required this.sliceColors,
    required this.duration,
  });

  @override
  SpinningCircleWidgetState createState() => SpinningCircleWidgetState();
}

class SpinningCircleWidgetState extends State<SpinningCircleWidget> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller!)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller?.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller?.forward();
        }
      });

    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _CirclePainter(
          animation: _animation!,
          selectedSlice: widget.selectedSlice,
          sliceColors: widget.sliceColors,
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Animation<double> animation;
  final int selectedSlice;
  final List<Color> sliceColors;

  _CirclePainter({
    required this.animation,
    required this.selectedSlice,
    required this.sliceColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final radius = math.min(size.width, size.height) / 2;

    final sweepAngle = 2 * math.pi / sliceColors.length;
    var startAngle = -math.pi / 2;
    final animationValue = (animation.value * sliceColors.length).floor();

    for (var i = 0; i < sliceColors.length; i++) {
      final color = sliceColors[i];
      final endAngle = startAngle + sweepAngle;
      final isSelected = (i + animationValue) % sliceColors.length == selectedSlice;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.round;

      if (isSelected) {
        final selectedPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 40;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          selectedPaint,
        );
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }

      startAngle = endAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}