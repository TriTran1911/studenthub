import 'package:flutter/material.dart';
import '../../components/appbar.dart';
import 'SprofileInput2.dart';

final List<String> techstackOptions = [
  'Fullstack Engineer',
  'Front-end Developer',
  'Back-end Developer',
  'iOS Developer',
  // Add more techstack options here
];

final List<String> skillsetOptions = [
  'Node.js',
  'Swift',
  'Python',
  'Java',
  'C++',
  'HTML/CSS',
  'MongoDB',
  // Add more skills here
];

final List<String> languageList = [
  'English: Native or Bilingual',
  'Spanish: Fluent',
  'French: Intermediate',
  // Add more languages here
];

List<String> educationList = [
  "Le Hong Phong High School\n2008-2010",
  "Ho Chi Minh University of Sciences\n2010-2014",
  // Add more education entries here
];

class StudentInfoScreen extends StatefulWidget {
  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  String? selectedTechstack;
  List<String> selectedSkillset = [];
  List<String> selectedLanguages = [];

  bool showSkillContainer = false;
  bool anySkillSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Student Hub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tell us about yourself and you will be on your way to connect with real-world projects',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Techstack',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            TechstackSelection(
              selectedTechstack: selectedTechstack,
              onChanged: (String? value) {
                setState(() {
                  selectedTechstack = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Skillset',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  showSkillContainer = !showSkillContainer;
                });
              },
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    anySkillSelected
                        ? selectedSkillset.join(", ")
                        : 'Tap here to select skills',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: anySkillSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            if (showSkillContainer)
              _SkillContainerState(
                skills: skillsetOptions,
                onSelect: (selectedSkills) {
                  setState(() {
                    selectedSkillset = selectedSkills;
                    anySkillSelected = selectedSkillset.isNotEmpty;
                  });
                },
                selectedSkills: selectedSkillset,
              ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Languages',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addLanguage();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editLanguages();
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (String language in languageList)
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            _EducationSection(
              educationList: educationList,
              onAdd: _addEducation,
              onEdit: _editEducation,
              onDelete: _deleteEducation,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StudentInfoScreen2()),
                );
              },
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newLanguage = '';
        return AlertDialog(
          title: Text('Add Language'),
          content: TextField(
            onChanged: (value) {
              newLanguage = value;
            },
            decoration: InputDecoration(hintText: 'Enter language'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  languageList.add(newLanguage);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editLanguages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> editedLanguages = List.from(languageList);
        return AlertDialog(
          title: Text('Edit Languages'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < editedLanguages.length; i++)
                TextField(
                  onChanged: (value) {
                    editedLanguages[i] = value;
                  },
                  decoration: InputDecoration(hintText: 'Enter language'),
                  controller: TextEditingController(text: editedLanguages[i]),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  languageList.clear();
                  languageList.addAll(editedLanguages);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addEducation() {
    String schoolName = '';
    String startYear = '';
    String endYear = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Education'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  schoolName = value;
                },
                decoration: InputDecoration(hintText: 'School Name'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        startYear = value;
                      },
                      decoration: InputDecoration(hintText: 'Start Year'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        endYear = value;
                      },
                      decoration: InputDecoration(hintText: 'End Year'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  educationList.add('$schoolName\n$startYear-$endYear');
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editEducation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedSchoolName = educationList[index].split('\n')[0];
        String editedYears = educationList[index].split('\n')[1];
        String editedStartYear = editedYears.split('-')[0];
        String editedEndYear = editedYears.split('-')[1];

        return AlertDialog(
          title: Text('Edit Education'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  editedSchoolName = value;
                },
                decoration: InputDecoration(hintText: 'School Name'),
                controller: TextEditingController(text: editedSchoolName),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        editedStartYear = value;
                      },
                      decoration: InputDecoration(hintText: 'Start Year'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: editedStartYear),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        editedEndYear = value;
                      },
                      decoration: InputDecoration(hintText: 'End Year'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: editedEndYear),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  educationList[index] =
                      '$editedSchoolName\n$editedStartYear-$editedEndYear';
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEducation(int index) {
    setState(() {
      educationList.removeAt(index);
    });
  }
}

class TechstackSelection extends StatelessWidget {
  final String? selectedTechstack;
  final ValueChanged<String?> onChanged;

  TechstackSelection({
    required this.selectedTechstack,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Choose a techstack',
        border: OutlineInputBorder(),
      ),
      value: selectedTechstack,
      onChanged: onChanged,
      items: techstackOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class _SkillContainerState extends StatefulWidget {
  final List<String> skills;
  final Function(List<String>) onSelect;
  final List<String> selectedSkills;

  _SkillContainerState({
    required this.skills,
    required this.onSelect,
    required this.selectedSkills,
  });

  @override
  __SkillContainerStateState createState() => __SkillContainerStateState();
}

class __SkillContainerStateState extends State<_SkillContainerState> {
  late List<bool> _selectedSkills;

  @override
  void initState() {
    super.initState();
    _selectedSkills = List.generate(widget.skills.length,
        (index) => widget.selectedSkills.contains(widget.skills[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _buildSkillChips(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSkillChips(BuildContext context) {
    List<Widget> chips = [];
    for (int i = 0; i < widget.skills.length; i++) {
      chips.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedSkills[i] = !_selectedSkills[i];
            });
            widget.onSelect(getSelectedSkills());
          },
          child: Chip(
            label: Text(
              widget.skills[i],
              style: TextStyle(
                color: _selectedSkills[i] ? Colors.grey[400] : Colors.white,
                fontWeight:
                    _selectedSkills[i] ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            backgroundColor: _selectedSkills[i] ? Colors.blueGrey : Colors.blue,
            elevation: _selectedSkills[i] ? 0.0 : 2.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
      );
    }
    return chips;
  }

  List<String> getSelectedSkills() {
    List<String> selectedSkills = [];
    for (int i = 0; i < _selectedSkills.length; i++) {
      if (_selectedSkills[i]) {
        selectedSkills.add(widget.skills[i]);
      }
    }
    return selectedSkills;
  }
}

class _EducationSection extends StatelessWidget {
  final List<String> educationList;
  final VoidCallback onAdd;
  final Function(int) onEdit;
  final Function(int) onDelete;

  _EducationSection({
    required this.educationList,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Education',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onAdd,
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < educationList.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        educationList[i],
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => onEdit(i),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onDelete(i),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
