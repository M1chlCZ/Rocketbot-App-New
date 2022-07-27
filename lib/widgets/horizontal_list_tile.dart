import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';

class HorizontalListView extends StatelessWidget {
  final Coin coin;
  final Function(Coin) callBack;
  final bool active;
  final int index;
  final int currentIndex;
  const HorizontalListView({Key? key, required this.coin, required this.callBack, required this.active, required this.index, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: GestureDetector(
        onTap: () {
          callBack(coin);
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10.0),
          color: Colors.transparent,
          child: AutoSizeText( coin.ticker!,
              maxLines: 1,
              minFontSize: 8.0,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: index == currentIndex ? Colors.white : Colors.white54),),
        ),
      ),
    );
  }
}
