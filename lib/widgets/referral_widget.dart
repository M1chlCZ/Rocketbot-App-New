import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/support/auto_size_text_field.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/qr_code_scanner.dart';

class ReferralWidget extends StatefulWidget {
  final Function(String) refCode;

  const ReferralWidget({Key? key, required this.refCode}) : super(key: key);

  @override
  State<ReferralWidget> createState() => ReferralWidgetState();
}

class ReferralWidgetState extends State<ReferralWidget> {
  bool referralCode = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.text.length == 32) {
        widget.refCode(controller.text);
        setState(() {
          referralCode = true;
        });
      }
    });
  }

  void clearText() {
    controller.clear();
    setState(() {
      referralCode = false;
    });
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
          if (mounted) {
            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
              return QScanWidget(
                header: 'Scan referral QR code',
                scanResult: (String s) {
                  controller.text = s;
                },
              );
            }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(opacity: animation, child: child);
            }));
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return QScanWidget(
              header: 'Scan referral QR code',
              scanResult: (String s) {
                controller.text = s;
              },
            );
          }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          }));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      width: 300,
      height: 50,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Visibility(
            visible: referralCode ? false : true,
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeTextField(
                    controller: controller,
                    maxLines: 1,
                    minFontSize: 4.0,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white70),
                    decoration: InputDecoration(
                      hintText: "Referral code",
                      hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white54, fontSize: 14.0),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Container(
                    width: 1,
                    height: double.infinity,
                    color: Colors.white10,
                  ),
                ),
                NeuButton(
                  width: 50.0,
                  height: 50.0,
                  gradient: const LinearGradient(colors: [
                    Color(0xFFF05523),
                    Color(0xFF812D88),
                  ]),
                  onTap: () {
                    _openQRScanner();
                  },
                  icon: const Icon(
                    Icons.qr_code_2,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: referralCode ? true : false,
            child: GradientText(
              'Referral code added',
              gradient: const LinearGradient(colors: [
                Color(0xFFF05523),
                Color(0xFF812D88),
              ]),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}
