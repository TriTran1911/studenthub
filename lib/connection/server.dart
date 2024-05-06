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
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Connect server successful");
      return response.body;
    } else {
      print("Connect server failed");
      return response.body;
    }
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

  static Future<dynamic> putRequest(String api, dynamic object) async {
    var url = Uri.parse(url_b + api);
    var payload = json.encode(object);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.put(url, headers: headers, body: payload);
    if (response.statusCode == 200) {
      print("Connect server successful");
      return response.body;
    } else {
      print("Connect server failed");
      return response.body;
      //throw exception and catch it in UI
    }
  }

  static Future<void> putLanguage(int studentId, List<Language> languageList) async {
    print('Put Language');
    String url = '/api/language/updateByStudentId/$studentId';
    try {
      var data = {
        "languages": languageList
            .map((language) => {
                  "id": null,
                  "languageName": language.languageName,
                  "level": language.level,
                })
            .toList(),
      };
      var response = await putRequest(url, data);
      var responseDecode = jsonDecode(response);
      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print("Connect server successful");
        print(response);
        // Call a method to reload the page
      } else {
        print("Failed");
        print(responseDecode);
      }
    } catch (e) {
      print(e);
    }
  }
}
