import 'package:flutter/material.dart';

// import 'firestore_module.dart';

class ScannedData extends StatelessWidget {
  // List dataList=[];
  String data;
  ScannedData(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(60),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Scanned Data : \n",
            style: TextStyle(fontSize: 25),
          ),
          Text(this.data),
          // Text("Farmer ID : " + this.dataList[0]),
          // Text("Product : " + this.dataList[1]),
          // Text("Cost per Item : " + this.dataList[2]),
          // Text("Items per box : " + this.dataList[3]),
          // Text("Location : " + this.dataList[4]),
        ]),
      ),
    );
  }
}
