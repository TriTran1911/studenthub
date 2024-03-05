import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Build your product with high-skilled student',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'StudentHub is university marketplace to connect high-skilled student and company on a real-world project',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to Company section
            },
            child: Text('Company'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to Student section
            },
            child: Text('Student'),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'StudentHub is university marketplace to connect high-skilled student and company on a real-world project',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Build your product with high-skilled student',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for navigation
class CompanyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Company')),
      body: Center(child: Text('Company Section')),
    );
  }
}

class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StudentHub',
          textAlign: TextAlign.left, // Đặt văn bản ở góc trái
        ),
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            // Add your onPressed logic here
          },
        ),
      ),
      body: Center(child: Text('Student Section')),
    );
  }
}
