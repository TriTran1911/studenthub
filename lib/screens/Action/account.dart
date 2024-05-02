import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/screens/Action/changePassWord.dart';
import 'package:studenthub/screens/Profile/Cprofile.dart';
import '../../components/appbar.dart';
import '/screens/Profile/CprofileInput.dart';
import '/screens/Profile/SprofileInput1.dart';
import '/components/modelController.dart';
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
  IconData selectedAccountIcon =
      User.roles[0] == 1 ? Icons.business : Icons.school;

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
    final respone = await Connection.getRequest('/api/auth/me', {});
    final data = jsonDecode(respone);

    if (data['result'] != null) {
      var result = data['result'];
      User.roles = List<int>.from(
          result['roles'].map((item) => int.parse(item.toString())));
      if (result['roles'].length == 1) {
        if (result['roles'][0] == 1) {
          result['company'] == null
              ? moveToPage(CWithoutProfile(), context)
              : moveToPage(CompanyProfile(), context);
        } else {
          result['student'] == null
              ? moveToPage(StudentInfoScreen(), context)
              : moveToPage(StudentInfoScreen(), context);
        }
      } else {}
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

  void _handleLogoutButtonPress(BuildContext context) async {
    appBarIcon.isSelected = !appBarIcon.isSelected;
    appBarIcon.isBlocked = true;

    var response = await Connection.postRequest('/api/auth/logout', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');

      print('Logout successful');
    } else {
      print('Logout failed');
    }

    moveToPage(Home(), context);
  }

  void _handleAddRole(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Role',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Do you want to add a role as a ${User.roles[0] == 1 ? 'Student' : 'Company'}?',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      moveToPage(User.roles[0] == 1 ? StudentInfoScreen() : CWithoutProfile(), context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(
      void Function(String? selectedCompany, IconData companyIcon)
          handleCompanySelection) {
    return ExpansionTile(
      leading: Icon(selectedAccountIcon),
      title: Text(selectedAccount ?? User.fullname,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(User.roles[0] == 1 ? Icons.business : Icons.school),
              title: Text(
                User.fullname,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(User.roles[0] == 1 ? 'Company' : 'Student'),
              onTap: () {
                handleCompanySelection(User.fullname,
                    User.roles[0] == 1 ? Icons.business : Icons.school);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: User.roles.length == 1
                  ? const Icon(Icons.add)
                  : Icon(User.roles[1] == 1 ? Icons.business : Icons.school),
              title: Text(
                User.roles.length == 1
                    ? 'Add Role'
                    : User.roles[1] == 1
                        ? User.fullname
                        : User.fullname,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: User.roles.length == 1
                  ? null
                  : Text(User.roles[1] == 1 ? 'Company' : 'Student'),
              onTap: () {
                if (User.roles.length == 1) {
                  _handleAddRole(context);
                } else {
                  handleCompanySelection(User.fullname,
                      User.roles[1] == 1 ? Icons.business : Icons.school);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Change role successfully."),
                    ),
                  );
                  // swap roles
                  User.roles = [User.roles[1], User.roles[0]];
                  print(User.roles[0]);
                }
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
