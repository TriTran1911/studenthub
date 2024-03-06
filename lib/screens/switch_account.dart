import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class SwitchAccountScreen extends StatefulWidget {
  @override
  _SwitchAccountScreenState createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align buttons in the center
          children: <Widget>[
            SizedBox(height: 24), // Add space at the top
            // DropdownButton for 'Company'
            _buildDropdownButton(Icons.arrow_back_ios, _handleCompanySelection),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Profiles'
            _buildElevatedButton(
                Icons.school, 'Profiles', _handleProfilesButtonPress),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Settings'
            _buildElevatedButton(
                Icons.settings, 'Settings', _handleSettingsButtonPress),
            SizedBox(height: 16), // Add space between buttons

            // ElevatedButton for 'Logout'
            _buildElevatedButton(
                Icons.logout, 'Logout', _handleLogoutButtonPress),
          ],
        ),
      ),
    );
  }

  void _handleCompanySelection(String? selectedCompany) {
    // Handle the selected company
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
      height: 60.0, // Adjust the height as needed
      child: DropdownButtonFormField<String>(
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
            child: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Container(
                  child: Column(
                    children: [
                      Text('Hai Pham',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text('Company',
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Company2',
            child: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 10),
                Container(
                  child: Column(
                    children: [
                      Text('Hai Pham Student',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text('Student',
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add more items as needed
        ],
        onChanged: onChanged,
        itemHeight: 80.0,
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
