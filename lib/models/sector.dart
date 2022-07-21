import 'package:flutter/material.dart';

class Sector{
  final double val;
  final Color col;
  final double rad;
  final String nam;

  Sector({
    required this.val,
    required this.col,
    required this.rad,
    required this.nam,
  });

  double? get value => val;
  Color? get color => col;
  double? get radius => rad;
  String? get name => nam;

}