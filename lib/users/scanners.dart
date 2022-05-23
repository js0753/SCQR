import 'package:flutter/material.dart';
import '../qr_scanner.dart';

class ScannersPage extends StatelessWidget {
  final String userType;
  final String userId;
  const ScannersPage(this.userType, this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeButton(
                text: "Scan QR Code",
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        QRViewExample(this.userType, this.userId),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  String text;
  var onTap;
  HomeButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      color: Colors.black,
      child: InkWell(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onTap: this.onTap,
      ),
    );
  }
}
