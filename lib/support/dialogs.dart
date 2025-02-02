import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/support/dialog_body.dart';
import 'package:rocketbot/widgets/percent_switch_widget.dart';

class Dialogs {
  static Future<void> openAlertBox(context, String? header, String message) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
              header: header ?? AppLocalizations.of(context)!.error,
              buttonLabel: 'OK',
              oneButton: true,
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15.0, right: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      child: Container(
                        color: Colors.black38,
                        padding: const EdgeInsets.all(10.0),
                        child: AutoSizeText(
                          message,
                          textAlign: TextAlign.center,
                          maxLines: 8,
                          maxFontSize: 20.0,
                          minFontSize: 8.0,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0, color: Colors.white70),
                        ),
                      ),
                    ),
                  )));
        });
  }

  static Future<void> open2FAbox(context, String key, Function(String k, String c) getToken) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final TextEditingController codeControl = TextEditingController();
          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            codeControl.addListener(() {
              if (codeControl.text.length == 6) {
                getToken(key, codeControl.text);
              }
            });
            return DialogBody(
              header: AppLocalizations.of(context)!.enter_code,
              buttonLabel: 'OK',
              oneButton: false,
              noButtons: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      color: Colors.black38,
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        autofocus: true,
                        controller: codeControl,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: false,
                          contentPadding: const EdgeInsets.only(bottom: 0.0),
                          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 20.0),
                          hintText: AppLocalizations.of(context)!.enter_code_hint,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  static Future<void> openLogOutBox(context, VoidCallback acc) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
            header: AppLocalizations.of(context)!.log_out,
            buttonLabel: 'OK',
            oneButton: false,
            onTap: () {
              acc();
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(15.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.dl_log_out,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 8,
                      minFontSize: 8.0,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> openMNWithdrawBox(context, int id, VoidCallback acc) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
            header: AppLocalizations.of(context)!.alert,
            buttonLabel: 'OK',
            oneButton: false,
            onTap: () {
              acc();
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(15.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.mn_withdraw_box(id.toString()),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 8,
                      minFontSize: 8.0,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> openSocDisconnectBox(context, int soc, String name, Function(int soc) acc) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
            header: AppLocalizations.of(context)!.unlink(name),
            buttonLabel: 'OK',
            oneButton: false,
            onTap: () async {
              acc(soc);
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(15.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.dl_soc_log_out(name),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 8,
                      minFontSize: 8.0,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void openWaitBox(context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: DialogBody(
              header: "${AppLocalizations.of(context)!.dl_pls_wait}...",
              buttonLabel: '',
              noButtons: true,
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.stake_wait,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70, fontSize: 12.0),
                    ),
                    Text(
                      AppLocalizations.of(context)!.dl_not_close,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70, fontSize: 12.0),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: HeartbeatProgressIndicator(
                          startScale: 0.01,
                          endScale: 0.4,
                          child: const Image(
                            image: AssetImage('images/rocketbot_logo.png'),
                            color: Colors.white30,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> openStakeAdjustment(context, double totalCoins, Function(double k) func) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          double amount = 0.0;
          TextEditingController codeControl = TextEditingController();
          bool tooMuch = false;
          void changePercentage(double percent) {
            amount = totalCoins * percent;
            codeControl.text = amount.toString();
          }

          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            codeControl.addListener(() {
              if (double.parse(codeControl.text.toString()) > totalCoins) {
                tooMuch = true;
              } else {
                tooMuch = false;
              }
              sState(() {});
            });
            return DialogBody(
              header: AppLocalizations.of(context)!.st_amount,
              buttonLabel: 'OK',
              onTap: () {
                if (tooMuch) {
                  Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Amount has to be lower than your whole staking balance");
                } else {
                  amount = double.parse(codeControl.text.toString());
                  func(amount);
                }
              },
              width: MediaQuery.of(context).size.width * 0.97,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          color: tooMuch ? Colors.red.withOpacity(0.3) : Colors.black38,
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            autofocus: true,
                            keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                            ],
                            controller: codeControl,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: false,
                              contentPadding: const EdgeInsets.only(bottom: 0.0),
                              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 20.0),
                              hintText: AppLocalizations.of(context)!.amount,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PercentSwitchWidget(
                      changePercent: changePercentage,
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  static Future<void> open2FABoxNew(context, Function(String? s) func) async {
    final TextEditingController txt = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          var copyIconVisible = true;
          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            txt.addListener(() {
              if (txt.text.isEmpty) {
                copyIconVisible = true;
                sState(() {});
              } else {
                copyIconVisible = false;
                sState(() {});
              }

              if (txt.text.length == 6) {
                func(txt.text);
                return;
              }
            });
            return DialogBody(
              header: "Google 2FA",
              buttonLabel: 'OK',
              oneButton: false,
              noButtons: true,
              onTap: () {
                func(txt.text);
                // Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          color: Colors.black38,
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            autofocus: true,
                            controller: txt,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: false,
                              contentPadding: const EdgeInsets.only(bottom: 0.0),
                              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 18.0),
                              hintText: "Google 2FA",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: copyIconVisible,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0, right: 8),
                          child: GestureDetector(
                            onTap: () async {
                              ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                              // print(data!.text!);
                              if (data?.text != null) {
                                sState(() {
                                  txt.text = data!.text!;
                                  txt.selection = TextSelection.collapsed(offset: txt.text.length);
                                });
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.paste,
                                  color: Color(0xFFFFD301),
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  static Future<void> openWebLoginBox(context, Function(String? s) func) async {
    final TextEditingController txt = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          var copyIconVisible = true;
          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            txt.addListener(() {
              if (txt.text.isEmpty) {
                copyIconVisible = true;
                sState(() {});
              } else {
                copyIconVisible = false;
                sState(() {});
              }

              if (txt.text.length == 6) {
                func(txt.text);
                return;
              }
            });
            return DialogBody(
              header: "Rocket.art web login",
              buttonLabel: 'OK',
              oneButton: false,
              noButtons: true,
              onTap: () {
                func(txt.text);
                // Navigator.of(context).pop(true);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          color: Colors.black38,
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            autofocus: true,
                            controller: txt,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: false,
                              contentPadding: const EdgeInsets.only(bottom: 0.0),
                              hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 18.0),
                              hintText: "Google 2FA",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: copyIconVisible,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0, right: 8),
                          child: GestureDetector(
                            onTap: () async {
                              ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                              // print(data!.text!);
                              if (data?.text != null) {
                                sState(() {
                                  txt.text = data!.text!;
                                  txt.selection = TextSelection.collapsed(offset: txt.text.length);
                                });
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.paste,
                                  color: Color(0xFFFFD301),
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  static Future<void> open2FASetBox(context, String code, Function(String? s) func) async {
    final TextEditingController textController = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          var copyIconVisible = true;
          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            textController.addListener(() {
              if (textController.text.isEmpty) {
                copyIconVisible = true;
              } else {
                copyIconVisible = false;
              }
              sState(() {});
              if (textController.text.length == 6) {
                func(textController.text);
                return;
              }
            });
            return DialogBody(
              header: "Google 2FA",
              buttonLabel: 'OK',
              oneButton: false,
              noButtons: true,
              onTap: () {
                // func(textController.text);
                // Navigator.of(context).pop(true);
              },
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                      child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                color: Colors.black38,
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Copy the code provided to the Google Authetificator and paste 2FA code from it",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.0, color: Colors.white70),
                                ),
                              )))),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                      child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                color: Colors.black38,
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: AutoSizeText(
                                        code,
                                        maxLines: 1,
                                        minFontSize: 8.0,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.0, color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5.0, right: 2),
                                        child: GestureDetector(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(text: code));
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Icon(
                                              Icons.copy,
                                              color: Color(0xFFFFD301),
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )))),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15.0, right: 15.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            child: Container(
                              color: Colors.black38,
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                autofocus: true,
                                controller: textController,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  isDense: false,
                                  contentPadding: const EdgeInsets.only(bottom: 0.0),
                                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54, fontSize: 18.0),
                                  hintText: "Google 2FA",
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24.0, color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: copyIconVisible,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25.0, right: 8),
                              child: GestureDetector(
                                onTap: () async {
                                  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                                  // print(data!.text!);
                                  sState(() {
                                    if (data!.text != null) {
                                      textController.text = data.text!;
                                    }
                                    textController.selection = TextSelection.collapsed(offset: textController.text.length);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.paste,
                                      color: Color(0xFFFFD301),
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  static Future<void> openWebTokenBox(BuildContext context, Function(String webtoken) func) async {
    TextEditingController textController = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
              header: "Enter Rocket.art web code",
              buttonLabel: 'OK',
              onTap: () {
                func(textController.text);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 0, left: 8.0, right: 8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.black12,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  width: 500,
                  child: TextField(
                    autofocus: true,
                    controller: textController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+')),
                    ],
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white.withOpacity(0.8), fontSize: 32),
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(fontStyle: FontStyle.normal, fontSize: 32.0, color: Colors.white54),
                      hintText: "Web Code",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ));
        });
  }
}
