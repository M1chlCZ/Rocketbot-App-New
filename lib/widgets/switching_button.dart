import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class SwitchingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SwitchingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  MyButtonState createState() => MyButtonState();
}

class MyButtonState extends State<SwitchingButton> {
  List<String> strings = ["Buy", "Sell", "Swap"];
  List<Color> colors = [const Color(0xFF9BD41E), const Color(0xFFF35656), const Color(0xFF9D9BFE)];
  int currentString = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        if (currentString == strings.length - 1) {
          currentString = 0;
        } else {
          currentString++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 150,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: (colors[currentString]).withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FlatCustomButton(
          color: Colors.transparent,
          onTap: () {
            widget.onPressed();
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.bounceInOut,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                key: ValueKey<String>(strings[currentString]),
                position: Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<String>(strings[currentString]),
              child: Text(
                strings[currentString].toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
