import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class GameSwitcher extends StatefulWidget {
  final Function(int page)? changeType;


  const GameSwitcher({Key? key, this.changeType}) : super(key: key);

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
      width: 300,
      child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              color: const Color(0xFF394359),
              borderRadius: BorderRadius.circular(8.0)
          ),
          child: Row(children: [
            Expanded(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: _active == 0 ?   const Color(0xFF9D9BFD) : const Color(0x009D9BFD),
                    borderRadius: BorderRadius.circular(5.0)),
                duration: _duration,
                child: FlatCustomButton(
                    color: Colors.transparent,
                    radius: 8.0,
                    onTap: () {
                      setState(() {
                        _active = 0;
                      });
                      widget.changeType!(0);
                    },
                    child: SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText("Giveaway",
                            maxLines: 1,
                            minFontSize: 8.0,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    )),
              ),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: _active == 1 ? const Color(0xFF9D9BFD) : const Color(0x009D9BFD),
                    borderRadius: BorderRadius.circular(5.0)),
                // opacity: _active == 1 ? 1.0 : 0.4,
                duration: _duration,
                child: FlatCustomButton(
                    color: Colors.transparent,
                    onTap: () {
                      setState(() {
                        _active = 1;
                      });
                      widget.changeType!(1);
                    },
                    child: SizedBox(
                      width: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText("Airdrop",
                            maxLines: 1,
                            minFontSize: 8.0,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    )),
              ),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: _active == 2 ? const Color(0xFF9D9BFD) : const Color(0x009D9BFD),
                    borderRadius: BorderRadius.circular(5.0)),
                // opacity: _active == 1 ? 1.0 : 0.4,
                duration: _duration,
                child: FlatCustomButton(
                    color: Colors.transparent,
                    onTap: () {
                      setState(() {
                        _active = 2;
                      });
                      widget.changeType!(2);
                    },
                    child: SizedBox(
                      width: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: AutoSizeText("Spin",
                            maxLines: 1,
                            minFontSize: 8.0,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                    )),
              ),
            ),
          ])),
    );
  }
}
