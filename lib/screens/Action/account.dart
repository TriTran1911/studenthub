import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:studenthub/screens/Action/changePassWord.dart';
import 'package:studenthub/screens/Profile/Cprofile.dart';
import '../../components/appbar.dart';
import '/screens/Profile/CprofileInput.dart';
import '/screens/Profile/SprofileInput1.dart';
import '/components/controller.dart';
import 'home.dart';
import 'package:studenthub/screens/Action/changeLanguage.dart';
import 'package:studenthub/screens/Action/changeTheme.dart';
import 'package:studenthub/connection/http.dart';

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

  // ignore: non_constant_identifier_names
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

  

  void _handleProfilesButtonPress(BuildContext context) async {
    final respone = await Connection.getRequest('/api/auth/me', {} );
    final data = jsonDecode(respone);

    if (data['result'] != null) {
      var result = data['result'];
      if (result['roles'].length == 1) {
        if (result['roles'][0] == 1) {
          result['company'] == null
              ? navigateToPagePushReplacement(CWithoutProfile(), context)
              : navigateToPagePushReplacement(CompanyProfile(), context);
        }
        else {
          result['student'] == null
              ? navigateToPagePushReplacement(StudentInfoScreen(), context)
              : navigateToPagePushReplacement(StudentInfoScreen(), context);
        }
      }
      else {
        
      }
      print(result);
    }
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
                                  const ChangeLanguagePage(),
                                  const ChangeThemePage(),
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
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text(
                'Hai Pham',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Company'),
              onTap: () {
                handleCompanySelection('Hai Pham', Icons.business);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text(
                'Hai Pham Student',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Student'),
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
