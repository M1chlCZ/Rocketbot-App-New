import 'package:flutter/widgets.dart';

extension BuildContextUtils on BuildContext {
  void afterBuild(VoidCallback callback) {
    Future.delayed(Duration.zero, callback);
  }
}