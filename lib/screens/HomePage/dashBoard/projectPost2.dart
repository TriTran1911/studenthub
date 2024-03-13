import 'package:flutter/material.dart';
import '/components/appbar.dart';
import 'projectPost3.dart';

void main() {
  runApp(projectPost2());
}

class projectPost2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: ScopePage(),
      ),
    );
  }
}

class ScopePage extends StatefulWidget {
  @override
  _ScopePageState createState() => _ScopePageState();
}

class _ScopePageState extends State<ScopePage> {
  String selectedDuration = '';
  int numberOfStudents = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2/4     Next, estimate the scope of your job',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Consider the size of your project and the timeline',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),
          Text('How long will your project take?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile(
            title: Text('1 to 3 months'),
            value: '1 to 3 months',
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          RadioListTile(
            title: Text('3 to 6 months'),
            value: '3 to 6 months',
            groupValue: selectedDuration,
            onChanged: (value) {
              setState(() {
                selectedDuration = value!;
              });
            },
          ),
          SizedBox(height: 16),
          Text('How many students do you want for this project?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                numberOfStudents = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(
              hintText: 'Number of students',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => projectPost3()),
                  );
                },
                child: Text(
                  'Next: Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
}
