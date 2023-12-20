import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/slider_painter.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget>
    with SingleTickerProviderStateMixin {
  final double widgetWidth = 300;
  final double widgetHeight = 100;

  Offset _dragPosition = const Offset(0, 0);

  // Animation
  AnimationController? _animationController;
  Animation? _sliderAnimation;

  double _animBeginValue = 0;
  double _animEndValue = 0;

  bool _isDragging = false;

  double _progress = 20;

  @override
  void initState() {
    super.initState();

    // Init default anim values
    _animBeginValue = widgetHeight / 2;
    _animEndValue = widgetHeight / 2;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // init animation
    _initAnimation();

    // play anim
    _animationController!.forward();
  }

  void _initAnimation() {
    _sliderAnimation = Tween<double>(
      begin: _animBeginValue,
      end: _animEndValue,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.bounceOut),
    )..addListener(() {
        setState(() {});
      });
  }

  // Cap drag values between widget height and width
  void _capDragPosition() {
    // Y-Axis
    if (_dragPosition.dy >= widgetHeight) {
      _dragPosition = Offset(_dragPosition.dx, widgetHeight);
    } else if (_dragPosition.dy <= 0) {
      _dragPosition = Offset(_dragPosition.dx, 0);
    }

    // X-Axis
    if (_dragPosition.dx >= widgetWidth - 2) {
      _dragPosition = Offset(widgetWidth, _dragPosition.dy);
    } else if (_dragPosition.dx <= 2) {
      _dragPosition = Offset(0, _dragPosition.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (value) {
        setState(() {
          _isDragging = true;

          // Dragging,
          _dragPosition =
              Offset(value.localPosition.dx, value.localPosition.dy);

          _capDragPosition();

          // set progress
          _progress = (_dragPosition.dx / widgetWidth) * 100;
        });
      },
      onPanEnd: (value) {
        setState(() {
          _isDragging = false;

          _animBeginValue = _dragPosition.dy;
          _animEndValue = widgetHeight / 2;

          _animationController!.reset();

          _initAnimation();

          _animationController!.forward();
        });
      },
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: widgetWidth,
                height: widgetHeight,
                child: CustomPaint(
                  painter: SliderPainter(
                    dragPosition: _isDragging
                        ? _dragPosition
                        : Offset(_dragPosition.dx, _sliderAnimation!.value),
                    sliderColor: Colors.black.withAlpha(30),
                  ),
                  child: const Text("Slider Widget"),
                ),
              ),
            ),
            ClipRRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _progress / 100,
                child: SizedBox(
                  width: widgetWidth,
                  height: widgetHeight,
                  child: CustomPaint(
                    painter: SliderPainter(
                      dragPosition: _isDragging
                          ? _dragPosition
                          : Offset(_dragPosition.dx, _sliderAnimation!.value),
                      sliderColor: Colors.blue,
                    ),
                    child: const Text("Slider Widget"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
