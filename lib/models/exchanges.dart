class Exchange {
  int? id;
  int? idCoin;
  String? target;
  String? url;
  String? name;

  Exchange({this.id, this.idCoin, this.target, this.url, this.name});

  Exchange.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCoin = json['idCoin'];
    target = json['target'];
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idCoin'] = idCoin;
    data['target'] = target;
    data['url'] = url;
    data['name'] = name;
    return data;
  }
}