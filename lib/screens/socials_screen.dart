import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/models/socials.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/auto_size_text_field.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/social_card.dart';

import '../models/user.dart';

class SocialScreen extends ConsumerStatefulWidget {
  final List<int> socials;
  final User me;

  const SocialScreen({Key? key, required this.socials, required this.me}) : super(key: key);

  @override
  SocialScreenState createState() => SocialScreenState();
}

class SocialScreenState extends LifecycleWatcherState<SocialScreen> {
  final NetInterface _interface = NetInterface();
  final TextEditingController _discordTextController = TextEditingController();
  List<int> _socials = [];
  bool _paused = false;
  User? _me;

  Socials? _discord;
  Socials? _twitter;
  Socials? _telegram;
  Socials? _twitch;

  SocialMediaAccounts? _twitterAccount;
  SocialMediaAccounts? _telegramAccount;
  SocialMediaAccounts? _discordAccount;
  SocialMediaAccounts? _twitchAccount;

  bool _discordDetails = false;

  @override
  void initState() {
    _socials = widget.socials;
    _me = widget.me;
    super.initState();
    _loadDirectives();
    _getAccounts();
  }

  @override
  void setState(fn) {
    if (context.mounted) {
      super.setState(fn);
    }
  }

  _loadDirectives() async {
    await _loadDiscordDirective();
    await _loadTwitterDirective();
    await _loadTelegramDirective();
    await _loadTwitchDirective();
  }

  _getUserInfo() async {
    try {
      final response = await _interface.get("User/Me");
      var d = User.fromJson(response);
      _twitterAccount = null;
      _telegramAccount = null;
      _discordAccount = null;
      _twitchAccount = null;
      if (d.hasError == false) {
        _socials.clear();
        _me = d;
        for (var element in d.data!.socialMediaAccounts!) {
          _socials.add(element.socialMedia!);
        }
        await _getAccounts();
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getAccounts() async {
    try {
      _twitterAccount = _me!.data!.socialMediaAccounts?.firstWhere((element) => element.socialMedia == 3);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _telegramAccount = _me!.data!.socialMediaAccounts?.firstWhere((element) => element.socialMedia == 2);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _discordAccount = _me!.data!.socialMediaAccounts?.firstWhere((element) => element.socialMedia == 1);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _twitchAccount = _me!.data!.socialMediaAccounts?.firstWhere((element) => element.socialMedia == 4);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _loadDiscordDirective() async {
    Map<String, dynamic> request = {
      "socialMedia": 1,
    };
    try {
      final response = await _interface.get("/Auth/ConnectAccount?socialMedia=1",);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _discord = d;
        _discordTextController.text = 'connect ${_discord!.data!.url!}';
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _loadTwitterDirective() async {
    try {
      final response = await _interface.get("/Auth/ConnectAccount?socialMedia=3");
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _twitter = d;
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _loadTelegramDirective() async {
    try {
      final response = await _interface.get("/Auth/ConnectAccount?socialMedia=2");
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _telegram = d;
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _loadTwitchDirective() async {
    try {
      final response = await _interface.get("/Auth/ConnectAccount?socialMedia=4", debug: true);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _twitch = d;
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _socialsDisconnect(int socSite) async {
    Map<String, dynamic> request = {
      "socialMedia": socSite,
    };
    try {
      final response = await _interface.post("Auth/DisconnectSocialMediaAccount", request);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        Future.delayed(const Duration(seconds: 2), () async {
          _socials.clear();
          await _loadDirectives();
          await _getUserInfo();
          setState(() {});
        });
      } else {
        await _loadDirectives();
        setState(() {});
        if (context.mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, d.error!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 25,
                child: NeuButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    // _discordAuth();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(AppLocalizations.of(context)!.socials_popup.toLowerCase().capitalize(), style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                AppLocalizations.of(context)!.social_accounts,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.0, color: Colors.white24),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                height: 0.5,
                color: Colors.white12,
              )
            ])),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(AppLocalizations.of(context)!.socials_info, style: const TextStyle(color: Colors.white70)),
        ),
        const SizedBox(
          height: 30.0,
        ),
        SocialMediaCard(
          name: 'Twitter',
          cardActiveColor: const Color(0xFF1DA1F2),
          pictureName: 'images/twitter.png',
          onTap: () async {
            if (!_socials.contains(3)) {
              await _loadTwitterDirective();
              _launchURL(_twitter!.data!.url!);
            }
          },
          unlink: _socialsDisconnect,
          socials: _twitterAccount,
        ),
        const SizedBox(
          height: 10.0,
        ),
        SocialMediaCard(
          name: 'Telegram',
          cardActiveColor: const Color(0xFF229ED9),
          pictureName: 'images/telegram.png',
          onTap: () async {
            if (!_socials.contains(2)) {
              await _loadTelegramDirective();
              _launchURL(_telegram!.data!.url!);
            }
          },
          socials: _telegramAccount,
          unlink: _socialsDisconnect,
        ),
        const SizedBox(
          height: 10.0,
        ),
        SocialMediaCard(
          name: 'Twitch',
          cardActiveColor: const Color(0xFF6442A5),
          pictureName: 'images/twitch.png',
          onTap: () async {
            if (!_socials.contains(4)) {
              await _loadTwitchDirective();
              _launchURL(_twitch!.data!.url!);
            }
          },
          unlink: _socialsDisconnect,
          socials: _twitchAccount,
        ),
        const SizedBox(
          height: 10.0,
        ),
        SocialMediaCard(
          name: 'Discord',
          cardActiveColor: const Color(0xFF7289DA),
          pictureName: 'images/discord.png',
          onTap: () async {
            if (!_socials.contains(1)) {
              await _loadDiscordDirective();
              _launchURL(_discord!.data!.url!);
            }
          },
          unlink: _socialsDisconnect,
          socials: _discordAccount,
        ),
      ])
    ])));
  }

  void _launchURL(String url) async {
    var kUrl = url.replaceAll(" ", "+");
    Utils.openLink(kUrl);
  }

  @override
  void onDetached() {
    _paused = true;
  }

  @override
  void onInactive() {
    _paused = true;
  }

  @override
  void onPaused() {
    _paused = true;
  }

  @override
  void onResumed() async {
    if (_paused) {
      _getUserInfo();
      _paused = false;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
