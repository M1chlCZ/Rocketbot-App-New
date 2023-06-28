import 'coin.dart';
import 'ordinals.dart';

class DepositsModel {
  String? message;
  bool? hasError;
  String? error;
  List<DataDeposits>? data;

  DepositsModel({this.message, this.hasError, this.error, this.data});

  DepositsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    hasError = json['hasError'];
    error = json['error'];
    if (json['data'] != null) {
      data = <DataDeposits>[];
      json['data'].forEach((v) {
        data!.add(DataDeposits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['hasError'] = hasError;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataDeposits {
  int? userId;
  Coin? coin;
  Ordinal? ordinal;
  double? amount;
  String? transactionId;
  bool? isConfirmed;
  int? confirmations;
  String? receivedAt;
  String? confirmedAt;

  DataDeposits(
      {this.userId,
        this.coin,
        this.ordinal,
        this.amount,
        this.transactionId,
        this.isConfirmed,
        this.confirmations,
        this.receivedAt,
        this.confirmedAt});

  DataDeposits.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    ordinal =
    json['ordinal'] != null ? Ordinal.fromJson(json['ordinal']) : null;
    amount = double.parse(json['amount'].toString());
    transactionId = json['transactionId'];
    isConfirmed = json['isConfirmed'];
    confirmations = json['confirmations'];
    receivedAt = json['receivedAt'];
    confirmedAt = json['confirmedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (coin != null) {
      data['coin'] = coin!.toJson();
    }
    if (ordinal != null) {
      data['ordinal'] = ordinal!.toJson();
    }
    data['amount'] = amount;
    data['transactionId'] = transactionId;
    data['isConfirmed'] = isConfirmed;
    data['confirmations'] = confirmations;
    data['receivedAt'] = receivedAt;
    data['confirmedAt'] = confirmedAt;
    return data;
  }
}
