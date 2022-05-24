import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class HttpService {
  static Future<String> FunctionInvoke(String func, List args) async {
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTM0NTgxNTIsInVzZXJuYW1lIjoic2NxcjEiLCJvcmdOYW1lIjoiT3JnMSIsImlhdCI6MTY1MzQyMjE1Mn0.vnVwNvlyVsiWys7COFM7aLHJYwjA04AXqEhREBo7q8o";

    var ApiLink = "https://86f2da4f9087ff.lhrtunnel.link";
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
