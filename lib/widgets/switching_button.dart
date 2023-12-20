import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class SwitchingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SwitchingButton({super.key, required this.onPressed});

  @override
  MyButtonState createState() => MyButtonState();
}

class MyButtonState extends State<SwitchingButton> {
  List<String> strings = ["Buy", "Sell", "Swap"];
  List<Color> colors = [
    const Color(0xFF9BD41E),
    const Color(0xFFF35656),
    const Color(0xFF9D9BFE)];
  int currentString = 0;
  Timer? t;

  @override
  void setState(VoidCallback fn) {
    if (context.mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(milliseconds: 1800), (Timer t) {
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
    return Opacity(
      opacity: 0.8,
      child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1600),
              decoration: BoxDecoration(
                color: (colors[currentString]).withOpacity(1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white12, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: const Offset(2, 6), // changes position of shadow
                  ),
                ],
              ),
              child: SizedBox(
                height: 25,
                width: 120,
                child: FlatCustomButton(
                  radius: 5,
                  color: Colors.transparent,
                  onTap: () {
                    widget.onPressed();
                  },
                  ),
                ),
            ),
          IgnorePointer(
            child: SizedBox(
              height: 40,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith( fontSize: 18, fontWeight: FontWeight.w600),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(milliseconds: 300),
                    animatedTexts: [
                      RotateAnimatedText('BUY',duration: const Duration(milliseconds: 1800)),
                      RotateAnimatedText('SELL',duration: const Duration(milliseconds: 1800)),
                      RotateAnimatedText('SWAP',duration: const Duration(milliseconds: 1800)),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },

                  ),
                ),
              ],
        ),
            ),
          ),
            // AnimatedTextKit(
            //   animatedTexts: [
            //     for (var i = 0; i < strings.length; i++)
            //       RotateAnimatedText(
            //       strings[i].toUpperCase(),
            //       textStyle: const TextStyle(
            //         fontSize: 32.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       transitionHeight: 100,
            //       // speed: const Duration(milliseconds: 2000),
            //     ),
            //   ],
            //
            //   repeatForever: true,
            //   pause: const Duration(milliseconds: 1000),
            //   displayFullTextOnTap: false,
            //   stopPauseOnTap: false,
            // )
          ],
      ),
    );
  }
}
