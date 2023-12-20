
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rocketbot/support/barcode_overlay.dart';

class QScanWidget extends StatefulWidget {
  final Function(String) scanResult;
  final String? header;

  const QScanWidget({super.key, required this.scanResult, this.header});

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
    cameraController = MobileScannerController(returnImage: false,
        detectionSpeed: DetectionSpeed.normal, formats: [BarcodeFormat.all]);
    cameraController?.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white70),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget.header ?? 'Scan QR code',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white70),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController!.torchState,
              builder: (context, state, child) {
                switch (state) {
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
                switch (state) {
                  case CameraFacing.front:
                    return Icon(
                      Icons.flip_camera_android_sharp,
                      color: Colors.white.withOpacity(0.9),
                    );
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
                controller: cameraController,
                onDetect: (capture) {
                  if (capture.barcodes.isEmpty) {
                    debugPrint('Failed to scan Barcode');
                  } else {
                    debugPrint('Succ to scan Barcode');
                    final List<Barcode> barcodes = capture.barcodes;
                    final String code = barcodes[0].rawValue!;
                    widget.scanResult(code);
                    cameraController!.stop();
                    cameraController!.dispose();
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
