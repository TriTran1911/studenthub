import 'package:flutter/material.dart';
import '/components/appbar.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlertsPage(),
    );
  }
}

class AlertsPage extends StatefulWidget {

  AlertsPage();

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: Center(
        child: Text('Alerts'),
      ),
    );
  }
}