import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future getRequest(String url) async {
  final _headers = {
    "Authorization":"Client-ID ngvWxSzyIg2rUvcpjK0gljbcEZ56KfxLSHTdcNDqTgw"
  };

  final response = await http.get(
    Uri.parse(url),
    headers: _headers,
  );
  log("response Code >> ${response.statusCode}");
  log("response >> ${response.body}");

  if (response.statusCode != 200) {
    throw 'Server Error. Status Code:${response.statusCode}';
  }
  var resBody = response.body;
  return json.decode(resBody);
}

