import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scqr/httpService.dart';
import 'scannedData.dart';

class QRViewExample extends StatefulWidget {
  final String userType;
  final String userId;
  const QRViewExample(this.userType, this.userId);

  @override
  State<StatefulWidget> createState() =>
      _QRViewExampleState(this.userType, this.userId);
}

class _QRViewExampleState extends State<QRViewExample> {
  final String userType;
  final String userId;
  _QRViewExampleState(this.userType, this.userId);
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void pauseCam(String data, String userId) async {
    await controller!.pauseCamera();
    // addQrScan(dataList);
    if (userType == "Manufacturer")
      HttpService.FunctionInvoke('manufactureProcessing', [data, userId]);
    else if (userType == "Wholesaler")
      HttpService.FunctionInvoke('wholesalerDistribute', [data, userId]);
    else if (userType == "Shipping")
      HttpService.FunctionInvoke('initiateShipment', [data, userId]);
    else if (userType == "Retailer")
      HttpService.FunctionInvoke('deliverToRetail', [data, userId]);
    else if (userType == "Vendor")
      HttpService.FunctionInvoke('completeOrder', [data, userId]);
    else
      HttpService.FunctionInvoke('query', [data]);
  }

  @override
  Widget build(BuildContext context) {
    if (result != null) {
      pauseCam(result!.code ?? '', this.userId);
      // return ScannedData(dataList);
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.width < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 50,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
