import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  final double radius;
  final Color? color;
  final VoidCallback? onTap;
  final Icon? icon;
  final AnimatedIcon? animIcon;
  final Color? splashColor;
  final Image? imageIcon;
  final Widget? child;
  final double? height;
  final double? width;
  final Gradient? gradient;

  const NeuButton(
      {super.key,
      this.color,
      this.onTap,
      this.icon,
      this.imageIcon,
      this.splashColor,
      this.animIcon,
      this.radius = 4.0,
      this.child,
      this.height,
      this.width,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return _getContainer(
      height,
      width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(-1, -1),
            blurRadius: 4.0,
            color: Color.fromRGBO(134, 134, 134, 0.05),
          ),
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 4.0,
            color: Color.fromRGBO(2, 2, 2, 0.25),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Material(
          color: color ?? Theme.of(context).canvasColor, // button color
          child: InkWell(
            // highlightColor: splashColor!.withOpacity(0.5),
            splashColor: splashColor ?? Colors.white30, // splash color
            onTap: onTap, // button pressed
            child: gradient != null
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient!.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        animIcon ?? Container(),
                        icon ?? Container(),
                        imageIcon ?? Container(),
                        child ?? Container(), // icon
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      animIcon ?? Container(),
                      icon ?? Container(),
                      imageIcon ?? Container(),
                      child ?? Container(), // icon
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Container _getContainer(double? height, double? width, {required BoxDecoration decoration, required Widget child}) {
    if (height != null) {
      assert(width != null);
      return Container(
        height: height,
        width: width,
        decoration: decoration,
        child: child,
      );
    } else {
      return Container(
        decoration: decoration,
        child: child,
      );
    }
  }
}
