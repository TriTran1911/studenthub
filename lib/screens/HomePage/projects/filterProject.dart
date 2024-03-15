import 'package:flutter/material.dart';

class FilterProjectsPage extends StatefulWidget {
  final void Function(
    Duration? projectDuration,
    int? studentsNeeded,
    int? proposalsLessThan,
  ) applyFilters;

  const FilterProjectsPage({Key? key, required this.applyFilters}) : super(key: key);

  @override
  _FilterProjectsPageState createState() => _FilterProjectsPageState();
}

class _FilterProjectsPageState extends State<FilterProjectsPage> {
  Duration? selectedProjectDuration;
  int? studentsNeeded;
  int? proposalsLessThan;

  @override
  void initState() {
    super.initState();
    //selectedProjectDuration = Duration(days: 30);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Projects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<Duration>(
  value: selectedProjectDuration,
  decoration: InputDecoration(
    labelText: 'Select Project Length',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  ),
  items: [
    DropdownMenuItem(
      value: Duration(days: 30),
      child: Text('Less than one month'),
    ),
    DropdownMenuItem(
      value: Duration(days: 90),
      child: Text('1 to 3 months'),
    ),
    DropdownMenuItem(
      value: Duration(days: 180),
      child: Text('3 to 6 months'),
    ),
    DropdownMenuItem(
      value: Duration(days: 9999), // Change this to a suitable value
      child: Text('More than 6 months'),
    ),
  ],
  onChanged: (value) {
    setState(() {
      selectedProjectDuration = value;
    });
  },
),
SizedBox(height: 20),
TextField(
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Enter Students Needed',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  ),
  onChanged: (value) {
    setState(() {
      studentsNeeded = int.tryParse(value);
    });
  },
),
SizedBox(height: 20),
TextField(
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Enter Proposals Less Than',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  ),
  onChanged: (value) {
    setState(() {
      proposalsLessThan = int.tryParse(value);
    });
  },
),
            SizedBox(height: 20),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: _clearFilters,
        child: Text('Clear Filters'),
      ),
    ),
    SizedBox(width: 10), 
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          widget.applyFilters(selectedProjectDuration, studentsNeeded, proposalsLessThan);
          Navigator.pop(context);
        },
        child: Text('Apply Filters'),
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      // Xóa tất cả các giá trị filter và thiết lập lại mặc định
      selectedProjectDuration = null;
      studentsNeeded = null;
      proposalsLessThan = null;
    });
  }
}

