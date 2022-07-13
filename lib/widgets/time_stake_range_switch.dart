import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';

class StakeTimeRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  const StakeTimeRangeSwitcher({Key? key, required this.changeTime}) : super(key: key);

  @override
  StakeTimeRangeSwitcherState createState() => StakeTimeRangeSwitcherState();
}

class StakeTimeRangeSwitcherState extends State<StakeTimeRangeSwitcher> {
  var _active = 1;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.22;
    return Container(
        child: Row(
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
                    widget.changeTime(3);
                  },
                  child: AutoSizeText('1Y',
                      minFontSize: 6,
                      maxLines: 1,
                      style:  Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 4 ? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0)
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
                    widget.changeTime(2);
                  },
                  child: AutoSizeText(
                      '1M',
                      minFontSize: 6,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 3 ? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0)
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
                    widget.changeTime(1);
                  },
                  child: AutoSizeText('1W',
                      minFontSize: 6,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 2 ? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0))
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
                    widget.changeTime(0);
                  },
                  child: AutoSizeText(
                    '1D',
                    minFontSize: 6,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: _active == 1 ? const Color(0xFF9BD41E) : Colors.white, fontSize: 16.0),
                  )),
            ),
          )
        ]));
  }
}
