import 'dart:io';
import 'package:afkcredits/ui/views/qrcode/qrcode_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';

class QRCodeView extends StatelessWidget {
  final String? qrCodeString;
  const QRCodeView({Key? key, this.qrCodeString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QRCodeViewModel>.reactive(
      viewModelBuilder: () => QRCodeViewModel(),
      builder: (context, model, child) => Scaffold(
        body: qrCodeString == null
            ? ScanQRCode(
                analyzeScanResult: model.analyzeScanResult,
                onBackPressed: model.popQrCodeView,
              )
            : ShowQRCode(
                qrCodeString: qrCodeString!,
                onBackPressed: model.navigateBack,
              ),
      ),
      // MyQRCode(userInfo: model.getUserInfo()),
    );
  }
}

class ScanQRCode extends StatefulWidget {
  final Future Function({required Barcode result}) analyzeScanResult;
  final void Function() onBackPressed;

  const ScanQRCode(
      {Key? key, required this.analyzeScanResult, required this.onBackPressed})
      : super(key: key);

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;

  void toggleFlash() async {
    await controller?.toggleFlash();
    isFlashOn = !isFlashOn;
    setState(() {});
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (!kIsWeb && Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              //clipBehavior: Clip.hardEdge,
              //height: screenHeightPercentage(context, percentage: 0.7),
              width: screenWidth(context),
              child: _buildQrView(context, widget.onBackPressed),
              // SizedBox.expand(
              //     child: Image.asset(ImageIconPaths.qrcodeScanning)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context, void Function() onBackPressed) {
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: kcPrimaryColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250),
          ),
        ),
        Align(
          alignment: Alignment(0.0, 0.7),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Scan an AFK Credits QR Code",
                style: textTheme(context)
                    .headline6!
                    .copyWith(color: Colors.white)),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: isFlashOn
                  ? Icon(Icons.flash_on, size: 24, color: Colors.white)
                  : Icon(Icons.flash_off, size: 24, color: Colors.white),
              onPressed: toggleFlash,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
              onPressed: onBackPressed,
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (scanData) async {
        // analyzes scanned result and navigates to new
        // screen if qr code scan was successfull
        await widget.analyzeScanResult(result: scanData);
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ShowQRCode extends StatelessWidget {
  final String qrCodeString;
  final void Function() onBackPressed;
  const ShowQRCode(
      {Key? key, required this.qrCodeString, required this.onBackPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 24, color: Colors.black),
            onPressed: onBackPressed,
          ),
        ),
        verticalSpaceLarge,
        Align(
          child: Container(
              width: screenWidth(context, percentage: 0.7),
              height: 100.0,
              child: Text(qrCodeString)),
        ),
        verticalSpaceMedium,
        Center(
          child: Container(
            height: 250,
            width: 250,
            child: QrImage(
              data: qrCodeString,
            ),
          ),
        ),
        verticalSpaceMedium,
      ],
    );
  }
}
