import 'package:flutter/material.dart';
import '../qr_scanner.dart';

class ScannersPage extends StatefulWidget {
  final String userType;
  final String userId;
  String response = '';
  ScannersPage(this.userType, this.userId);

  @override
  State<StatefulWidget> createState() =>
      _ScannersPageState(this.userType, this.userId);
}

class _ScannersPageState extends State<ScannersPage> {
  final String userType;
  final String userId;
  String response = '';
  _ScannersPageState(this.userType, this.userId);
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
                onTap: () async {
                  response = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        QRViewExample(this.userType, this.userId),
                  ));
                  setState(() {});
                }),
            Container(
              child: Text(response),
            )
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
