import 'package:http/http.dart';
import 'dart:convert';

class HttpService {
  static Future<void> FunctionInvoke(String func, List args) async {
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTMyODYxODMsInVzZXJuYW1lIjoiZXJlbjIiLCJvcmdOYW1lIjoiT3JnMSIsImlhdCI6MTY1MzI1MDE4M30.OYAKCG3nijO3Q8WKuXBtkY-57-bdXpJegjtrK0FbcJU";
    var ApiLink = "https://ae1f208d448905.lhrtunnel.link";
    String chaincode = '/channels/mychannel/chaincodes/fabcar';
    String argsString = "[";
    for (int i = 0; i < args.length - 1; i++) {
      argsString += '\"' + args[i] + '\",';
    }
    argsString += "\"" + args[args.length - 1] + "\"]";
    String url = ApiLink + chaincode;
    Map<String, String> body = {
      'fcn': func,
      'peers': "peer0.org1.example.com",
      'chaincodeName': "fabcar",
      'channelName': "mychannel",
      'args': args.toString()
    };
    print(url);
    Response res = await post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: body);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      print(body.toString());
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}
