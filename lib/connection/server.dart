import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/components/modelController.dart';

const String url_b = "https://api.studenthub.dev";

class Connection {
  static Future<dynamic> postRequest(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.post(
      Uri.parse(url_b + url),
      headers: <String, String>{
        'accept': '*/*', // 'application/json
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Post request successful");
      return response.body;
    } else {
      print("Post request failed");
      return response.body;
    }
  }

  static Future<dynamic> getRequest(
      String api, Map<String, dynamic> json) async {
    var url = Uri.parse(url_b + api);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var _headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      print("Get request successful");
      return response.body;
    } else {
      print("Get request failed");
      return response.body;
    }
  }

  static Future<dynamic> putRequest(String api, dynamic object) async {
    var url = Uri.parse(url_b + api);
    String jsonBody = jsonEncode(object, toEncodable: myJsonEncode);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.put(url, headers: headers, body: jsonBody);
    if (response.statusCode == 200) {
      print("PUT request successful");
      return response.body;
    } else {
      print("PUT request failed with status: ${response.statusCode}");
      return response.body;
    }
  }
}

dynamic myJsonEncode(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item.toJson();
}