import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';

class HorizontalListView extends StatelessWidget {
  final Coin coin;
  final Function(Coin) callBack;
  final bool active;
  const HorizontalListView({Key? key, required this.coin, required this.callBack, required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack(coin);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10.0),
        color: Colors.transparent,
        child: Text( coin.cryptoId!,
            style: TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 14.0, color: active ? Colors.white : Colors.white54),),
      ),
    );
  }
}
