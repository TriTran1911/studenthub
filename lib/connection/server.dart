import 'dart:convert';
import 'package:flutter/material.dart';
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
    var jsonBody = json.encode(object);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.put(url, headers: headers, body: jsonBody);
    var responseJson = json.decode(response.body);
    if (responseJson != null) {
      print("PUT request successful");
      return response.body;
    } else {
      print("PUT request failed with status: ${response.statusCode}");
      return response.body;
    }
  }

  static Future<dynamic> patchRequest(String api, dynamic object) async {
    var url = Uri.parse(url_b + api);
    var jsonBody = json.encode(object);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.patch(url, headers: headers, body: jsonBody);
    var responseJson = json.decode(response.body);
    if (responseJson != null) {
      print("Patch request successful");
      return response.body;
    } else {
      print("Patch request failed with status: ${response.statusCode}");
      return response.body;
    }
  }

  static Future<void> deleteRequest(String api) async {
    var url = Uri.parse(url_b + api);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    var response = await http.delete(url, headers: headers);
    var responseJson = json.decode(response.body);
    if (responseJson != null) {
      print("Delete request successful");
    } else {
      print("Delete request failed with status: ${response.statusCode}");
    }
  }

  Future<bool> setFavorite(int projectId, int disableFlag, BuildContext context) async {
    int? studentId = modelController.user.id;
    String url = '/api/favoriteProject/$studentId';
    try {
      var object = {'projectId': projectId, 'disableFlag': disableFlag};
      var response = await Connection.patchRequest(url, object);
      var responseDecode = jsonDecode(response);
      if (responseDecode != null) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to set favorite project."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to set favorite project."),
        ),
      );
    }
    return false;
  }
}