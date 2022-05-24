import 'dart:ui';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
      backgroundColor: Color.fromARGB(190, 15, 4, 89),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Column(children: [
            DataForm(
              changeState: () {
                setState(() {
                  print("Set State called");
                });
              },
            ),
            Container(
              child: qrcImage,
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
            ),
            SizedBox(
              height: 100,
            )
          ]),
        ),
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
          SizedBox(
            height: 50,
          ),
          Text("New Produce Entry",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontFamily: "roboto",
              )),
          SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: idController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Farmer ID ",
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
              hintStyle: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          TextFormField(
            controller: prodController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Product ",
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
              hintStyle: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          TextFormField(
            controller: costController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Cost per Item",
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
              hintStyle: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          TextFormField(
            controller: itnoController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Quantity",
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
              hintStyle: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          TextFormField(
            controller: gradeController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Grade",
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
              hintStyle: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 87, right: 55, bottom: 63, left: 38),
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: MaterialButton(
              child: Text(
                'Generate Code',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(190, 15, 4, 89)),
              ),
              elevation: 4,
              onPressed: () async {
                //Get Location first
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

                // Append all fields together along with date and location _____
                var bytes = utf8.encode(dataString);
                var digest = sha256.convert(bytes).toString();
                print(digest);

                // Generate QR Code _____________________________
                var qri = await GetQRImage(digest);
                Image qrcImage = Image.memory(qri);
                _APMCCollectorPageState.qrcImage = qrcImage;
                // uploadFile(qri);

                // Saved Image to Gallery ____________________
                final snackBar = SnackBar(
                  backgroundColor: Colors.white,
                  content: const Text(
                    'Saved code to gallery!',
                    style: TextStyle(color: Color.fromARGB(255, 15, 4, 89)),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Send transaction request to API
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
