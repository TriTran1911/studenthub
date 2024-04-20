import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/components/appbar.dart';
import '/screens/HomePage/tabs.dart';
import '/components/controller.dart';
import '/connection/http.dart';

class ProjectPost4 extends StatefulWidget {
  final String title;
  final List<String> descriptionLines; // Changed type to List<String>
  final int selectedDuration;
  final int numberOfStudents;

  ProjectPost4({
    required this.title,
    required this.descriptionLines,
    required this.selectedDuration,
    required this.numberOfStudents,
  });

  @override
  _ProjectPost4State createState() => _ProjectPost4State();
}

class _ProjectPost4State extends State<ProjectPost4> {
  @override
  Widget build(BuildContext context) {
    // Convert list to string

    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildPadding(context),
    );
  }

  Padding _buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _Text('4/4    Project details', 16),
          const SizedBox(height: 16),
          _Text(widget.title, 16),
          const SizedBox(height: 16),
          const Divider(height: 17, thickness: 2, color: Colors.grey),
          const SizedBox(height: 16),
          _Text('Students are looking for', 16),
          const SizedBox(height: 16),
          // Use a ListView to display multiple lines of the description
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.descriptionLines.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Text(
                      widget.descriptionLines[index].isEmpty ? '' : '• ',
                      16,
                    ),
                    Expanded(
                      child: Text(widget.descriptionLines[index],
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(height: 17, thickness: 2, color: Colors.grey),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text('Project scope', 16),
                  Text(
                    widget.selectedDuration == 0
                        ? 'Less than 1 month'
                        : widget.selectedDuration == 1
                            ? '1 to 3 months'
                            : widget.selectedDuration == 2
                                ? '3 to 6 months'
                                : 'More than 6 months',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.group),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text(
                    'Students required',
                    16,
                  ),
                  Text(widget.numberOfStudents.toString(),
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _handlePostProject();
                  // pop until the first route
                  Navigator.popUntil(context, (route) => route.isFirst);
                  moveToPage(TabsPage(index: 1), context);
                },
                child: Text(
                  'Post job',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePostProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {
      'companyId': prefs.getInt('companyId'),
      'projectScopeFlag': widget.selectedDuration,
      'title': widget.title,
      'numberOfStudents': widget.numberOfStudents,
      'description': widget.descriptionLines.join('\n'),
      'typeFlag': 0,
    };

    String url = '/api/project/';

    try {
      var response = await Connection.postRequest(url, data);
      var responseDecoded = jsonDecode(response);
      print(responseDecoded);
      if (responseDecoded['result'] != null) {
        print('Project posted successfully');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Project posted successfully'),
            ),
          );
        }
      } else {
        print('Project post failed');
        dynamic errorDetails = responseDecoded['errorDetails'];
        String errorMessage = '';
        if (errorDetails is List) {
          errorMessage = errorDetails.first.toString();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Project post failed: $errorMessage'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred: $e'),
          ),
        );
      }
    }
  }

  Text _Text(String title, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
