import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/modelController.dart';
import '../../components/appbar.dart';
import 'dart:convert';
import '../../connection/http.dart';

class StudentInputProfile1 extends StatefulWidget {
  const StudentInputProfile1({super.key});

  @override
  State<StudentInputProfile1> createState() => _StudentInputProfile1State();
}

class _StudentInputProfile1State extends State<StudentInputProfile1> {
  final List<TechStack> _TechStackList = [];
  final List<SkillSet> _SkillSetList = [];
  final List<String> _selectedSkillSet = [];
  String? _selectedTechStack;
  String? _selectedLanguage;
  String? _selectedLanguageLevel;

  final searchController = TextEditingController();

  final List<String> _languages = [
    'Afrikaans',
    'Albanian',
    'Arabic',
    'Armenian',
    'Basque',
    'Bengali',
    'Bulgarian',
    'Catalan',
    'Cambodian',
    'Chinese (Mandarin)',
    'Croatian',
    'Czech',
    'Danish',
    'Dutch',
    'English',
    'Estonian',
    'Fiji',
    'Finnish',
    'French',
    'Georgian',
    'German',
    'Greek',
    'Gujarati',
    'Hebrew',
    'Hindi',
    'Hungarian',
    'Icelandic',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Javanese',
    'Korean',
    'Latin',
    'Latvian',
    'Lithuanian',
    'Macedonian',
    'Malay',
    'Malayalam',
    'Maltese',
    'Maori',
    'Marathi',
    'Mongolian',
    'Nepali',
    'Norwegian',
    'Persian',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Quechua',
    'Romanian',
    'Russian',
    'Samoan',
    'Serbian',
    'Slovak',
    'Slovenian',
    'Spanish',
    'Swahili',
    'Swedish',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Tibetan',
    'Tonga',
    'Turkish',
    'Ukrainian',
    'Urdu',
    'Uzbek',
    'Vietnamese',
    'Welsh',
    'Xhosa',
    'Yiddish',
    'Yoruba',
    'Zulu',
  ];

  // create a list of language levels to be displayed
  final List<String> _languageLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Fluent',
  ];

  @override
  void initState() {
    super.initState();
    getTechStack();
    getSkillSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
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
            buildDropdownMenu(),
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0), // adjust the padding as needed
            child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(16.0),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue[400]!),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: buildText('Next', 16, FontWeight.bold, Colors.white)),
          ),
        ],
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
                buildEditButton('Edit'),
              ],
            )
          ],
        ),
        buildLanguageList(),
      ],
    );
  }

  Widget buildLanguageList() {
    return Column(
      children: [
        buildText('Add a language', 16, FontWeight.normal),
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
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'End year',
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
      value: _selectedLanguage,
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: _languages.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedLanguage = value!;
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
      value: _selectedLanguageLevel,
      dropdownColor: Colors.white,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      items: _languageLevels.map((String languageLevel) {
        return DropdownMenuItem<String>(
          value: languageLevel,
          child: Text(languageLevel),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedLanguageLevel = value!;
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
    return IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined));
  }

  Widget buildCenterText(String text, double fontSize, FontWeight fontWeight) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget buildText(String text, double fontSize, FontWeight fontWeight,
      [Color? color]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  // dropdownmenu widget
  Widget buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: _selectedTechStack,
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
          _selectedTechStack = value!;
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

  Future<List<TechStack>> getTechStack() async {
    var response =
        await Connection.getRequest('/api/techstack/getAllTechStack', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      print(responseDecoded['result']);
      for (var tech in responseDecoded['result']) {
        _TechStackList.add(TechStack.fromJson(tech));
      }
      return _TechStackList;
    } else {
      throw Exception('Failed to load techstack');
    }
  }

  Future<List<SkillSet>> getSkillSet() async {
    var response =
        await Connection.getRequest('/api/skillset/getAllSkillSet', {});
    var responseDecoded = jsonDecode(response);

    if (responseDecoded['result'] != null) {
      print(responseDecoded['result']);
      for (var skill in responseDecoded['result']) {
        _SkillSetList.add(SkillSet(name: skill['name']));
      }
      return _SkillSetList;
    } else {
      throw Exception('Failed to load skillset');
    }
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
                (skillset) => buildSkillsetButton(skillset.name!)).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildSkillsetButton(String skillsetName) {
    bool isSelected = false;

    return TextButton(
      onPressed: () {
        isSelected = !isSelected;
        if (isSelected) {
          _selectedSkillSet.add(skillsetName);
        } else {
          _selectedSkillSet.remove(skillsetName);
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
              return Colors.blue[400]!;
            }
            return Colors.grey[400]!;
          },
        ),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Text(
        skillsetName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
