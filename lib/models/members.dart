import 'package:rocketbot/models/social_media_accounts.dart';

class Members {
  Members({
    String? received,
    SocialMediaAccount? socialMediaAccount,}){
    _received = received;
    _socialMediaAccount = socialMediaAccount;
  }

  Members.fromJson(dynamic json) {
    _received = json['received'];
    _socialMediaAccount = json['socialMediaAccount'] != null ? SocialMediaAccount.fromJson(json['socialMediaAccount']) : null;
  }
  String? _received;
  SocialMediaAccount? _socialMediaAccount;
  Members copyWith({  String? received,
    SocialMediaAccount? socialMediaAccount,
  }) => Members(  received: received ?? _received,
    socialMediaAccount: socialMediaAccount ?? _socialMediaAccount,
  );
  String? get received => _received;
  SocialMediaAccount? get socialMediaAccount => _socialMediaAccount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['received'] = _received;
    if (_socialMediaAccount != null) {
      map['socialMediaAccount'] = _socialMediaAccount?.toJson();
    }
    return map;
  }

}