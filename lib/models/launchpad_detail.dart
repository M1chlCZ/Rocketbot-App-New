class LaunchpadMobileDetail {
  List<String>? artworks;
  Collection? collection;
  String? currentStage;
  bool? hasError;
  int? launchpadAccess;
  LaunchpadData? launchpadData;
  int? remaining;
  String? status;
  int? userState;
  String? creator;
  int? sales;
  List<WhitelistPeople>? whitelistPeople;
  List<WhitelistPeople>? salesPeople;

  LaunchpadMobileDetail(
      {this.artworks,
        this.collection,
        this.currentStage,
        this.hasError,
        this.launchpadAccess,
        this.launchpadData,
        this.remaining,
        this.status,
        this.userState,
        this.creator,
        this.salesPeople,
        this.whitelistPeople});

  LaunchpadMobileDetail.fromJson(Map<String, dynamic> json) {
    artworks = json['artworks'].cast<String>();
    collection = json['collection'] != null
        ? Collection.fromJson(json['collection'])
        : null;
    currentStage = json['current_stage'];
    hasError = json['hasError'];
    launchpadAccess = json['launchpad_access'];
    launchpadData = json['launchpad_data'] != null
        ? LaunchpadData.fromJson(json['launchpad_data'])
        : null;
    remaining = json['remaining'];
    status = json['status'];
    userState = json['user_state'];
    creator = json['creator'];
    sales = json['sales'];
    if (json['whitelist_people'] != null) {
      whitelistPeople = <WhitelistPeople>[];
      json['whitelist_people'].forEach((v) {
        whitelistPeople!.add(WhitelistPeople.fromJson(v));
      });
    }
    if (json['sale_people'] != null) {
      salesPeople = <WhitelistPeople>[];
      json['sale_people'].forEach((v) {
        salesPeople!.add(WhitelistPeople.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['artworks'] = artworks;
    if (collection != null) {
      data['collection'] = collection!.toJson();
    }
    data['current_stage'] = currentStage;
    data['hasError'] = hasError;
    data['launchpad_access'] = launchpadAccess;
    if (launchpadData != null) {
      data['launchpad_data'] = launchpadData!.toJson();
    }
    data['remaining'] = remaining;
    data['status'] = status;
    data['user_state'] = userState;
    data['sales'] = sales;
    data['creator'] = creator;
    if (whitelistPeople != null) {
      data['whitelist_people'] =
          whitelistPeople!.map((v) => v.toJson()).toList();
    }
    if (salesPeople != null) {
      data['sale_people'] =
          salesPeople!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Collection {
  String? name;
  String? description;
  int? timeframe;

  Collection({this.name, this.description, this.timeframe});

  Collection.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    timeframe = json['timeframe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['timeframe'] = timeframe;
    return data;
  }
}

class LaunchpadData {
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
  int? amountPublic;
  String? encLink;
  bool? isEnded;

  LaunchpadData(
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

  LaunchpadData.fromJson(Map<String, dynamic> json) {
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
    amountPublic = json['amount_public'];
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

class WhitelistPeople {
  int? id;
  String? name;
  String? pfpUrl;
  bool? verified;
  String? bio;
  String? createdAt;

  WhitelistPeople({this.id, this.name, this.pfpUrl, this.verified, this.bio, this.createdAt});

  WhitelistPeople.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pfpUrl = json['pfp_url'];
    verified = json['verified'];
    bio = json['bio'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pfp_url'] = pfpUrl;
    data['verified'] = verified;
    data['bio'] = bio;
    data['created_at'] = createdAt;
    return data;
  }
}
