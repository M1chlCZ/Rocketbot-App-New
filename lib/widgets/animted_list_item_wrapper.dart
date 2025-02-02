import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimatedListItemWrapper extends StatefulWidget {
  const AnimatedListItemWrapper({
    super.key,
    required this.child,
    this.keepAlive = false,
    this.scrollDirection = ScrollDirection.forward,
  });

  final Widget child;
  final bool keepAlive;
  final ScrollDirection scrollDirection;

  @override
  State<AnimatedListItemWrapper> createState() => _AnimatedListItemWrapperState();
}

class _AnimatedListItemWrapperState extends State<AnimatedListItemWrapper>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> perspectiveAnimation;
  late final Animation<AlignmentGeometry> alignmentAnimation;

  static const double perspectiveValue = 0.005;

  @override
  void initState() {
    super.initState();
    final int perspectiveDirectionMultiplier =
    widget.scrollDirection == ScrollDirection.forward ? -1 : 1;

    final AlignmentGeometry directionAlignment =
    widget.scrollDirection == ScrollDirection.forward
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    perspectiveAnimation = Tween<double>(
      begin: perspectiveValue * perspectiveDirectionMultiplier,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 1, curve: Curves.easeOut),
      ),
    );

    alignmentAnimation = Tween<AlignmentGeometry>(
      begin: directionAlignment,
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: animationController,
        child: widget.child,
        builder: (context, child) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 1, perspectiveAnimation.value),
          alignment: alignmentAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}