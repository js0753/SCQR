import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class HttpService {
  static Future<String> FunctionInvoke(String func, List args) async {
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTMzNjE1MDIsInVzZXJuYW1lIjoiZXJlbiIsIm9yZ05hbWUiOiJPcmcxIiwiaWF0IjoxNjUzMzI1NTAyfQ.-khVVatA-ubZlwRY-Q1_Zdxe-gaqgnxnpPcHBqH26wk";
    var ApiLink = "https://c2e9e39b4a59be.lhrtunnel.link";
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
        return body.toString();
      } else {
        return "Error";
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
        return body.toString();
      } else {
        return "Error";
      }
    }
  }
}
