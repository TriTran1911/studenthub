import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class SwitchAccountScreen extends StatefulWidget {
  @override
  _SwitchAccountScreenState createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  double bottomElementOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24), // Add space at the top
            // DropdownButton for 'Company'
            _buildDropdownButton(Icons.arrow_back_ios, _handleCompanySelection),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Profiles'
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              transform:
                  Matrix4.translationValues(0.0, bottomElementOffset, 0.0),
              child: _buildElevatedButton(Icons.account_circle_outlined,
                  'Profiles', _handleProfilesButtonPress),
            ),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Settings'
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              transform:
                  Matrix4.translationValues(0.0, bottomElementOffset, 0.0),
              child: _buildElevatedButton(
                  Icons.settings, 'Settings', _handleSettingsButtonPress),
            ),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Logout'
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              transform:
                  Matrix4.translationValues(0.0, bottomElementOffset, 0.0),
              child: _buildElevatedButton(
                  Icons.logout, 'Logout', _handleLogoutButtonPress),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCompanySelection(String? selectedCompany) {
    // Handle the selected company

    setState(() {
      bottomElementOffset = 0.0; // Reset the offset to 0.0
    });
  }

  void _handleProfilesButtonPress() {
    // Handle 'Profiles' button press
  }

  void _handleSettingsButtonPress() {
    // Handle 'Settings' button press
  }

  void _handleLogoutButtonPress() {
    // Handle 'Logout' button press
  }

  Widget _buildDropdownButton(IconData icon, Function(String?)? onChanged) {
    return Container(
      child: DropdownButtonFormField<String>(
        onTap: () {
          setState(() {
            bottomElementOffset =
                50.0; // Adjust the offset based on the dropdown height
          });
        },
        onSaved: (String? value) {
          setState(() {
            bottomElementOffset = 0.0;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        icon: Icon(icon),
        items: [
          DropdownMenuItem(
            value: 'Company1',
            child: _buildDropdownItemContent('Hai Pham', 'Company'),
          ),
          DropdownMenuItem(
            value: 'Company2',
            child: _buildDropdownItemContent('Hai Pham Student', 'Student'),
          ),
          // Add more items as needed
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildElevatedButton(IconData icon, String text, Function onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed as void Function()?,
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 8), // Adjust spacing between icon and text
              Text(text),
            ],
          ),
        ),
      ],
    );
  }
}

class _buildDropdownItemContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const _buildDropdownItemContent(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.account_circle, size: 30.0),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 5.0,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 5.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
