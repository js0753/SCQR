import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class HttpService {
  static Future<void> FunctionInvoke(String func, List args) async {
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTMzMjc1ODYsInVzZXJuYW1lIjoiZXJlbiIsIm9yZ05hbWUiOiJPcmcxIiwiaWF0IjoxNjUzMjkxNTg2fQ.fXA6bO24lZevFh9BROXV3b3UO-onLt9bjLAEvXN1afg";
    var ApiLink = "https://7af02e298a4be2.lhrtunnel.link";
    String chaincode = '/channels/mychannel/chaincodes/fabcar';
    if (func == 'query') {
      String url = ApiLink +
          chaincode +
          "?args=" +
          "[\"" +
          args[0] +
          "\"]" +
          "&peer=peer0.org1.example.com&fcn=query";
      print(url);
      Response res = await get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print(body.toString());
      } else {
        throw res.body;
      }
    } else {
      String url = ApiLink + chaincode;
      Map<String, dynamic> body = {
        'fcn': func,
        'peers': ["peer0.org1.example.com", "peer0.org2.example.com"],
        'chaincodeName': "fabcar",
        'channelName': "mychannel",
        'args': args
      };
      print(url);
      Response res = await post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(body));

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print(body.toString());
      } else {
        throw "Error in getting response";
      }
    }
  }
}
