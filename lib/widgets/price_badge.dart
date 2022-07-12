import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceBadge extends StatefulWidget {
  final Decimal? percentage;
  const PriceBadge({Key? key, required this.percentage}) : super(key: key);

  @override
  State<PriceBadge> createState() => _PriceBadgeState();
}

class _PriceBadgeState extends State<PriceBadge> {

  double _perc = 0.0;
  @override
  void initState() {
    super.initState();
    if (widget.percentage != null) {
      _perc = widget.percentage!.toDouble();
    }
  }
  
  String _getNum(double num) {
    if(num > 0) {
      return "+${num.toStringAsFixed(2)}";
    }else{
      return (num).toStringAsFixed(2);
    }
  }

  double? _getWidth(double num) {
    if(num < 0) {
      num = num * -1.0;
    }

    if(num < 10) {
      return 60.0;
    }else if(num < 100) {
      return 60.0;
    }else if(num < 1000){
      return 75.0;
    }else{
      return 85.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(_perc),
      child: Center(
        child: Opacity(
          opacity: 0.9,
          child: AutoSizeText("${_getNum(_perc)}%",
    minFontSize: 8.0,
    maxLines: 1,
    style: TextStyle (
    color: _perc > 0 ? const Color(0xFF9BD421) : const Color(0xFFF35656),
    fontWeight: FontWeight.w800,
    fontSize: 12.0,)),
        ),
      ));
  }
}
