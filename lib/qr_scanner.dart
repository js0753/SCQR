import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scqr/httpService.dart';
import 'package:scqr/users/scanners.dart';

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

  void pauseCam(String data, String userId, BuildContext context) async {
    await controller!.pauseCamera();
    // addQrScan(dataList);
    String response = '';
    if (userType == "Manufacturer")
      response = await HttpService.FunctionInvoke(
          'manufactureProcessing', [data, userId]);
    else if (userType == "Wholesaler")
      response = await HttpService.FunctionInvoke(
          'wholesalerDistribute', [data, userId]);
    else if (userType == "Shipping")
      response =
          await HttpService.FunctionInvoke('initiateShipment', [data, userId]);
    else if (userType == "Retailer")
      response =
          await HttpService.FunctionInvoke('deliverToRetail', [data, userId]);
    else if (userType == "Vendor")
      response =
          await HttpService.FunctionInvoke('completeOrder', [data, userId]);
    else
      response = await HttpService.FunctionInvoke('query', [data]);
    Navigator.pop(context, response);
  }

  @override
  Widget build(BuildContext context) {
    if (result != null) {
      pauseCam(result!.code ?? '', this.userId, context);
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
            child: Container(
              color: Color.fromARGB(255, 15, 4, 89),
              child: Center(
                child: (result != null)
                    ? Text(
                        'Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: "roboto",
                        ))
                    : Text('Please Scan A QR Code',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontFamily: "roboto",
                        )),
              ),
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
