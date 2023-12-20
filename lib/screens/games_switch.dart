import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class GameSwitcher extends StatefulWidget {
  final Function(int page)? changeType;
  final List<String>? games;

  const GameSwitcher({super.key, this.changeType, this.games = const ["Giveaway", "Airdrop", "Spin"]});

  @override
  GameSwitcherState createState() => GameSwitcherState();
}

class GameSwitcherState extends State<GameSwitcher> {
  var _active = 0;
  final _duration = const Duration(milliseconds: 500);

  currentPage(int p) {
    setState(() {
      _active = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(color: const Color(0xFF394359), borderRadius: BorderRadius.circular(8.0)),
          child: Row(children: [
            for (var i = 0; i < widget.games!.length; i++)
            widget.games![i] == '*' ?  Expanded(
                child: AnimatedContainer(
                  decoration: BoxDecoration(color: _active == i ? const Color(0xFF9D9BFD) : const Color(0x009D9BFD), borderRadius: BorderRadius.circular(5.0)),
                  duration: _duration,
                  child: FlatCustomButton(
                      color: Colors.transparent,
                      radius: 8.0,
                      onTap: () {
                        setState(() {
                          _active = i;
                        });
                        widget.changeType!(i);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Align(child: Image.asset("images/start.png", height: 30, width: 30)),
                      )),
                ),
              ) : Expanded(
              child: AnimatedContainer(
                decoration: BoxDecoration(color: _active == i ? const Color(0xFF9D9BFD) : const Color(0x009D9BFD), borderRadius: BorderRadius.circular(5.0)),
                duration: _duration,
                child: FlatCustomButton(
                    color: Colors.transparent,
                    onTap: () {
                      setState(() {
                        _active = i;
                      });
                      widget.changeType!(i);
                    },
                    child: SizedBox(
                      width: 120,
                      height: 36,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: AutoSizeText(widget.games![i],
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )),
              ),
            ),
          ])),
    );
  }
}
