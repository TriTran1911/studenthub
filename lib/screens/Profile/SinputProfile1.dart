import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import '../../components/appbar.dart';
import 'dart:convert';
import '../../connection/server.dart';
import 'SinputProfile2.dart';
import 'package:studenthub/components/decoration.dart';

class StudentInputProfile1 extends StatefulWidget {
  const StudentInputProfile1({super.key});

  @override
  State<StudentInputProfile1> createState() => _StudentInputProfile1State();
}

class _StudentInputProfile1State extends State<StudentInputProfile1> {
  // ignore: non_constant_identifier_names
  List<TechStack> _TechStackList = [];
  // ignore: non_constant_identifier_names
  List<SkillSet> _SkillSetList = [];

  final List<SkillSet> _selectedSkillSet = [];
  TechStack? _selectedTechStack;
  List<Language> languageList = [];
  List<Education> educationList = [];

  @override
  void initState() {
    _fectchData();
    super.initState();
  }

  void _fectchData() async {
    // show loading dialog until the data is fetched
    _TechStackList = await getTechStack();
    _SkillSetList = await getSkillSet();
    setState(() {});
  }

  Future<List<TechStack>> getTechStack() async {
    var response =
        await Connection.getRequest('/api/techstack/getAllTechStack', {});
    var responseDecoded = jsonDecode(response);
    // init a temp list to store the techstack
    List<TechStack> list = [];

    if (responseDecoded['result'] != null) {
      print(responseDecoded['result']);
      for (var tech in responseDecoded['result']) {
        list.add(TechStack.fromJson(tech));
      }
      return list;
    } else {
      throw Exception('Failed to load techstack');
    }
  }

  Future<List<SkillSet>> getSkillSet() async {
    var response =
        await Connection.getRequest('/api/skillset/getAllSkillSet', {});
    var responseDecoded = jsonDecode(response);
    List<SkillSet> list = [];

    if (responseDecoded['result'] != null) {
      for (var skill in responseDecoded['result']) {
        list.add(SkillSet.fromJson(skill));
      }
      return list;
    } else {
      throw Exception('Failed to load skillset');
    }
  }

  Future<void> fetchData() async {
    await getTechStack();
    await getSkillSet();
  }

  void postProfile() async {
    int? studentId = modelController.user.id;

    var datats = {
      'techStackId': _selectedTechStack?.id.toString(),
      'skillSets': _selectedSkillSet.map((e) => e.id.toString()).toList(),
    };
    var datal = {
      "languages": languageList
          .map((language) => {
                "id": null,
                "languageName": language.languageName,
                "level": language.level,
              })
          .toList(),
    };
    var datae = {
      "educations": educationList
          .map((education) => {
                "id": null,
                "schoolName": education.schoolName,
                "startYear": education.startYear,
                "endYear": education.endYear,
              })
          .toList(),
    };
    try {
      var response =
          await Connection.postRequest('/api/profile/student', datats);
      var responseDecoded = jsonDecode(response);
      print(responseDecoded);
      if (responseDecoded['result'] != null) {
        print('Post profile successful');
        await Connection.putRequest(
            '/api/language/updateByStudentID/$studentId', datal);
        await Connection.putRequest(
            '/api/education/updateByStudentID/$studentId', datae);
      } else {
        print("sinputprofile_text3".tr());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseDecoded['errorDetails']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("sinputprofile_text4".tr()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32),
            buildCenterText("proifle_title1".tr(), 24, FontWeight.bold),
            const SizedBox(height: 16),
            buildText("sinputprofile_text5".tr(), 16, FontWeight.normal),
            const SizedBox(height: 16),
            buildText('Techstack', 20, FontWeight.bold),
            const SizedBox(height: 16),
            buildTechstackDropdownMenu(),
            const SizedBox(height: 16),
            buildText('Skillset', 20, FontWeight.bold),
            const SizedBox(height: 16),
            buildSkillset(),
            const SizedBox(height: 16),
            buildLanguage(),
            const SizedBox(height: 16),
            buildEducation(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    postProfile();
                    moveToPage(
                        StudentInputProfile2(skillSetList: _SkillSetList),
                        context);
                  },
                  style: buildButtonStyle(Colors.blue[400]!),
                  child: buildText('Next', 16, FontWeight.bold, Colors.white),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget buildLanguage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText('Language', 20, FontWeight.bold),
            buildAddButton('Language'),
          ],
        ),
        const SizedBox(height: 16),
        buildLanguageList(),
      ],
    );
  }

  Widget buildLanguageList() {
    // display the language list
    return Column(
      children: <Widget>[
        for (var language in languageList)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                          language.languageName ?? '', 16, FontWeight.bold),
                      buildText(language.level ?? '', 16, FontWeight.normal,
                          Colors.grey),
                    ],
                  ),
                  Row(
                    children: [
                      buildEditButton(
                          'Language', languageList.indexOf(language)),
                      const SizedBox(width: 16),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              languageList.remove(language);
                            });
                          },
                          icon: const Icon(Icons.delete_outline))
                    ],
                  )
                ],
              ),
              // check if the language is the last element in the list
              if (language != languageList.last) const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget buildEducation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText('Education', 20, FontWeight.bold),
            buildAddButton('Education'),
          ],
        ),
        buildEducationList(),
      ],
    );
  }

  Widget buildEducationList() {
    return Column(
      children: <Widget>[
        for (var education in educationList)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                          education.schoolName ?? '', 16, FontWeight.bold),
                      buildText(
                          '${education.startYear!} - ${education.endYear!}',
                          16,
                          FontWeight.normal,
                          Colors.grey[600]!),
                    ],
                  ),
                  Row(
                    children: [
                      buildEditButton(
                          'Education', educationList.indexOf(education)),
                      const SizedBox(width: 16),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              educationList.remove(education);
                            });
                          },
                          icon: const Icon(Icons.delete_outline))
                    ],
                  )
                ],
              ),
              if (education != educationList.last) const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget buildAddButton(String text) {
    return IconButton(
        onPressed: () {
          text == 'Language' ? showLanguageDialog() : showEducationDialog();
        },
        icon: const Icon(Icons.add_circle_outline));
  }

  Widget buildEditButton(String text, int index) {
    return IconButton(
        onPressed: () {
          text == 'Language'
              ? showLanguageDialog(language: languageList[index])
              : showEducationDialog(education: educationList[index]);
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Future<void> showEducationDialog({Education? education}) async {
    final schoolNameController = TextEditingController();
    final dateStartedController = TextEditingController();
    final dateEndedController = TextEditingController();

    if (education != null) {
      schoolNameController.text = education.schoolName!;
      dateStartedController.text = education.startYear.toString();
      dateEndedController.text = education.endYear.toString();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildText(
                    education == null
                        ? 'Add an Education'
                        : 'Edit and Education',
                    20,
                    FontWeight.bold),
                const SizedBox(height: 16),
                TextFormField(
                  controller: schoolNameController,
                  decoration: buildDecoration('School name'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: dateStartedController,
                          decoration: buildDecoration('Year started'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: dateEndedController,
                          decoration: buildDecoration('Year ended'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.grey[400]!),
                      child: buildText(
                          'Cancel', 16, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (schoolNameController.text.isNotEmpty &&
                            dateStartedController.text.isNotEmpty &&
                            dateEndedController.text.isNotEmpty &&
                            int.parse(dateStartedController.text) <=
                                int.parse(dateEndedController.text)) {
                          setState(() {
                            if (education == null) {
                              educationList.add(Education(
                                schoolName: schoolNameController.text,
                                startYear:
                                    int.parse(dateStartedController.text),
                                endYear: int.parse(dateEndedController.text),
                              ));
                            } else {
                              education.schoolName = schoolNameController.text;
                              education.startYear =
                                  int.parse(dateStartedController.text);
                              education.endYear =
                                  int.parse(dateEndedController.text);
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields correctly'),
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.blue[400]!),
                      child: buildText(education == null ? 'Add' : 'Edit', 16,
                          FontWeight.bold, Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showLanguageDialog({Language? language}) async {
    String? selectedLanguage = language?.languageName;
    String? selectedLanguageLevel = language?.level;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildText(
                    language == null ? 'Add a Language' : 'Edit a Language',
                    20,
                    FontWeight.bold),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                  decoration: buildDecoration("Select a language"),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguageLevel,
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: levels.map((String languageLevel) {
                    return DropdownMenuItem<String>(
                      value: languageLevel,
                      child: Text(languageLevel),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguageLevel = value;
                    });
                  },
                  decoration: buildDecoration(
                    "Select a language level",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.grey[400]!),
                      child: buildText(
                          'Cancel', 16, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedLanguage != null &&
                            selectedLanguageLevel != null) {
                          setState(() {
                            if (language == null) {
                              languageList.add(Language(
                                languageName: selectedLanguage,
                                level: selectedLanguageLevel,
                              ));
                            } else {
                              language.languageName = selectedLanguage;
                              language.level = selectedLanguageLevel;
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please choose a language and level'),
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      style: buildButtonStyle(Colors.blue[400]!),
                      child:
                          buildText('Add', 16, FontWeight.bold, Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTechstackDropdownMenu() {
    return DropdownButtonFormField<TechStack>(
      value: _selectedTechStack,
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: _TechStackList.map((TechStack techStack) {
        return DropdownMenuItem<TechStack>(
          value: techStack,
          child: Text(techStack.name!),
        );
      }).toList(),
      onChanged: (TechStack? value) {
        setState(() {
          _selectedTechStack = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Select a techstack",
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget buildSkillset() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: _SkillSetList.map(
                (SkillSet skillSet) => buildSkillsetButton(skillSet)).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildSkillsetButton(SkillSet skillSet) {
    bool isSelected = _selectedSkillSet.contains(skillSet);
    return TextButton(
      onPressed: () {
        isSelected = !isSelected;
        if (isSelected) {
          _selectedSkillSet.add(skillSet);
        } else {
          _selectedSkillSet.remove(skillSet);
        }
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isSelected) {
              return Colors.grey[400]!;
            }
            return Colors.blue[400]!;
          },
        ),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: buildText(skillSet.name!, 16, FontWeight.normal, Colors.white),
    );
  }
}
