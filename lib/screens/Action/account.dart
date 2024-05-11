import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/screens/Action/changePassWord.dart';
import 'package:studenthub/screens/Profile/Cprofile.dart';
import '../../components/appbar.dart';
import '/screens/Profile/CprofileInput.dart';
import '/components/modelController.dart';
import '/components/controller.dart';
import 'home.dart';
import 'package:studenthub/screens/Action/changeLanguage.dart';
import 'package:studenthub/screens/Action/changeTheme.dart';
import 'package:studenthub/connection/server.dart';
import '../../screens/Profile/SinputProfile1.dart';

class AccountController extends StatefulWidget {
  @override
  _AccountControllerState createState() => _AccountControllerState();
}

class _AccountControllerState extends State<AccountController> {
  String? selectedAccount;
  IconData selectedAccountIcon =
      modelController.user.roles[0] == 1 ? Icons.business : Icons.school;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
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
          _buildElevatedButton(Icons.account_circle_outlined, "account_text1".tr(),
              _handleProfilesButtonPress),
          const Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.settings, "account_text2".tr(), _handleSettingsButtonPress),
          const Divider(height: 17, color: Colors.grey),
          _buildElevatedButton(
              Icons.logout, "account_text3".tr(), _handleLogoutButtonPress),
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
      modelController.user.roles = List<int>.from(
          result['roles'].map((item) => int.parse(item.toString())));
      if (result['roles'].length == 1) {
        if (result['roles'][0] == 1) {
          result['company'] == null
              ? moveToPage(CWithoutProfile(), context)
              : moveToPage(CompanyProfile(), context);
        } else {
          result['student'] == null
              ? moveToPage(StudentInputProfile1(), context)
              : moveToPage(StudentInputProfile1(), context);
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
                                  ChangeLanguagePage(),
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
                'Do you want to add a role as a ${modelController.user.roles[0] == 1 ? 'Student' : 'Company'}?',
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
                      moveToPage(modelController.user.roles[0] == 1 ? StudentInputProfile1() : CWithoutProfile(), context);
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
      title: Text(selectedAccount ?? modelController.user.fullname,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(modelController.user.roles[0] == 1
                  ? Icons.business
                  : Icons.school),
              title: Text(
                modelController.user.fullname,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  modelController.user.roles[0] == 1 ? 'Company' : 'Student'),
              onTap: () {
                handleCompanySelection(
                    modelController.user.fullname,
                    modelController.user.roles[0] == 1
                        ? Icons.business
                        : Icons.school);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: modelController.user.roles.length == 1
                  ? const Icon(Icons.add)
                  : Icon(modelController.user.roles[1] == 1
                      ? Icons.business
                      : Icons.school),
              title: Text(
                modelController.user.roles.length == 1
                    ? 'Add Role'
                    : modelController.user.roles[1] == 1
                        ? modelController.user.fullname
                        : modelController.user.fullname,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: modelController.user.roles.length == 1
                  ? null
                  : Text(modelController.user.roles[1] == 1
                      ? 'Company'
                      : 'Student'),
              onTap: () {
                if (modelController.user.roles.length == 1) {
                  _handleAddRole(context);
                } else {
                  handleCompanySelection(
                      modelController.user.fullname,
                      modelController.user.roles[1] == 1
                          ? Icons.business
                          : Icons.school);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Change role successfully."),
                    ),
                  );
                  // swap roles
                  modelController.user.roles = [
                    modelController.user.roles[1],
                    modelController.user.roles[0]
                  ];
                  print(modelController.user.roles[0]);
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
