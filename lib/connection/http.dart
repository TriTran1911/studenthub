import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final String url_b =
    Platform.isAndroid ? "http://10.0.2.2:4400" : "http://localhost:4400";

class Connection {
  static Future<dynamic> postRequest(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.post(
      Uri.parse(url_b + url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return response.body;
  }

  static Future<dynamic> getRequest(String api, Map<String, dynamic> json) async {
    var url = Uri.parse(url_b + api);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var _headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      print("Connect server successful");
      return response.body;
    } else {
      print("Connect server failed");
      return response.body;
    }
  }

  static Future<dynamic> putRequest(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return response.body;
  }

  static Future<dynamic> deleteRequest(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.delete(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response.body;
  }

  static Future<dynamic> patchRequest(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return response.body;
  }
}
