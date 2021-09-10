import 'dart:convert';
import 'dart:io';

import 'package:afkcredits/ui/shared/colors/color_settings.dart';
import 'package:afkcredits/ui/views/qrcode/qrcode_viewmodel.dart';
import 'package:afkcredits/ui/widgets/layouts/tabbar_layout.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';

class QRCodeViewMobile extends StatelessWidget {
  final int initialIndex;
  const QRCodeViewMobile({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QRCodeViewModel>.reactive(
      viewModelBuilder: () => QRCodeViewModel(),
      builder: (context, model, child) => TabBarLayout(
          initialIndex: initialIndex,
          title: "QR Code",
          titleTrailingWidget: IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                //Still Action To be Performed
              }),
          tabs: [
            SizedBox(
              width: screenWidth(context) * 0.4,
              child: Tab(text: "Scan"),
            ),
            SizedBox(
              width: screenWidth(context) * 0.4,
              child: Tab(text: "Get paid"),
            ),
          ],
          views: [
            ScanQRCode(
              analyzeScanResult: model.analyzeScanResult,
            ),
            // MyQRCode(userInfo: model.getUserInfo()),
          ]),
    );
  }
}

class ScanQRCode extends StatefulWidget {
  final Future Function({required Barcode result}) analyzeScanResult;

  const ScanQRCode({Key? key, required this.analyzeScanResult})
      : super(key: key);

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;

  void toggleFlash() {
    isFlashOn = !isFlashOn;
    setState(() {});
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          verticalSpaceRegular,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            clipBehavior: Clip.hardEdge,
            height: screenHeightPercentage(context, percentage: 0.7),
            width: screenWidth(context),
            child: _buildQrView(context),
            // SizedBox.expand(
            //     child: Image.asset(ImageIconPaths.qrcodeScanning)),
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
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
                borderColor: ColorSettings.primaryColor,
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
            child: Text("Scan a Good Wallet QR Code",
                style: textTheme(context).bodyText1),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
              onPressed: toggleFlash,
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
    controller.scannedDataStream.listen((scanData) async {
      // analyzes scanned result and navigates to new
      // screen if qr code scan was successfull
      await widget.analyzeScanResult(result: scanData);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class MyQRCode extends StatelessWidget {
  final String userInfo;
  const MyQRCode({Key? key, required this.userInfo}) : super(key: key);

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(90.0),
          child: Image.network(
            "ImagePath.profilePicURL",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        verticalSpaceLarge,
        _buildProfileImage(),
        verticalSpaceSmall,
        Center(
          child: Text(
            jsonDecode(userInfo)["name"],
            style: textTheme(context).headline6,
          ),
        ),
        verticalSpaceMediumLarge,
        Center(
          child: Container(
            height: 250,
            width: 250,
            child: QrImage(
              data: userInfo,
            ),
          ),
        ),
        verticalSpaceMedium,
        Center(
          child: Container(
            height: 250,
            width: 250,
            child: Text(
              "Have your friend scan this QR code to transfer money to you",
            ),
          ),
        ),
      ],
    );
  }
}
