import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestHelper {
  //Get http reqeust from the Web
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'Connection Failed';
      }
    } catch (e) {
      return 'Connection Failed';
    }
  }
}
