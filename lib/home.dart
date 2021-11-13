import 'package:flutter/material.dart';
import 'package:scqr/farmerForm.dart';
import 'qr_scanner.dart';
import 'qr_module.dart';
class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           HomeButton(text:"Add Farmer", onTap:(){
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FarmerForm(),
              ));
              }),
          HomeButton(text:"Scan QR Code", onTap:(){
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QRViewExample(),
              ));
              }),
          HomeButton(text: "Generate QR Code", onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QRGenerator(),
              ));
          }
              )

        ],
      ),
    );
  }
}


class HomeButton extends StatelessWidget {
  String text;
  var onTap;
  HomeButton({required this.text,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(25),
            color: Colors.black,
            child: InkWell(
              child: Text(text,style: TextStyle(color: Colors.white),),
              onTap: this.onTap,
            ),
          );
  }
}