import 'dart:ui';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scqr/firebase_storage_module.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({Key? key}) : super(key: key);

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  static Widget qrcImage=Container();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top:40,left:25,right:25),
        child: Column(
          children: [
          DataForm(changeState: (){setState(() {
            print("Set State called");
           });},),
          qrcImage,
        ]),
      ),
    );
  }
}

Future<Uint8List> GetQRImage(List dataList) async{
  String dataString = "";
  for (int i = 0; i < dataList.length; i++) {
    dataString += dataList[i];
    if (i == dataList.length - 1) break;
    dataString += ";";
  }


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
            controller: locController,
            decoration: InputDecoration(
              hintText: 'Location',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          Container(
                        margin: EdgeInsets.only(top:87,right: 55,bottom: 63,left: 38),
                        width: 282,
                        height:40,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius:BorderRadius.all(Radius.circular(10)),
                        ),
                        
                        child: MaterialButton(
                          child: Text(
                            'Generate Code',
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                          elevation: 4,
                          onPressed: () async{
                            List dataList=[idController.text,prodController.text,costController.text,itnoController.text,locController.text];
                            var qri=await GetQRImage(dataList);
                            Image qrcImage= Image.memory(qri);
                            _QRGeneratorState.qrcImage=qrcImage;
                            uploadFile(qri);
                            this.changeState();
                          },//validateForm,
                        ),
                      ),
        ],
      ),
    );
  }
}

// List GetDataFromQR(QrImage qrcode){

// }

