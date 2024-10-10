import 'dart:async';

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

class QScanWidgetState extends State<QScanWidget> with WidgetsBindingObserver {
  Barcode? result;
  StreamSubscription<BarcodeCapture>? _subscription;

  // QRViewController? controller;controller
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final MobileScannerController cameraController;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cameraController = MobileScannerController(
        returnImage: false, detectionSpeed: DetectionSpeed.normal, formats: [BarcodeFormat.all]);
    _subscription = cameraController.barcodes.listen(_handleBarcode);
    unawaited(cameraController.start());
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
            icon: cameraController.torchEnabled
                ? const Icon(Icons.flash_off, color: Colors.white54)
                : const Icon(Icons.flash_on, color: Colors.white),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: cameraController.facing == CameraFacing.back
                ? Icon(Icons.flip_camera_android_sharp, color: Colors.white.withOpacity(0.9))
                : Icon(Icons.flip_camera_android_sharp, color: Colors.white.withOpacity(0.9)),
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!cameraController.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = cameraController.barcodes.listen(_handleBarcode);

        unawaited(cameraController.start());
        break;
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(cameraController.stop());
        break;
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await cameraController.dispose();
  }

  void _handleBarcode(BarcodeCapture event) {
    if (event.barcodes.isEmpty) {
      debugPrint('Failed to scan Barcode');
    } else {
      debugPrint('Succ to scan Barcode');
      final List<Barcode> barcodes = event.barcodes;
      final String code = barcodes[0].rawValue!;
      widget.scanResult(code);
      cameraController.stop();
      cameraController.dispose();
      Navigator.maybePop(context);
      debugPrint('Barcode found! $code');
    }
  }
}
