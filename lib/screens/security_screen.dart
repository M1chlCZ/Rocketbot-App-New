import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/screens/auth_screen.dart';
import 'package:flutter_biometrics/flutter_biometrics.dart';
import 'package:rocketbot/support/secure_storage.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  SecurityScreenState createState() => SecurityScreenState();
}

class SecurityScreenState extends State<SecurityScreen> {
  String? _biometrics;
  var firstValue = false;
  var secondValue = true;

  String _dropValue = 'PIN';
  final List<String> _dropValues = ['PIN'];

  @override
  void initState() {
    super.initState();
    _initBio();
  }

  _initBio() async {
    await _getBiometrics();
    await _getAuthType();
  }

  _getBiometrics() async {
    try {
      if (Platform.isIOS) {
        _biometrics = await FlutterBiometrics.availableBiometrics;
        _dropValues.clear();
        if (_biometrics != null && _biometrics != "nothing") {
          _dropValues.add('PIN');
          _dropValues.add(_biometrics!);
          _dropValues.add("PIN + ${_biometrics!}");
        } else {
          _dropValues.add('PIN');
        }
      } else {
        _dropValues.clear();
        _dropValues.add('PIN');
        _dropValues.add("Fingerprint");
        _dropValues.add("PIN + Fingerprint");
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getAuthType() async {
    String? auth = await SecureStorage.readStorage(key: "AUTH_TYPE");
    if (auth != null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _dropValue = _dropValues[int.parse(auth)];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SafeArea(
          child: Stack(
            children: [
              Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 25,
                        child: NeuButton(
                          onTap: () {
                            Navigator.of(context).pop();
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
                      Text(AppLocalizations.of(context)!.sc_security,
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sc_auth_headline,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 14.0, color: Colors.white24),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.white12,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.sc_auth_type,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontSize: 14.0, color: Colors.white)),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.4,
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 80.0, right: 8.0),
                                child: SizedBox(
                                  height: 30,
                                  child: NeuContainer(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _dropValue,
                                          isDense: true,
                                          onChanged: (String? val) {
                                            setState(() {
                                              _dropValue = val!;
                                            });
                                            int index = _dropValues.indexWhere(
                                                (values) =>
                                                    values.contains(val!));
                                            SecureStorage.writeStorage(
                                                key: "AUTH_TYPE",
                                                value: index.toString());
                                          },
                                          items: _dropValues
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: SizedBox(
                                                      width: 70,
                                                      child: Text(e))))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.sc_pin_settings,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 14.0, color: Colors.white24),
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
                                  _changePIN();
                                },
                                // widget.coinSwitch(widget.coin);
                                // widget.activeCoin(widget.coin.coin!);

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .sc_change_pin,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _removePIN();
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              )),
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
                                  _removePIN();
                                },
                                // widget.coinSwitch(widget.coin);
                                // widget.activeCoin(widget.coin.coin!);

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .sc_remove_pin,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _removePIN();
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ))
              ])
            ],
          ),
        ),
      ),
    );
  }

  void _removePIN() {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return const AuthScreen(
            type: 2,
          );
        }, transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _removePINCallback(value));
  }

  void _removePINCallback(bool? b) async {
    if (b != null || b != false) {
      SecureStorage.deleteStorage(key: "PIN");
      await Future.delayed(const Duration(milliseconds: 200), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: SizedBox(
              height: 40.0,
              child: Center(
                  child: Text(AppLocalizations.of(context)!.sc_pin_removed))),
          backgroundColor: Colors.green,
        ));
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.of(context).pop();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: SizedBox(
              height: 40.0,
              child: Center(
                  child: Text(AppLocalizations.of(context)!.sc_pin_removed))),
          backgroundColor: Colors.green,
        ));
      });
    }
  }

  void _changePIN() {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return const AuthScreen(
            type: 2,
          );
        }, transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _changePINCallback(value));
  }

  void _changePINCallback(bool? b) {
    if (b == null || b == false) return;
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return const AuthScreen(setupPIN: true);
        }, transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _changeSucc(value));
  }

  void _changeSucc(bool? b) async {
    bool state = false;
    if (b != null || b != false) {
      state = true;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SizedBox(
            height: 40.0,
            child: Center(
                child: Text(state
                    ? AppLocalizations.of(context)!.sc_change_succ
                    : AppLocalizations.of(context)!.sc_change_fuck))),
        backgroundColor: state ? Colors.green : Colors.red,
      ));
    });
  }

  // void _authCallback(bool b) {
  //   debugPrint(b.toString());
  // }
}
