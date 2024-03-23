import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import '/screens/Profile/CprofileInputWithoutProfile.dart';
import '/screens/Profile/SprofileInput1.dart';
import '/components/controller.dart';
import 'home.dart';

class AccountController extends StatefulWidget {
  @override
  _AccountControllerState createState() => _AccountControllerState();
}

class _AccountControllerState extends State<AccountController> {
  String? selectedAccount;
  IconData selectedAccountIcon = Icons.business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _Padding(),
    );
  }

  Padding _Padding() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Divider(height: 17, color: Colors.grey),
          _buildListView(_handleCompanySelection),
          Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(Icons.account_circle_outlined, 'Profiles',
              _handleProfilesButtonPress),
          Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.settings, 'Settings', _handleSettingsButtonPress),
          Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.logout, 'Logout', _handleLogoutButtonPress),
          Divider(height: 17, color: Colors.grey),
        ],
      ),
    );
  }

  void _handleCompanySelection(String? selectedCompany, IconData companyIcon) {
    setState(() {
      selectedAccount = selectedCompany;
      selectedAccountIcon = companyIcon;
    });
  }

  void _handleProfilesButtonPress(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                User.isCompany ? CWithoutProfile() : StudentInfoScreen()));
  }

  void _handleSettingsButtonPress(BuildContext context) {}

  void _handleLogoutButtonPress(BuildContext context) {
    appBarIcon.isSelected = !appBarIcon.isSelected;
    appBarIcon.isBlocked = true;
    navigateToPagePushReplacement(Home(), context);
  }

  Widget _buildListView(
    void Function(String? selectedCompany, IconData companyIcon)
        handleCompanySelection,
  ) {
    return ExpansionTile(
      leading: Icon(selectedAccountIcon),
      title: Text(selectedAccount ?? 'Select an account',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
          onPressed: () => onPressed(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
