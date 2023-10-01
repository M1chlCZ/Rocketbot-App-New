import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/main.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/about_screen.dart';
import 'package:rocketbot/screens/auth_screen.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'package:rocketbot/screens/security_screen.dart';
import 'package:rocketbot/screens/socials_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/widgets/menu_node.dart';
import 'package:rocketbot/widgets/menu_section.dart';

import '../models/user.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback socials;

  const SettingsScreen({Key? key, required this.socials}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  NetInterface interface = NetInterface();
  var dropLanguageValue = globals.languages[0];
  final List<int> _socials = [];
  var firstValue = false;
  var secondValue = true;
  bool _socialsOK = true;
  bool twoFactor = false;
  User? _me;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    Future.delayed(Duration.zero).then((_) async {
      if (context.mounted) {
        final Locale appLocale = Localizations.localeOf(context);
        var i = globals.languageCodes.indexWhere((element) => element.contains(appLocale.toString()));
        if (i != -1) {
          setState(() {
            dropLanguageValue = globals.languages[i];
          });
        } else {
          setState(() {
            dropLanguageValue = globals.languages[0];
          });
        }
      }
    });
    getTwoFactor();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                  child: Row(
                    children: [
                      Text("Settings", style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.settings_main,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.0, color: Colors.white24),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white12,
                      ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const SizedBox(
                      //       width: 7,
                      //     ),
                      //     Text('Lorem Ipsum',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headlineMedium!
                      //             .copyWith(
                      //                 fontSize: 14.0, color: Colors.white)),
                      //     const Expanded(
                      //       child: SizedBox(
                      //       ),
                      //     ),
                      //     NeuContainer(
                      //       width: 60,
                      //       height: 25,
                      //       child: FlutterSwitch(
                      //         activeSwitchBorder: Border.all(
                      //           color: Colors.green,
                      //           width: 2.0,
                      //         ),
                      //         inactiveSwitchBorder: Border.all(
                      //           color: Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         inactiveToggleColor: Colors.red,
                      //         activeToggleColor: Colors.green,
                      //         activeColor: Colors.transparent,
                      //         inactiveColor: Colors.transparent,
                      //         width: 40.0,
                      //         height: 15.0,
                      //         valueFontSize: 5.0,
                      //         toggleSize: 10.0,
                      //         value: firstValue,
                      //         borderRadius: 14.0,
                      //         padding: 1.0,
                      //         showOnOff: false,
                      //         onToggle: (val) {
                      //           setState(() {
                      //             firstValue = val;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 12,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 7,
                          ),
                          Text(AppLocalizations.of(context)!.language,
                              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 14.0, color: Colors.white)),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.4,
                          // ),
                          const SizedBox(
                            width: 120,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: NeuContainer(
                                radius: 10.0,
                                color: Colors.black26,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropLanguageValue,
                                      isDense: true,
                                      onChanged: (String? val) {
                                        // print(val!);
                                        dropLanguageValue = val!;
                                        setState(() {
                                          Locale l;
                                          int index = globals.languages.indexWhere((values) => values.contains(val));
                                          // print(index);
                                          var ls = globals.languageCodes[index].split('_');
                                          if (ls.length == 1) {
                                            l = Locale(ls[0], '');
                                          } else if (ls.length == 2) {
                                            l = Locale(ls[0], ls[1]);
                                          } else {
                                            l = Locale.fromSubtags(countryCode: ls[2], scriptCode: ls[1], languageCode: ls[0]);
                                          }
                                          MyApp.of(context)?.setLocale(l);
                                          SecureStorage.writeStorage(key: globals.localeApp, value: globals.languageCodes[index]);
                                        });
                                      },
                                      items: globals.languages
                                          .map((e) => DropdownMenuItem(value: e, child: SizedBox(width: 70, child: Text(e))))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.settings_socials,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.0, color: Colors.white24),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white12,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: Card(
                            elevation: 0,
                            color: Theme.of(context).canvasColor,
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _goToSocials();
                              },
                              // widget.coinSwitch(widget.coin);
                              // widget.activeCoin(widget.coin.coin!);

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(AppLocalizations.of(context)!.socials_popup.toLowerCase().capitalize(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(fontSize: 14.0, color: _socialsOK ? Colors.white : const Color(0xFFF35656))),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    NeuButton(
                                        height: 25,
                                        width: 20,
                                        onTap: () async {
                                          _goToSocials();
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white,
                                          size: 22.0,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      MenuSection(sectionName: AppLocalizations.of(context)!.settings_privacy, children: [
                        MenuNode(menuText: AppLocalizations.of(context)!.sc_security, goto: _handlePIN),
                        MenuNode(
                            menuText: '2FA',
                            goto: () {
                              if (twoFactor) {
                                Dialogs.open2FABoxNew(context, _unset2FA);
                              } else {
                                _get2FACode();
                              }
                            })
                      ]),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MenuSection(sectionName: "Miscellaneous", children: [
                        MenuNode(menuText: AppLocalizations.of(context)!.about, goto: _gotoAbout),
                        MenuNode(menuText: AppLocalizations.of(context)!.log_out, goto: _logOut)
                      ]),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handlePIN() async {
    var bl = false;
    String? p = await SecureStorage.readStorage(key: "PIN");
    if (p == null) {
      bl = true;
    }
    if (context.mounted) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return AuthScreen(
              setupPIN: bl,
              type: 1,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => _authCallback(value));
    }
  }

  void _authCallback(bool? b) async {
    if (b == null || b == false) return;
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return const SecurityScreen();
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  void _goToSocials() {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return SocialScreen(
            socials: _socials,
            me: _me!,
          );
        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _getUserInfo());
  }

  _getUserInfo() async {
    try {
      final response = await interface.get("User/Me");
      var d = User.fromJson(response);
      if (d.hasError == false) {
        _me = d;
        for (var element in d.data!.socialMediaAccounts!) {
          _socials.add(element.socialMedia!);
        }
        if (_socials.isNotEmpty) {
          setState(() {
            _socialsOK = true;
          });
        } else {
          setState(() {
            _socialsOK = false;
          });
        }
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    widget.socials();
  }

  _gotoAbout() {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return const AboutScreen();
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  _logOut() {
    Dialogs.openLogOutBox(context, () async {
      await SecureStorage.deleteAll();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return const LoginScreen();
        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }));
      }
    });
  }

  getTwoFactor() async {
    try {
      NetInterface ci = NetInterface();
      Map<String, dynamic> m = await ci.get("/twofactor/check", pos: true, debug: false);
      Future.delayed(Duration.zero, () {
        setState(() {
          twoFactor = m['twoFactor'];
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _set2FA(String code) async {
    Dialogs.open2FASetBox(context, code, _confirm2FA);
  }

  var run = false;

  _confirm2FA(String? s) async {
    if (!run) {
      run = true;
      try {
        NetInterface interface = NetInterface();
        await interface.post("/twofactor/activate", {"code": s}, pos: true, debug: false);
        if (mounted) Navigator.of(context).pop();
        setState(() {
          twoFactor = true;
        });
        if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.alert, "2FA activated");
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    run = false;
  }

  var settingUP = false;

  _unset2FA(String? s) async {
    if (settingUP) {
      return;
    } else {
      settingUP = true;
    }
    Navigator.of(context).pop();
    try {
      NetInterface interface = NetInterface();
      await interface.post("/twofactor/remove", {"token": s}, pos: true, debug: false);

      setState(() {
        twoFactor = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "2FA disabled",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.fixed,
          elevation: 5.0,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "2FA disable error",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.fixed,
          elevation: 5.0,
        ));
      }
      debugPrint(e.toString());
    }
    settingUP = false;
  }

  _get2FACode() async {
    try {
      NetInterface interface = NetInterface();
      Map<String, dynamic> m = await interface.post("/twofactor", {}, pos: true, debug: false);

      _set2FA(m['code']);
    } catch (e) {
      var err = jsonDecode(e.toString());
      if (mounted) {
        Dialogs.openAlertBox(context, "Error", err['errorMessage']);
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
