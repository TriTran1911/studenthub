import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import '../../components/appbar.dart';
import 'dart:convert';
import '../../connection/server.dart';
import 'SinputProfile2.dart';
import 'package:studenthub/components/keyword.dart';

class StudentInputProfile1 extends StatefulWidget {
  const StudentInputProfile1({super.key});

  @override
  State<StudentInputProfile1> createState() => _StudentInputProfile1State();
}

class _StudentInputProfile1State extends State<StudentInputProfile1> {
  List<TechStack> _TechStackList = [];
  List<SkillSet> _SkillSetList = [];

  final List<SkillSet> _selectedSkillSet = [];
  TechStack? _selectedTechStack;
  List<Language> languageList = [];
  String? selectedLanguage;
  String? selectedLanguageLevel; 

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fectchData();
  }

  void _fectchData() async {
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
    // init a temp list to store the skillset
    List<SkillSet> list = [];

    if (responseDecoded['result'] != null) {
      print(responseDecoded['result']);
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
    var body = {
      'techStack': _selectedTechStack?.id.toString(),
      'skillSet': _selectedSkillSet.map((e) => e.id.toString()).toList(),
    };
    try {
      var response = await Connection.postRequest('/api/profile/student', body);
      var responseDecoded = jsonDecode(response);
      print(responseDecoded);
      if (responseDecoded['result'] != null) {
        print('Post profile successful');
        moveToPage(StudentInputProfile2(skillSetList: _SkillSetList), context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile posted successfully'),
          ),
        );
      } else {
        print('Post profile failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseDecoded['errorDetails']),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post profile'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32),
            buildCenterText('Welcome to Student Hub', 24, FontWeight.bold),
            const SizedBox(height: 16),
            buildText(
                'Tell us about yourself and you will be on your way to connect with companies',
                16,
                FontWeight.normal),
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
          ],
        )),
      ),
      // 'Next' button to navigate to the next page at the bottom of the screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(_selectedTechStack?.name);
          for (var skill in _selectedSkillSet) {
            print(skill.name);
          }
          // postProfile();
          moveToPage(
              StudentInputProfile2(skillSetList: _SkillSetList), context);
        },
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: buildText('Next', 16, FontWeight.bold),
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
            Row(
              children: [
                buildAddButton('Language'),
                buildEditButton('Language'),
              ],
            )
          ],
        ),
        buildLanguageList(),
      ],
    );
  }

  Widget buildLanguageList() {
    return Container();
  }

  Widget buildEducation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText('Education', 20, FontWeight.bold),
            Row(
              children: [
                buildAddButton('Education'),
              ],
            )
          ],
        ),
        buildEducationList(),
      ],
    );
  }

  Widget buildEducationList() {
    return Column(
      children: [
        buildText('Add an education', 16, FontWeight.normal),
      ],
    );
  }

  Widget buildAddButton(String text) {
    return IconButton(
        onPressed: () {
          text == 'Language'
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                              buildText('Add a $text', 20, FontWeight.bold),
                              const SizedBox(height: 16),
                              buildLanguageDropdown(),
                              const SizedBox(height: 16),
                              buildLanguageLevelDropdown(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: buildButtonStyle(Colors.grey[400]!),
                                    child: buildText('Cancel', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      languageList.add(Language(
                                          languageName: selectedLanguage,
                                          level: selectedLanguageLevel));
                                      Navigator.of(context).pop();
                                    },
                                    style: buildButtonStyle(Colors.blue[400]!),
                                    child: buildText('Add', 16, FontWeight.bold,
                                        Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                )
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                              buildText('Add an $text', 20, FontWeight.bold),
                              const SizedBox(height: 16),
                              buildSchoolName(),
                              const SizedBox(height: 16),
                              buildStartAndEndYear(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: buildButtonStyle(Colors.grey[400]!),
                                    child: buildText('Cancel', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: buildButtonStyle(Colors.blue[400]!),
                                    child: buildText('Add', 16, FontWeight.bold,
                                        Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                );
        },
        icon: const Icon(Icons.add_circle_outline));
  }

  Widget buildSchoolName() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'School name',
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

  Widget buildStartAndEndYear() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Start year',
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'End year',
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle buildButtonStyle(Color color) {
    return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(16.0),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  Widget buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
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
      decoration: InputDecoration(
        labelText: "Select a language",
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

  Widget buildLanguageLevelDropdown() {
    return DropdownButtonFormField<String>(
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
      decoration: InputDecoration(
        labelText: "Select a language level",
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

  Widget buildEditButton(String text) {
    return IconButton(
        onPressed: () {
          text == 'Language'
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                              buildText('Edit $text', 20, FontWeight.bold),
                              const SizedBox(height: 16),
                              buildLanguageDropdown(),
                              const SizedBox(height: 16),
                              buildLanguageLevelDropdown(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: buildButtonStyle(Colors.grey[400]!),
                                    child: buildText('Cancel', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: buildButtonStyle(Colors.blue[400]!),
                                    child: buildText('Edit', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                )
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                              buildText('Edit $text', 20, FontWeight.bold),
                              const SizedBox(height: 16),
                              buildSchoolName(),
                              const SizedBox(height: 16),
                              buildStartAndEndYear(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: buildButtonStyle(Colors.grey[400]!),
                                    child: buildText('Cancel', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: buildButtonStyle(Colors.blue[400]!),
                                    child: buildText('Edit', 16,
                                        FontWeight.bold, Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    );
                  },
                );
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Widget buildTechstackDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: _selectedTechStack?.name,
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: _TechStackList.map((TechStack techStack) {
        return DropdownMenuItem<String>(
          value: techStack.name,
          child: Text(techStack.name!),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedTechStack =
              _TechStackList.firstWhere((element) => element.name == value);
        });
      },
      decoration: InputDecoration(
        labelText: "Select a position",
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
      child: Text(
        skillSet.name!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
