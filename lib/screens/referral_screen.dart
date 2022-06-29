import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/referral_widget.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  GlobalKey globalKey = GlobalKey();
  GlobalKey<ReferralWidgetState> refKey = GlobalKey();
  NetInterface interface = NetInterface();
  String? refCode;
  bool refUsed = true;

  @override
  void initState() {
    super.initState();
    _getRefCode();
    _checkStatus();
  }

  _getRefCode() async {
    var res = await interface.get('code/get', pos: true);
    refCode = res['refCode'];
    setState(() {});
  }

  Future<void> _share() async {
    try {
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ImageByteFormat.png);
      final imageBytes = byteData?.buffer.asUint8List();
      if (imageBytes != null) {
        final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory!.path}/qr_code.png').create();
        await imagePath.writeAsBytes(imageBytes);
        Share.shareFiles(['${directory.path}/qr_code.png'], text: "Earn 100 free coins now! \nDownload RocketBot wallet app, and get paid to engage on social media with giveaways & airdrops.\n\nUse my referral code: $refCode \n\niOS - https://apple.co/38lAzWO \nAndroid - https://bit.ly/33NZlfS\n#Merge @rocketbotpro"
        );
      }
    } catch (e) {
      print(e);
    }
  }

  _checkStatus() async {
    String? s = await SecureStorage.readStorage(key: 'refCode');
    if (s == null || s.isEmpty) {
      String udid = await FlutterUdid.consistentUdid;
      Map<String, dynamic> m = await interface.post('code/check', {"uuid": udid}, pos: true);
      if (m[refCode] == true) {
        setState(() {
          refUsed = true;
        });
      } else {
        setState(() {
          refUsed = false;
        });
      }
    } else {
      setState(() {
        refUsed = true;
      });
    }
  }

  Future<void> _getReward(String? code) async {
    String udid = await FlutterUdid.consistentUdid;
    if (code != null) {
      try {
        await interface.post('code/submit', {"referral": code, "uuid": udid}, pos: true);
        await SecureStorage.writeStorage(key: "refCode", value: code);
        _checkStatus();
        if (mounted) Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.alert.toLowerCase()}", "Your reward is on the way!");
      } catch (e) {
        refKey.currentState?.clearText();
        if (mounted) Dialogs.openAlertBox(context, "Referral ${AppLocalizations.of(context)!.error.toLowerCase()}", e.toString());
      }
    }
    _checkStatus();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Material(
          child: SafeArea(
            child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    Text(AppLocalizations.of(context)!.referral, style: Theme.of(context).textTheme.headline4),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.transparent.withOpacity(0.04),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    refUsed == false
                        ? Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              // color: Colors.white.withOpacity(0.05)
                              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                Color(0xFF079F7F),
                                Color(0xFFE9522A),
                              ]),
                            ),
                            child: Column(
                              children: [
                                GradientText(
                                  AppLocalizations.of(context)!.ref_invite,
                                  align: TextAlign.left,
                                  gradient: const LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white70,
                                  ]),
                                  style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18.0, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                ReferralWidget(
                                    key: refKey,
                                    refCode: (refCode) {
                                      _getReward(refCode);
                                    }),
                                // SizedBox(
                                //   height: 50,
                                //   child: FlatCustomButton(
                                //     color: Colors.white12,
                                //     onTap: () {
                                //       _openQRScanner();
                                //     },
                                //     child: Text('Get the Reward',
                                //         style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: const Color(0xFFFFFFFF))),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                GradientText(
                                  AppLocalizations.of(context)!.ref_hint,
                                  align: TextAlign.center,
                                  gradient: const LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white70,
                                  ]),
                                  style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 10.0, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              // color: Colors.white.withOpacity(0.05)
                              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                Color(0xFF2F67BD),
                                Color(0xFFE05A37),
                              ]),
                            ),
                            child: Column(
                              children: [
                                GradientText(
                                  AppLocalizations.of(context)!.ref_unvite,
                                  align: TextAlign.left,
                                  gradient: const LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white70,
                                  ]),
                                  style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    RepaintBoundary(
                      key: globalKey,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: const LinearGradient(colors: [
                            Color(0xFFF05523),
                            Color(0xFF812D88),
                          ]),
                        ),
                        child: Column(
                          children: [
                            AutoSizeText(
                              AppLocalizations.of(context)!.ref_code,
                              minFontSize: 8.0,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: 350,
                              height: 320,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: refCode == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black54,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: QrImage(
                                          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
                                          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle),
                                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                                          data: refCode ?? 'empty',
                                          foregroundColor: const Color(0xFF681E6E),
                                          backgroundColor: Colors.white,
                                          version: QrVersions.auto,
                                          embeddedImage: const AssetImage("images/rocket_pin.png"),
                                          gapless: false,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: FlatCustomButton(
                        color: Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Share',
                              style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(width: 20.0, child: Image.asset('images/share.png')),
                          ],
                        ),
                        onTap: () {
                          _share();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ])),
          ),
        ),
      ],
    );
  }
}
