import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/screens/Action/changePassWord.dart';
import '../../components/appbar.dart';
import '/screens/Profile/CprofileInput.dart';
import '/screens/Profile/SprofileInput1.dart';
import '/components/controller.dart';
import 'home.dart';
import 'package:studenthub/screens/Action/changeLanguage.dart';
import 'package:studenthub/screens/Action/changeTheme.dart';

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
          const Divider(height: 17, color: Colors.grey),
          _buildListView(_handleCompanySelection),
          const Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(Icons.account_circle_outlined, 'Profiles',
              _handleProfilesButtonPress),
          const Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.settings, 'Settings', _handleSettingsButtonPress),
          const Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.logout, 'Logout', _handleLogoutButtonPress),
          const Divider(height: 17, color: Colors.grey),
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

  void _handleSettingsButtonPress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent, // make the container transparent
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              color: Colors.white, // set the background color to white
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 400,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            Expanded(
                              child: PageView(
                                children: [
                                  ChangePasswordPage(),
                                  ChangeLanguagePage(),
                                  ChangeThemePage(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
              title: const Text(
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
              title: const Text(
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
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
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
