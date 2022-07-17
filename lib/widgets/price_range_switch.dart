import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PriceRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  final Color? color;
  const PriceRangeSwitcher({Key? key, required this.changeTime, this.color}) : super(key: key);

  @override
  PriceRangeSwitcherState createState() => PriceRangeSwitcherState();
}

class PriceRangeSwitcherState extends State<PriceRangeSwitcher> {
  var _active = 2;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.22;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            child: AnimatedOpacity(
              opacity: _active == 4 ? 1.0 : 0.4,
              duration: _duration,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _active = 4;
                    });
                    widget.changeTime(0);
                  },
                  child: AutoSizeText(AppLocalizations.of(context)!.all,
                      minFontSize: 6,
                      maxLines: 1,
                      style:  Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 4 ? widget.color ?? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0)
                  )),),
          ),
          SizedBox(
            width: width,
            child: AnimatedOpacity(
              opacity: _active == 3 ? 1.0 : 0.4,
              duration: _duration,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _active = 3;
                    });
                    widget.changeTime(24 * 7);
                  },
                  child: AutoSizeText(
                      AppLocalizations.of(context)!.onew,
                      minFontSize: 6,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 3 ? widget.color ?? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0)
                  )),),
          ),
          SizedBox(
            width: width,
            child: AnimatedOpacity(
              opacity: _active == 2 ? 1.0 : 0.4,
              duration: _duration,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _active = 2;
                    });
                    widget.changeTime(24);
                  },
                  child: AutoSizeText(AppLocalizations.of(context)!.oned,
                      minFontSize: 6,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 2 ? widget.color ?? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0))
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: AnimatedOpacity(
              opacity: _active == 1 ? 1.0 : 0.4,
              duration: _duration,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _active = 1;
                    });
                    widget.changeTime(12);
                  },
                  child: AutoSizeText(
                    AppLocalizations.of(context)!.twelveh,
                    minFontSize: 6,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 1 ? widget.color ?? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0),
                  )),
            ),
          )
        ]);
  }
}
