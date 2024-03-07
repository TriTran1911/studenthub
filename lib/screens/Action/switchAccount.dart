import 'package:flutter/material.dart';
import '/components/custom_appbar.dart';

class SwitchAccount extends StatefulWidget {
  @override
  _SwitchAccountState createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  String? selectedAccount;
  bool isExpanded = false;
  IconData selectedAccountIcon =
      Icons.business; // Added variable for selected account icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey), // Divider
            _buildDropdownButton(_handleCompanySelection),
            Divider(height: 1, color: Colors.grey), // Divider

            SizedBox(height: 8),
            _buildElevatedButton(Icons.account_circle_outlined, 'Profiles',
                _handleProfilesButtonPress),
            SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey), // Divider
            SizedBox(height: 8),
            _buildElevatedButton(
                Icons.settings, 'Settings', _handleSettingsButtonPress),
            SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey), // Divider
            SizedBox(height: 8),
            _buildElevatedButton(
                Icons.logout, 'Logout', _handleLogoutButtonPress),
            SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey), // Divider
          ],
        ),
      ),
    );
  }

  void _handleCompanySelection(String? selectedCompany, IconData companyIcon) {
    setState(() {
      selectedAccount = selectedCompany;
      selectedAccountIcon = companyIcon;
      isExpanded = false; // Collapse the ExpansionTile
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

  Widget _buildDropdownButton(
    void Function(String? selectedCompany, IconData companyIcon)
        handleCompanySelection,
  ) {
    return ExpansionTile(
      leading: Icon(selectedAccountIcon), // Use the selected account icon
      title: Text(selectedAccount ?? 'Select an account',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = value;
        });
      },

      initiallyExpanded: isExpanded,
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.business),
              title: Text(
                'Hai Pham',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Company'),
              onTap: () {
                handleCompanySelection('Hai Pham', Icons.business);
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text(
                'Hai Pham Student',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Student'),
              onTap: () {
                handleCompanySelection('Hai Pham Student', Icons.school);
              },
            ),
            // Add more list tiles for additional accounts
          ],
        ),
      ],
    );
  }

  Widget _buildElevatedButton(IconData icon, String text, Function onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed as void Function()?,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors
                .transparent, // Set the button background color to transparent
            elevation: 0, // Set elevation to 0 to remove the shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0), // Adjust the border radius as needed
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 8), // Adjust spacing between icon and text
              Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set the text color to black
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}