import 'package:flutter/material.dart';

class ThreeCard extends StatefulWidget {
  final Widget child;
  const ThreeCard({super.key, required this.child});

  @override
  State createState() => _ThreeCardState();
}

class _ThreeCardState extends State<ThreeCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  final _rollTween = Tween<double>(begin: 0, end: 0);
  final _pitchTween = Tween<double>(begin: 0, end: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _transform({
    required Offset localPosition,
    required double height,
    required double width,
  }) {
    final translated = localPosition.translate(-width / 2, -height / 2);

    final dxc = width * 0.3;
    final dx = translated.dx.clamp(-dxc, dxc);

    final dyc = height * 0.3;
    final dy = translated.dy.clamp(-dyc, dyc);

    final pitch = -dx / width / 2;
    _pitchTween
      ..begin = _pitchTween.end
      ..end = pitch;

    final roll = dy / height / 2;
    _rollTween
      ..begin = _rollTween.end
      ..end = roll;

    _controller
      ..reset()
      ..forward();
  }

  void _reset() {
    if (_pitchTween.end == 0 && _rollTween.end == 0) {
      return;
    }

    _pitchTween
      ..begin = _pitchTween.end
      ..end = 0;

    _rollTween
      ..begin = _rollTween.end
      ..end = 0;

    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.longestSide / 1.5,
                child: AspectRatio(
                  aspectRatio: 0.5,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.005)
                        ..multiply(
                          Matrix4.rotationY(
                            _pitchTween
                                .chain(CurveTween(curve: Curves.easeOut))
                                .evaluate(_controller),
                          ),
                        )
                        ..multiply(
                          Matrix4.rotationX(
                            _rollTween
                                .chain(CurveTween(curve: Curves.easeOut))
                                .evaluate(_controller),
                          ),
                        );

                      return Transform(
                        alignment: Alignment.center,
                        transform: transform,
                        child: child,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final height = constraints.maxHeight;
                          final width = constraints.maxWidth;

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTapDown: (d) => _transform(
                                localPosition: d.localPosition,
                                height: height,
                                width: width,
                              ),
                              onPanStart: (d) => _transform(
                                localPosition: d.localPosition,
                                height: height,
                                width: width,
                              ),
                              onPanUpdate: (d) => _transform(
                                localPosition: d.localPosition,
                                height: height,
                                width: width,
                              ),
                              onPanCancel: _reset,
                              onPanEnd: (_) => _reset(),
                              onTapUp: (_) => _reset(),
                              child: widget.child
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}
