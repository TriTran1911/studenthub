import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final String url_b = Platform.isAndroid ? "http://10.0.2.2:4400" : "http://localhost:4400";

// POST
Future<dynamic> postRequest(String url, dynamic body) async {
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

// GET
Future<dynamic> getRequest(String url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  var response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });
  return response.body;
}

// PUT
Future<dynamic> putRequest(String url, dynamic body) async {
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

// DELETE
Future<dynamic> deleteRequest(String url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  var response = await http.delete(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });
  return response.body;
}

// PATCH
Future<dynamic> patchRequest(String url, dynamic body) async {
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
