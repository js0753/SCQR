import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'firestore_module.dart';
import 'scannedData.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
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

  void pauseCam(dataList) async{
    await controller!.pauseCamera();
    addQrScan(dataList);
    
  }
  @override
  Widget build(BuildContext context) {
    if (result!=null){
      List dataList=(result!.code)!.split(';');
      pauseCam(dataList);
      return ScannedData(dataList); 
      
              
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child:_buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? 
                  Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildQrView(BuildContext context){
var scanArea= (MediaQuery.of(context).size.width<400||MediaQuery.of(context).size.width<400)?150.0:300.0;
return QRView(
  key:qrKey,
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