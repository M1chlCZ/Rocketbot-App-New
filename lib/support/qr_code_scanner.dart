import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rocketbot/support/barcode_overlay.dart';

class QScanWidget extends StatefulWidget {
  final Function(String) scanResult;
  const QScanWidget({Key? key, required this.scanResult}) : super(key: key);

  @override
  QScanWidgetState createState() => QScanWidgetState();
}

class QScanWidgetState extends State<QScanWidget> {
  Barcode? result;
  // QRViewController? controller;controller
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? cameraController;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    cameraController?.start();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white70),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text('Scan QR code', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white70),),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController!.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white54);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.white);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController!.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController!.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return Icon(Icons.flip_camera_android_sharp, color: Colors.white.withOpacity(0.9),);
                  case CameraFacing.back:
                    return Icon(Icons.flip_camera_android_sharp, color: Colors.white.withOpacity(0.9));
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController!.switchCamera(),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF2f2b5e),
        child: Stack(
          children: [
            MobileScanner(
                allowDuplicates: false,
                controller: cameraController,
                onDetect: (barcode, args) {
                  if (barcode.rawValue == null) {
                    debugPrint('Failed to scan Barcode');
                  } else {
                    final String code = barcode.rawValue!;
                    widget.scanResult(code);
                    cameraController!.stop();
                    Navigator.maybePop(context);
                    debugPrint('Barcode found! $code');
                  }
                }),
            Container(
              decoration: ShapeDecoration(
                  shape: BarcodeOverlay(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 5,
                  )),
            ),
            // Column(
            //   children: <Widget>[
            //     Expanded(flex: 7, child: _buildQrView(context)),
            //     Expanded(
            //       flex: 1,
            //       child: FittedBox(
            //         fit: BoxFit.contain,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: <Widget>[
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: <Widget>[
            //                 Container(
            //                   margin: const EdgeInsets.all(8),
            //                   child: ElevatedButton(
            //                       onPressed: () async {
            //                         await controller?.toggleFlash();
            //                         setState(() {});
            //                       },
            //                       child: FutureBuilder(
            //                         future: controller?.getFlashStatus(),
            //                         builder: (context, snapshot) {
            //                           return Text('Flash: ${snapshot.data == true ? 'ON' : 'OFF'}');
            //                         },
            //                       )),
            //                 ),
            //                 Container(
            //                   margin: const EdgeInsets.all(8),
            //                   child: ElevatedButton(
            //                       onPressed: () async {
            //                         await controller?.flipCamera();
            //                         setState(() {});
            //                       },
            //                       child: FutureBuilder(
            //                         future: controller?.getCameraInfo(),
            //                         builder: (context, snapshot) {
            //                           if (snapshot.data != null) {
            //                             return Text(
            //                               describeEnum(snapshot.data!) == 'front' ? 'Back Camera' : 'Front Camera'
            //                             );
            //                           } else {
            //                             return const Text('loading');
            //                           }
            //                         },
            //                       )),
            //                 )
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // const CardHeader(title: '', backArrow: true,),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}

