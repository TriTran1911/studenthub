import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/components/decoration.dart';
import 'SinputProfile3.dart';
import 'package:studenthub/components/controller.dart';

class StudentInputProfile2 extends StatefulWidget {
  final List<SkillSet> skillSetList;

  const StudentInputProfile2({
    Key? key,
    required this.skillSetList,
  }) : super(key: key);

  @override
  State<StudentInputProfile2> createState() => _StudentInputProfile2State();
}

class _StudentInputProfile2State extends State<StudentInputProfile2> {
  List<SkillSet> _selectedSkillSet = [];

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startDateController.text = DateFormat('dd-MM-yyyy').format(_startDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endDateController.text = DateFormat('dd-MM-yyyy').format(_endDate);
      });
    }
  }

  final List<Project> projects = [
    Project(
      title: 'Project 1',
      subtitle: 'Subtitle 1',
      description:
          'It is the developer of a super-app for ride-hailing, food delivery, and digital payments services on mobile devices that operates in Singapore, Malaysia, ..',
      selectedSkillSet: [
        SkillSet(name: 'Java'),
        SkillSet(name: 'Python'),
        SkillSet(name: 'Dart')
      ],
    ),
    Project(
      title: 'Project 2',
      subtitle: 'Subtitle 2',
      description: 'Description of Project 2',
      selectedSkillSet: [SkillSet(name: 'Dart')],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              buildCenterText('Experiences', 20, FontWeight.bold),
              const SizedBox(height: 16.0),
              buildText(
                  'Tell us about yourself and you will be on your way connect with real-world projects',
                  16,
                  FontWeight.normal),
              const SizedBox(height: 16.0),
              addingProject(),
              const SizedBox(height: 16.0),
              projectCards(),
              const SizedBox(height: 16.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // postProfile();
                    moveToPage(
                        const StudentInputProfile3(), context);
                  },
                  style: buildButtonStyle(Colors.blue[400]!),
                  child: buildText('Next', 16, FontWeight.bold, Colors.white),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToPage(
            const StudentInputProfile3(),
            context,
          );
        },
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: buildText('Next', 16, FontWeight.bold),
      ),
    );
  }

  Widget projectCards() {
    return Column(
      children: List.generate(projects.length, (index) {
        return Card(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          color: Colors.blue[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(projects[index].title, 20, FontWeight.bold),
                    buildText(projects[index].subtitle, 16, FontWeight.normal,
                        Colors.grey[600]),
                  ],
                ),
                iconFunction(index),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(projects[index].description, 16, FontWeight.bold),
                const SizedBox(height: 16.0),
                buildText('Skillset', 20, FontWeight.bold),
                const SizedBox(height: 16.0),
                showSkillSet(projects[index]),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget showSkillSet(Project project) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
            children: project.selectedSkillSet
                .map(
                    (SkillSet skillSet) => buildSkillsetButton(skillSet, false))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildSkillset() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(2.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: widget.skillSetList
                .map((SkillSet skillSet) => buildSkillsetButton(skillSet, true))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildSkillsetButton(SkillSet skillSet, bool edit) {
    bool isSelected = _selectedSkillSet.contains(skillSet);
    return TextButton(
      onPressed: edit
          ? () {
              isSelected = !isSelected;
              if (isSelected) {
                _selectedSkillSet.add(skillSet);
              } else {
                _selectedSkillSet.remove(skillSet);
              }
            }
          : null,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isSelected && edit) {
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

  Row iconFunction(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  // Create controllers for the text fields
                  final titleController =
                      TextEditingController(text: projects[index].title);
                  final descriptionController =
                      TextEditingController(text: projects[index].description);

                  return Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildText('Edit Project', 20, FontWeight.bold),
                          const SizedBox(height: 16.0),
                          buildTextField('Title', 1, 1),
                          const SizedBox(height: 16.0),
                          buildText('Skillset', 20, FontWeight.bold),
                          const SizedBox(height: 16.0),
                          buildSkillset(),
                          const SizedBox(height: 16.0),
                          datePicker(context),
                          const SizedBox(height: 16.0),
                          buildTextField('Description', 5, 2),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              // Update the project
                              setState(() {
                                projects[index].title = titleController.text;
                                projects[index].description =
                                    descriptionController.text;
                                projects[index].selectedSkillSet =
                                    List.from(_selectedSkillSet);
                              });

                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
        IconButton(
          icon: const Icon(Icons.delete_outlined),
          onPressed: () {
            setState(() {
              projects.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  Row addingProject() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildText('Projects', 20, FontWeight.bold),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildText('Add Project', 20, FontWeight.bold),
                          const SizedBox(height: 16.0),
                          buildTextField('Title', 1, 1),
                          const SizedBox(height: 16.0),
                          buildText('Skillset', 20, FontWeight.bold),
                          const SizedBox(height: 16.0),
                          buildSkillset(),
                          const SizedBox(height: 16.0),
                          // start Date and end Date, start date cannot be after end date
                          datePicker(context),
                          const SizedBox(height: 16.0),
                          buildTextField('Description', 5, 2),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              String subtitle =
                                  '${DateFormat('dd-MM').format(_startDate)} - ${DateFormat('dd-MM').format(_endDate)}';
                              int monthsDifference =
                                  _endDate.month - _startDate.month;
                              Project newProject = Project(
                                title: _titleController.text,
                                subtitle:
                                    '$subtitle ($monthsDifference months)',
                                description: _descriptionController.text,
                                selectedSkillSet: List.from(_selectedSkillSet),
                              );
                              setState(() {
                                projects.add(newProject);
                              });

                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      )),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Row datePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectStartDate(context),
            child: IgnorePointer(
              child: TextField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => _selectEndDate(context),
            child: IgnorePointer(
              child: TextField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField buildTextField(String label, int maxLines, int type) {
    return TextField(
      controller: type == 1 ? _titleController : _descriptionController,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class Project {
  String title;
  final String subtitle;
  String description;
  List<SkillSet> selectedSkillSet;

  Project({
    required this.title,
    required this.subtitle,
    required this.description,
    this.selectedSkillSet = const [],
  });
}
