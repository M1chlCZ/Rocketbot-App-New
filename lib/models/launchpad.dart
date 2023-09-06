class LaunchpadMobile {
  bool? hasError;
  List<Stuff>? presale;
  List<Stuff>? public;
  String? status;
  List<Stuff>? whitelist;
  List<Top>? topForever;
  List<Top>? topWeek;

  LaunchpadMobile(
      {this.hasError, this.presale, this.public, this.status, this.whitelist});

  LaunchpadMobile.fromJson(Map<String, dynamic> json) {
    hasError = json['hasError'];
    if (json['presale'] != null) {
      presale = <Stuff>[];
      json['presale'].forEach((v) {
        presale!.add(Stuff.fromJson(v));
      });
    }
    if (json['public'] != null) {
      public = <Stuff>[];
      json['public'].forEach((v) {
        public!.add(Stuff.fromJson(v));
      });
    }
    status = json['status'];
    if (json['whitelist'] != null) {
      whitelist = <Stuff>[];
      json['whitelist'].forEach((v) {
        whitelist!.add(Stuff.fromJson(v));
      });
    }
    if (json['topForever'] != null) {
      topForever = <Top>[];
      json['topForever'].forEach((v) {
        topForever!.add(Top.fromJson(v));
      });
    }
    if (json['topWeek'] != null) {
      topWeek = <Top>[];
      json['topWeek'].forEach((v) {
        topWeek!.add(Top.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasError'] = hasError;
    if (presale != null) {
      data['presale'] = presale!.map((v) => v.toJson()).toList();
    }
    if (public != null) {
      data['public'] = public!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    if (whitelist != null) {
      data['whitelist'] = whitelist!.map((v) => v.toJson()).toList();
    }
    if (topForever != null) {
      data['topForever'] = topForever!.map((v) => v.toJson()).toList();
    }
    if (topWeek != null) {
      data['topWeek'] = topWeek!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stuff {
  Launchpad? launchpad;
  String? artwork;
  String? name;
  String? description;

  Stuff({this.launchpad, this.artwork, this.name, this.description});

  Stuff.fromJson(Map<String, dynamic> json) {
    launchpad = json['launchpad'] != null
        ? Launchpad.fromJson(json['launchpad'])
        : null;
    artwork = json['artwork'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (launchpad != null) {
      data['launchpad'] = launchpad!.toJson();
    }
    data['artwork'] = artwork;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}


class Launchpad {
  int? id;
  int? creatorId;
  int? collectionId;
  bool? justPublic;
  String? whitelistStarts;
  String? whitelistEnds;
  String? presaleStarts;
  String? presaleEnds;
  String? publicStarts;
  int? accessControl;
  int? maxUsers;
  int? maxUserBuys;
  int? currencyPreSale;
  int? amountPreSale;
  int? currencyPublic;
  double? amountPublic;
  String? encLink;
  bool? isEnded;

  Launchpad(
      {this.id,
        this.creatorId,
        this.collectionId,
        this.justPublic,
        this.whitelistStarts,
        this.whitelistEnds,
        this.presaleStarts,
        this.presaleEnds,
        this.publicStarts,
        this.accessControl,
        this.maxUsers,
        this.maxUserBuys,
        this.currencyPreSale,
        this.amountPreSale,
        this.currencyPublic,
        this.amountPublic,
        this.encLink,
        this.isEnded});

  Launchpad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    collectionId = json['collection_id'];
    justPublic = json['just_public'];
    whitelistStarts = json['whitelist_starts'];
    whitelistEnds = json['whitelist_ends'];
    presaleStarts = json['presale_starts'];
    presaleEnds = json['presale_ends'];
    publicStarts = json['public_starts'];
    accessControl = json['access_control'];
    maxUsers = json['max_users'];
    maxUserBuys = json['max_user_buys'];
    currencyPreSale = json['currency_pre_sale'];
    amountPreSale = json['amount_pre_sale'];
    currencyPublic = json['currency_public'];
    amountPublic = json['amount_public'] != null ? double.parse(json['amount_public'].toString()) : null;
    encLink = json['enc_link'];
    isEnded = json['is_ended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['collection_id'] = collectionId;
    data['just_public'] = justPublic;
    data['whitelist_starts'] = whitelistStarts;
    data['whitelist_ends'] = whitelistEnds;
    data['presale_starts'] = presaleStarts;
    data['presale_ends'] = presaleEnds;
    data['public_starts'] = publicStarts;
    data['access_control'] = accessControl;
    data['max_users'] = maxUsers;
    data['max_user_buys'] = maxUserBuys;
    data['currency_pre_sale'] = currencyPreSale;
    data['amount_pre_sale'] = amountPreSale;
    data['currency_public'] = currencyPublic;
    data['amount_public'] = amountPublic;
    data['enc_link'] = encLink;
    data['is_ended'] = isEnded;
    return data;
  }
}

class Top {
  String? name;
  int? launchpadId;
  double? totalAmount;
  String? imageUrl;

  Top({this.name, this.launchpadId, this.totalAmount, this.imageUrl});

  Top.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    launchpadId = json['launchpad_id'];
    totalAmount = json['total_amount'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['launchpad_id'] = launchpadId;
    data['total_amount'] = totalAmount;
    data['image_url'] = imageUrl;
    return data;
  }
}
