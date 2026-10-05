import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lock_screen_pin/lock_screen_pin.dart';
import 'package:rocketbot/screens/main_menu.dart';
import 'package:rocketbot/screens/security_screen.dart';
import 'package:rocketbot/support/app_services.dart';
import 'package:rocketbot/support/dialogs.dart';

class AuthScreen extends StatefulWidget {
  final bool setupPIN;
  final int type;

  const AuthScreen({super.key, this.setupPIN = false, this.type = 0});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  List<int> _tempPIN = [];
  List<int> _tempPIN2 = [];

  bool _isFingerprint = false;
  bool _firstPIN = true;
  bool _showFinger = false;

  List<int> _myPass = [];

  @override
  void initState() {
    _getPIN();
    _getAuthType();
    super.initState();
  }

  void _getPIN() async {
    String? nums = await secureStore.read("PIN");
    if (nums == null) return;
    _myPass = nums.split('').map(int.parse).toList();
  }

  void _getAuthType() async {
    if (widget.setupPIN != true) {
      var i = await secureStore.read("AUTH_TYPE");
      if (i != null) {
        if (int.parse(i) == 0) {
          setState(() {
            _showFinger = false;
          });
        } else if (int.parse(i) == 1) {
          biometrics();
        } else {
          setState(() {
            _showFinger = true;
          });
        }
      }
    }
  }

  Future<void> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
        biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _showFinger = false;
      });
      if (kDebugMode) {
        print(e);
      }
      if (mounted &&
          (e.code == LocalAuthExceptionCode.noCredentialsSet ||
              e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
              e.code == LocalAuthExceptionCode.noBiometricHardware ||
              e.code == LocalAuthExceptionCode.biometricLockout)) {
        Dialogs.openAlertBox(
            context,
            AppLocalizations.of(context)!.alert,
            AppLocalizations.of(context)!.biometric_unavailable);
      }
    }
    if (!context.mounted) return;
    if (authenticated) {
      setState(() {
        _isFingerprint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
        visible: !widget.setupPIN,
        child: IgnorePointer(
          ignoring: widget.setupPIN,
          child: Material(
            child: SafeArea(
                child: LockScreen(
                    title: AppLocalizations.of(context)!.as_enter_pin,
                    passLength: 6,
                    styles: const PinLockTheme(
                      numberColor: Colors.white70,
                      dotBorderColor: Colors.white,
                    ),
                    fingerPrintImage: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(colors: [
                          Color(0xFFF05523),
                          Color(0xFF812D88),
                        ]).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Image.asset(
                        "images/fingerprint.png",
                        height: 50.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    showFingerPass: _showFinger,
                    fingerFunction: biometrics,
                    fingerVerify: _isFingerprint,
                    showWrongPassDialog: false,
                    strings: PinLockStrings(
                      wrongPassTitle: 'Opps!',
                      wrongPassContent:
                          AppLocalizations.of(context)!.as_wrong_pin,
                      wrongPassCancelButtonText: 'Cancel',
                    ),
                    passCodeVerify: (passcode) async {
                      for (int i = 0; i < _myPass.length; i++) {
                        if (passcode[i] != _myPass[i]) {
                          return false;
                        }
                      }

                      return true;
                    },
                    onSuccess: () {
                      if (widget.type == 0) {
                        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                          return const MainMenuScreen();
                        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                          return FadeTransition(opacity: animation, child: child);
                        }));
                      } else if (widget.type == 2) {
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                          return const SecurityScreen();
                        }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                          return FadeTransition(opacity: animation, child: child);
                        }));
                      }
                    })),
          ),
        ),
      ),
      Visibility(
        visible: widget.setupPIN,
        child: IgnorePointer(
          ignoring: !widget.setupPIN,
          child: Material(
            child: SafeArea(
                child: Stack(
              children: [
                Visibility(
                    visible: _firstPIN,
                    child: IgnorePointer(
                      ignoring: !_firstPIN,
                      child: LockScreen(
                          title: AppLocalizations.of(context)!.as_enter_desired_pin,
                          passLength: 6,
                          styles: const PinLockTheme(
                            numberColor: Colors.white70,
                            dotBorderColor: Colors.white,
                          ),
                          fingerPrintImage: null,
                          showFingerPass: false,
                          fingerVerify: _isFingerprint,
                          showWrongPassDialog: false,
                          strings: const PinLockStrings(
                            wrongPassTitle: '',
                            wrongPassContent: '',
                            wrongPassCancelButtonText: 'Cancel',
                          ),
                          passCodeVerify: (passcode) async {
                            if (passcode.length != 6) {
                              return false;
                            }
                            _tempPIN = passcode;
                            return true;
                          },
                          onSuccess: () {
                            setState(() {
                              _firstPIN = false;
                            });
                          }),
                    )),
                Visibility(
                    visible: !_firstPIN,
                    child: IgnorePointer(
                      ignoring: _firstPIN,
                      child: LockScreen(
                          title: AppLocalizations.of(context)!.as_enter_desired_confirm_pin,
                          passLength: 6,
                          styles: const PinLockTheme(
                            numberColor: Colors.white70,
                            dotBorderColor: Colors.white,
                          ),
                          fingerPrintImage: null,
                          showFingerPass: false,
                          fingerVerify: _isFingerprint,
                          showWrongPassDialog: false,
                          strings: const PinLockStrings(
                            wrongPassTitle: '',
                            wrongPassContent: '',
                            wrongPassCancelButtonText: 'Cancel',
                          ),
                          passCodeVerify: (passcode) async {
                            if (passcode.length != 6) {
                              return false;
                            }
                            _tempPIN2 = passcode;
                            return true;
                          },
                          onSuccess: () {
                            _checkSetupPIN();
                          }),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 80.0, left: 20.0),
                  child: SizedBox.fromSize(
                    size: const Size(40, 40), // button width and height

                    child: ClipOval(
                      child: Material(
                        color: Colors.black12, // button color
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.8), // splash color
                          onTap: () {
                            secureStore.delete("PIN");
                            Navigator.pop(context);
                          }, // button pressed
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: SizedBox(width: 100, height: 50, child: Image.asset("images/logo_big.png")),
          ),
        ),
      ),
    ]);
  }

  void _checkSetupPIN() async {
    int first = int.parse(_tempPIN.map((i) => i.toString()).join(""));
    int second = int.parse(_tempPIN2.map((i) => i.toString()).join(""));
    var succ = false;
    if (first == second) {
      succ = true;
      await secureStore.write("PIN", first.toString());
    } else {
      await secureStore.delete("PIN");
    }
    if (context.mounted) Navigator.of(context).pop(succ);
  }
}
