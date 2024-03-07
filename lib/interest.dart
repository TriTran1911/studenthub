import 'package:flutter/material.dart';

class InterestContainer extends StatefulWidget {
  final List<String> interests;

  InterestContainer({required this.interests});

  @override
  _InterestContainerState createState() => _InterestContainerState();
}

class _InterestContainerState extends State<InterestContainer> {
  List<bool> _selectedInterests = [];

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.generate(widget.interests.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildInterestChips(),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _showSelectedInterests();
          },
          child: Text('Pick Selected Interests'),
        ),
      ],
    );
  }

  List<Widget> _buildInterestChips() {
    List<Widget> chips = [];
    for (int i = 0; i < widget.interests.length; i++) {
      chips.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedInterests[i] = !_selectedInterests[i];
            });
          },
          child: Chip(
            label: Text(
              widget.interests[i],
              style: TextStyle(
                color: _selectedInterests[i] ? Colors.grey[400] : Colors.white,
              ),
            ),
            backgroundColor: _selectedInterests[i] ? Colors.blueGrey : Colors.blue,
            elevation: _selectedInterests[i] ? 0.0 : 2.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
      );
    }
    return chips;
  }

  void _showSelectedInterests() {
    List<String> selectedInterests = [];
    for (int i = 0; i < _selectedInterests.length; i++) {
      if (_selectedInterests[i]) {
        selectedInterests.add(widget.interests[i]);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected Interests: ${selectedInterests.join(', ')}'),
      ),
    );
  }
}
