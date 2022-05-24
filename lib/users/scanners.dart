import 'package:flutter/material.dart';
import '../qr_scanner.dart';
import 'dart:convert';

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
  var stages = {
    'Manufacturer': 'Manufacturing',
    'Wholesaler': 'Wholesaler',
    'Retailer': 'Retailer',
    'Shipping': 'Shipment',
    'Vendor': 'Vendor Shop'
  };
  String response = 'null';
  String myresponse = "null";
  _ScannersPageState(this.userType, this.userId);
  // [orderId, farmerId, rawD, manuId, manuD, wholeId, wholeD, retailId, retailD, logId, shipD, status, name, grade, price,lat,long]
  var food = [
    "abcfh36vsjn",
    "hemant12",
    "2022-05-24",
    "manu34",
    "2022-05-24",
    "whole12",
    "2022-05-24",
    "retail34",
    "2022-05-24",
    "sarh13",
    "2022-05-24",
    "Wholesaler",
    "Apples",
    "A grade",
    "2340",
    "23N",
    "78S"
  ];
  var orderId = "new";
  _refreshData(String res) {
    setState(() {
      myresponse = response;
      var arr = myresponse.split(",");
      orderId = "changed";
      if (arr.length == 20) {
        food = [
          arr[0].split(":")[1],
          arr[2].split(":")[1],
          arr[8].split(":")[1],
          arr[3].split(":")[1],
          arr[9].split(":")[1],
          arr[4].split(":")[1],
          arr[10].split(":")[1],
          arr[5].split(":")[1],
          arr[12].split(":")[1],
          arr[6].split(":")[1],
          arr[11].split(":")[1],
          arr[7].split(":")[1],
          arr[13].split(":")[1],
          arr[14].split(":")[1],
          arr[15].split(":")[1],
          arr[18].split(":")[1],
          arr[19].split(":")[1]
        ];
        print(food.length);
        print(food);
      }
    });
  }

  @override
  void initState() {
    String myresponse = 'null';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 4, 89),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text("Scan Package Code",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: "roboto",
                  )),
              Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/finalLogo.PNG'),
                        fit: BoxFit.fill)),
              ),
              myresponse == "null"
                  ? Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: userType == "Guest" ||
                              userType == "Admin" ||
                              userType == "APMCCollector"
                          ? Text(
                              "Scan QR to get live tracking information of the produce ",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Welcome $userType! \n Scan the QR code to confirm it has reached ${stages[userType]} ",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      width: double.maxFinite,
                      child: userType == "Guest" ||
                              userType == "Admin" ||
                              userType == "APMCCollector"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Text(
                                    "Package Details:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Text(
                                      "Order ID : ${food[0]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(190, 15, 4, 89)),
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status: ${food[11]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Name: ${food[12]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Grade: ${food[13]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Price: ${food[14]} /-",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Farmer Id : ${food[1]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Latitude: ${food[15]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Longitude: ${food[16]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Manufactor Id : ${food[3]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Date: ${food[4]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Wholesaler Id : ${food[5]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Date: ${food[6]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Retailer Id : ${food[7]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Date: ${food[8]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Logistic Id : ${food[9]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        ),
                                        Text(
                                          "Date: ${food[10]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  190, 15, 4, 89)),
                                        )
                                      ],
                                    )),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                " Successfully updated in the Supply Chain ! ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(190, 15, 4, 89)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
              Container(
                width: 200,
                height: 70,
                margin: EdgeInsets.fromLTRB(20, 50, 20, 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: MaterialButton(
                    child: Text(
                      "Scan QR ",
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 15, 4, 89)),
                    ),
                    elevation: 4,
                    onPressed: () async {
                      response =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            QRViewExample(this.userType, this.userId),
                      ));
                      _refreshData(response);
                      print("____________________________________");
                      print("| Response: $myresponse");
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
