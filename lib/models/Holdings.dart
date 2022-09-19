class Holdings {
  Holdings({
      required this.idCoin,
    required this.amount,});

  Holdings.fromJson(dynamic json) {
    idCoin = json['idCoin'];
    amount = double.parse(json['amount'].toString());
  }
  int? idCoin;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCoin'] = idCoin;
    map['amount'] = amount;
    return map;
  }

}