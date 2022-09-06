import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/widgets/button_flat.dart';

class StakingMasternodeSwitcher extends StatefulWidget {
  final Function(int page)? changeType;
  final bool masternode;

  const StakingMasternodeSwitcher({Key? key, this.changeType, required this.masternode}) : super(key: key);

  @override
  StakingMasternodeSwitcherState createState() => StakingMasternodeSwitcherState();
}

class StakingMasternodeSwitcherState extends State<StakingMasternodeSwitcher> {
  var _active = 0;
  final _duration = const Duration(milliseconds: 300);

  currentPage(int p) {
    setState(() {
    _active = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color(0xFF394359),
          borderRadius: BorderRadius.circular(10.0)
        ),
          child: Row(children: [
            Expanded(
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: _active == 0 ? const Color(0xFF9BD41E) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0)),
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
                      width: 120,
                      child: AutoSizeText("Staking",
                          maxLines: 1,
                          minFontSize: 8.0,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold)),
                    )),
              ),
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: IgnorePointer(
                ignoring: widget.masternode ? false : true,
                child: Opacity(
                  opacity: widget.masternode == false ? 0.6 : 1.0,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                        color: _active == 0 ? Colors.transparent: const Color(0xFFF68DB2),
                        borderRadius: BorderRadius.circular(8.0)),
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
                          child: AutoSizeText("Masternode",
                              maxLines: 1,
                              minFontSize: 8.0,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        )),
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
