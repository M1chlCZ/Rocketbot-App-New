import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/withdraw_pwid.dart';
import 'package:rocketbot/netinterface/app_exception.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screens/auth_screen.dart';
import 'package:rocketbot/support/auto_size_text_field.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/qr_code_scanner.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/picture_cache.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SendPage extends StatefulWidget {
  final Coin? coinActive;
  final Function(double free) changeFree;
  final double? free;

  const SendPage({super.key, this.coinActive, this.free, required this.changeFree});

  @override
  SendPageState createState() => SendPageState();
}

class SendPageState extends State<SendPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<SlideActionState> _keyStake = GlobalKey();
  final NetInterface _interface = NetInterface();

  Coin? _coinActive;
  bool _curtain = true;
  bool _copyIconVisible = true;
  bool _error = false;
  double _free = 0.0;
  double _fee = 0.0;
  double _min = 0.0;
  String _feeCrypto = '';

  @override
  void initState() {
    super.initState();
    _coinActive = widget.coinActive ?? Coin(id: 0);
    _getFees();
    _addressController.text = '';
    _addressController.addListener(() {
      if (_addressController.text.isEmpty) {
        setState(() {
          _copyIconVisible = true;
        });
      } else {
        setState(() {
          _copyIconVisible = false;
        });
      }
    });
    _curtain = false;
    if (kDebugMode) {
      _addressController.text = 'MSrEScTooTrKkvaFwPCxCBrBnvwdWNozjJ';
    }
  }

  _getFees() async {
    try {
      _free = widget.free!;
      final response = await _interface.get("Transfers/GetWithdrawFee?coinId=${widget.coinActive!.id!}");
      var d = Fees.fromJson(response);
      setState(() {
        _feeCrypto = d.data!.feeCrypto!.ticker!;
        _fee = d.data!.fee!;
        _min = d.data!.crypto!.minWithdraw!;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _handlePIN() async {
    String? p = await SecureStorage.readStorage(key: "PIN");
    if (p == null) {
      _authCallback(true);
      return;
    }
    if (context.mounted) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return const AuthScreen(
              setupPIN: false,
              type: 2,
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }))
          .then((value) => _authCallback(value));
    }
  }

  void _authCallback(bool? b) async {
    if (b == null || b == false) return;
    _createWithdrawal();
  }

  _createWithdrawal() async {
    if (_amountController.text.isEmpty) {
      _keyStake.currentState!.reset();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Invalid amount!");
      return;
    }
    if (_addressController.text.isEmpty) {
      _keyStake.currentState!.reset();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Invalid address!");
      return;
    }
    try {
      Map<String, dynamic> query = {"coinId": widget.coinActive!.id!, "fee": _fee, "amount": double.parse(_amountController.text), "toAddress": _addressController.text};

      final response = await _interface.post("Transfers/CreateWithdraw", query);
      var pwid = WithdrawID.fromJson(response);
      if (kDebugMode) {
        print(response);
      }
      Map<String, dynamic> queryID = {
        "id": pwid.data!.pgwIdentifier!,
      };
      await _interface.post("Transfers/ConfirmWithdraw", queryID);
      // var rw = WithdrawConfirm.fromJson(resWith);

      _addressController.clear();
      _amountController.clear();

      var preFree = 0.0;
      var res = await _interface.get('User/GetBalance?coinId=${_coinActive!.id!}');
      var rs = BalancePortfolio.fromJson(res);
      preFree = rs.data!.free!;
      widget.changeFree(preFree);
      _keyStake.currentState!.reset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: SizedBox(
              height: 30,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.coin_sent,
                style: Theme.of(context).textTheme.headlineMedium,
              ))),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.fixed,
          elevation: 5.0,
        ));
      }
    } on ConflictDataException catch (r) {
      _keyStake.currentState!.reset();
      var err = json.decode(r.toString());
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, err['error']);
    } catch (e) {
      _keyStake.currentState!.reset();
      // var err = InvalidReq.fromJson(e.toString());
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, e.toString());
    }
  }

  _getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      if (data!.text != null) _addressController.text = data.text!;
      _addressController.selection = TextSelection.collapsed(offset: _addressController.text.length);
    });
  }

  @override
  void setState(fn) {
    if (context.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 25,
                        child: FlatCustomButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 24.0,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          AppLocalizations.of(context)!.send,
                          style: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _coinActive == null
                          ? const Icon(
                              Icons.monetization_on,
                              size: 50.0,
                              color: Colors.white,
                            )
                          : SizedBox(width: 50.0, height: 50.0, child: PictureCacheWidget(coin: widget.coinActive!)),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        height: 65.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    _coinActive == null ? AppLocalizations.of(context)!.choose_coin : _coinActive!.ticker!,
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: SizedBox(
                                    width: 70,
                                    child: AutoSizeText(
                                      _coinActive == null ? 'Token' : _coinActive!.name!,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontStyle: FontStyle.normal, fontSize: 12.0),
                                      minFontSize: 8,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    _free.toString(),
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 40.0,
                  margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: const Color(0xFF9BD41E), width: 1.0), color: Colors.white.withOpacity(0.03)),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      AutoSizeTextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+')),
                          ],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12.0),
                          autocorrect: false,
                          controller: _addressController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            isDense: false,
                            contentPadding: const EdgeInsets.only(bottom: 9.0),
                            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white54, fontSize: 12.0),
                            hintText: AppLocalizations.of(context)!.address,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          )),
                      Visibility(
                        visible: _copyIconVisible,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                _getClipBoardData();
                              },
                              child: Image.asset(
                                'images/copy.png',
                                width: 18.0,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 40.0,
                  margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: const Color(0xFF9BD41E), width: 1.0), color: Colors.white.withOpacity(0.03)),
                  child: TextField(
                      keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                      ],
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12.0),
                      autocorrect: false,
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: false,
                        contentPadding: const EdgeInsets.only(bottom: 9.0),
                        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white54, fontSize: 12.0),
                        hintText: AppLocalizations.of(context)!.amount,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                _error
                    ? Text(
                        AppLocalizations.of(context)!.dp_error,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.red.withOpacity(0.5)),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          margin: const EdgeInsets.only(left: 30.0, right: 30),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: const Color(0xFF9BD41E)),
                          child: SlideAction(
                            height: 60.0,
                            sliderButtonIconPadding: 6.0,
                            borderRadius: 10.0,
                            text: AppLocalizations.of(context)!.send_swipe,
                            innerColor: const Color(0xFF9BD41E),
                            outerColor: const Color(0xFF252F45),
                            elevation: 0.5,
                            // submittedIcon: const Icon(Icons.check, size: 30.0, color: Colors.lightGreenAccent,),
                            submittedIcon: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.lightGreenAccent,
                            ),
                            sliderButtonIcon: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF252F45),
                              size: 35.0,
                            ),
                            sliderRotate: false,
                            textStyle: const TextStyle(fontFamily: 'JosefinSans', fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.white),
                            key: _keyStake,
                            onSubmit: () {
                              _handlePIN();
                              return null;
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                AnimatedOpacity(
                  opacity: _feeCrypto.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${AppLocalizations.of(context)!.min_withdraw}:', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text('$_min ${widget.coinActive!.ticker!.toUpperCase()}', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${AppLocalizations.of(context)!.fees}:', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text('$_fee $_feeCrypto', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.white30,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  AppLocalizations.of(context)!.or_send_scan_qr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FlatCustomButton(
                  radius: 8.0,
                  color: Colors.lightGreen.withOpacity(0.5),
                  onTap: () {
                    _openQRScanner();
                  },
                  width: 140,
                  height: 140,
                  child: Image.asset(
                    "images/qr_code_scan.png",
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _curtain,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              color: const Color(0xFF1B1B1B),
              child: Center(
                child: HeartbeatProgressIndicator(
                  startScale: 0.01,
                  endScale: 0.2,
                  child: const Image(
                    image: AssetImage('images/rocketbot_logo.png'),
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openQRScanner() async {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 200), () async {
      var status = await Permission.camera.status;
      if (await Permission.camera.isPermanentlyDenied) {
        // await Dialogs.openAlertBoxReturn(context, "Warning", "Please grant this app permissions for Camera");
        openAppSettings();
      } else if (status.isDenied) {
        var r = await Permission.camera.request();
        if (r.isGranted) {
          if (context.mounted) {
            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
              return QScanWidget(
                scanResult: (String s) {
                  _addressController.text = s;
                },
              );
            }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(opacity: animation, child: child);
            }));
          }
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return QScanWidget(
              scanResult: (String s) {
                _addressController.text = s;
              },
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
        }
      }
    });
  }
}
