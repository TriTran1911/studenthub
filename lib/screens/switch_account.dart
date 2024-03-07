import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';

class SwitchAccountScreen extends StatefulWidget {
  @override
  _SwitchAccountScreenState createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  String? selectedAccount;
  bool isExpanded = false;

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
            SizedBox(height: 24),
            _buildDropdownButton(Icons.arrow_back_ios, _handleCompanySelection),
            SizedBox(height: 16),
            _buildElevatedButton(Icons.school, 'Profiles', _handleProfilesButtonPress),
            SizedBox(height: 16),
            _buildElevatedButton(Icons.settings, 'Settings', _handleSettingsButtonPress),
            SizedBox(height: 16),
            _buildElevatedButton(Icons.logout, 'Logout', _handleLogoutButtonPress),
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

  Widget _buildDropdownButton(IconData icon, void Function(String? selectedCompany) handleCompanySelection,) {
  return ExpansionTile(
      leading: Icon(icon),
      title: Text(
        selectedAccount ?? 'Select an account',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
      ),
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
              leading: Icon(Icons.account_circle),
              title: Text(
                'Hai Pham',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Company'),
              onTap: () {
                setState(() {
                  selectedAccount = 'Hai Pham';
                  isExpanded = false; // Collapse the ExpansionTile
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                'Hai Pham Student',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Student'),
              onTap: () {
                setState(() {
                  selectedAccount = 'Hai Pham Student';
                  isExpanded = false; // Collapse the ExpansionTile
                });
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
