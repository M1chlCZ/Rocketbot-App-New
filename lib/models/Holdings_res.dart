import 'Holdings.dart';

class HoldingsRes {
  HoldingsRes({
      required this.hasError,
    required this.holdings,
    required this.status,});

  HoldingsRes.fromJson(dynamic json) {
    hasError = json['hasError'];
    if (json['holdings'] != null) {
      holdings = [];
      json['holdings'].forEach((v) {
        holdings?.add(Holdings.fromJson(v));
      });
    }
    status = json['status'];
  }
  bool? hasError;
  List<Holdings>? holdings;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasError'] = hasError;
    if (holdings != null) {
      map['holdings'] = holdings?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }

}