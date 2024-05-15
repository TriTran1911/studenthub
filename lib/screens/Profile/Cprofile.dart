import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/appbar.dart';
import '../../components/decoration.dart';
import '../../components/modelController.dart';
import '../../connection/server.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  Company company = Company();
  int? durationController;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  Future<Company>? companyFuture;
  bool isEditing = false;

  Future<Company> getCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int companyId = prefs.getInt('companyId')!;

    try {
      var response =
          await Connection.getRequest('/api/profile/company/$companyId', {});
      var responseDecoded = jsonDecode(response);

      if (responseDecoded['result'] != null) {
        company = Company.fromJson(responseDecoded['result']);
        return company;
      } else {
        return Company();
      }
    } catch (e) {
      print(e);
    }
    return Company();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<Company>(
        future: getCompany(),
        builder: (BuildContext context, AsyncSnapshot<Company> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading indicator
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display the error message
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            company = snapshot.data!;
            durationController = company.size!;
            descriptionController.text = company.description!;
            websiteController.text = company.website!;
            fullnameController.text = company.fullname!;
            companyNameController.text = company.companyName!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildCenterText("proifle_title1".tr(), 22, FontWeight.bold,
                        Colors.blue),
                    const SizedBox(height: 16),
                    // Use Row for title and text when not editing
                    isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText("cprofileinput_input1".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(height: 16),
                              TextField(
                                controller: companyNameController,
                                decoration: buildDecoration(
                                    "cprofileinput_input1".tr()),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildText("cprofileinput_input1".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(
                                  width: 8), // Adjust spacing as needed
                              buildText(companyNameController.text, 18,
                                  FontWeight.normal),
                            ],
                          ),
                    const SizedBox(height: 16),
                    isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText("cprofileinput_input1".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(height: 16),
                              TextField(
                                controller: fullnameController,
                                decoration: buildDecoration(
                                    "cprofileinput_input1".tr()),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildText("cprofileinput_input1".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(
                                  width: 8), // Adjust spacing as needed
                              buildText(fullnameController.text, 18,
                                  FontWeight.normal),
                            ],
                          ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildText(
                            "cprofileinput_input1".tr(), 18, FontWeight.bold),
                        const SizedBox(width: 8), // Adjust spacing as needed
                        buildText(company.email!, 18, FontWeight.normal),
                      ],
                    ),
                    const SizedBox(height: 16),
                    isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText("cprofileinput_input2".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(height: 16),
                              TextField(
                                controller: websiteController,
                                decoration: buildDecoration(
                                    "cprofileinput_input2".tr()),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildText("cprofileinput_input2".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(width: 8),
                              buildText(websiteController.text, 18,
                                  FontWeight.normal),
                            ],
                          ),
                    const SizedBox(height: 16),
                    isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText("cprofileinput_input3".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(height: 16),
                              TextField(
                                maxLines: 5,
                                controller: descriptionController,
                                decoration: buildDecoration(
                                    "cprofileinput_input3".tr()),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildText("cprofileinput_input3".tr(), 18,
                                  FontWeight.bold),
                              const SizedBox(width: 8),
                              buildText(descriptionController.text, 18,
                                  FontWeight.normal),
                            ],
                          ),
                    const SizedBox(height: 16),
                    buildText("cprofileinput_text2".tr(), 18, FontWeight.bold),
                    const SizedBox(height: 16),
                    StatefulBuilder(builder: (context, setStateRadio) {
                      return Column(
                        children: [
                          RadioListTile<int>(
                            title: Text(tr("cprofileinput_text3")),
                            value: 0,
                            groupValue: durationController,
                            onChanged: isEditing
                                ? (int? value) {
                                    setStateRadio(() {
                                      durationController = value!;
                                    });
                                  }
                                : (int? value) {},
                          ),
                          RadioListTile<int>(
                            title: Text(tr("cprofileinput_text4")),
                            value: 1,
                            groupValue: durationController,
                            onChanged: isEditing
                                ? (int? value) {
                                    setStateRadio(() {
                                      durationController = value!;
                                    });
                                  }
                                : (int? value) {},
                          ),
                          RadioListTile<int>(
                            title: Text(tr("cprofileinput_text5")),
                            value: 2,
                            groupValue: durationController,
                            onChanged: isEditing
                                ? (int? value) {
                                    setStateRadio(() {
                                      durationController = value!;
                                    });
                                  }
                                : (int? value) {},
                          ),
                          RadioListTile<int>(
                            title: Text(tr("cprofileinput_text6")),
                            value: 3,
                            groupValue: durationController,
                            onChanged: isEditing
                                ? (int? value) {
                                    setStateRadio(() {
                                      durationController = value!;
                                    });
                                  }
                                : (int? value) {},
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isEditing)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                            style: buildButtonStyle(Colors.grey),
                            child: buildText(
                                'Cancel', 18, FontWeight.bold, Colors.white),
                          ),
                        if (isEditing) const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (isEditing) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              int companyId = prefs.getInt('companyId')!;

                              var data = {
                                'companyName': companyNameController.text,
                                'fullname': fullnameController.text,
                                'website': websiteController.text,
                                'description': descriptionController.text,
                                'size': durationController,
                              };

                              await Connection.putRequest(
                                  '/api/profile/company/$companyId', data);
                            }
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          style: buildButtonStyle(Colors.blue),
                          child: buildText(isEditing ? "Save" : "Edit", 18,
                              FontWeight.bold, Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
