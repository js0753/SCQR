import 'dart:ui';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../httpService.dart';

class APMCCollectorPage extends StatefulWidget {
  const APMCCollectorPage({Key? key}) : super(key: key);

  @override
  _APMCCollectorPageState createState() => _APMCCollectorPageState();
}

class _APMCCollectorPageState extends State<APMCCollectorPage> {
  static Widget qrcImage = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Column(children: [
          DataForm(
            changeState: () {
              setState(() {
                print("Set State called");
              });
            },
          ),
          qrcImage,
        ]),
      ),
    );
  }
}

Future<Uint8List> GetQRImage(String dataString) async {
  // String dataString = "";
  // for (int i = 0; i < dataList.length; i++) {
  //   dataString += dataList[i];
  //   if (i == dataList.length - 1) break;
  //   dataString += ";";
  // }

  try {
    final image = await QrPainter(
      data: dataString,
      version: QrVersions.auto,
      gapless: false,
    ).toImage(300);
    final a = await image.toByteData(format: ImageByteFormat.png);
    return a!.buffer.asUint8List();
  } catch (e) {
    throw e;
  }
}

class DataForm extends StatefulWidget {
  var changeState;
  //DataForm({Key? key,required this.changeState}) : super(key: key);
  DataForm({this.changeState});
  @override
  DataFormState createState() {
    return DataFormState(changeState: this.changeState);
  }
}

class DataFormState extends State<DataForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<DataFormState>.
  var changeState;

  DataFormState({this.changeState});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = new TextEditingController();
  final TextEditingController prodController = new TextEditingController();
  final TextEditingController costController = new TextEditingController();
  final TextEditingController itnoController = new TextEditingController();
  final TextEditingController locController = new TextEditingController();
  final TextEditingController gradeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          TextFormField(
            controller: idController,
            decoration: InputDecoration(
              hintText: 'Farmer ID',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          TextFormField(
            controller: prodController,
            decoration: InputDecoration(
              hintText: 'Product',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          TextFormField(
            controller: costController,
            decoration: InputDecoration(
              hintText: 'Cost Per Item',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          TextFormField(
            controller: itnoController,
            decoration: InputDecoration(
              hintText: 'No of Items per box',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          TextFormField(
            controller: gradeController,
            decoration: InputDecoration(
              hintText: 'Grade',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 87, right: 55, bottom: 63, left: 38),
            width: 282,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: MaterialButton(
              child: Text(
                'Generate Code',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              elevation: 4,
              onPressed: () async {
                //add loading overlay
                // Position _currentPosition = await _determinePosition();
                print("Got location");
                var dataString = idController.text +
                    prodController.text +
                    costController.text +
                    itnoController.text +
                    gradeController.text +
                    // _currentPosition.latitude.toString() +
                    // _currentPosition.longitude.toString() +
                    DateTime.now().toString();
                var bytes = utf8.encode(dataString);
                var digest = sha256.convert(bytes).toString();
                print(digest);
                var qri = await GetQRImage(digest);
                Image qrcImage = Image.memory(qri);
                _APMCCollectorPageState.qrcImage = qrcImage;
                // uploadFile(qri);
                HttpService.FunctionInvoke('createRawFood', [
                  digest,
                  idController.text,
                  costController.text,
                  itnoController.text,
                  prodController.text,
                  gradeController.text
                ]);
                this.changeState();
              }, //validateForm,
            ),
          ),
        ],
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  print("Trying to determine position");
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  print("all permissions granted");
  return await Geolocator.getCurrentPosition();
}

// List GetDataFromQR(QrImage qrcode){

// }
