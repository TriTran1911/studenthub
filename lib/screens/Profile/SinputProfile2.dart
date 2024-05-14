import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/components/decoration.dart';
import '../../connection/server.dart';
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
  List<Experience> experiences = [];

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> postExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');

    var data = {
      "experience": experiences
          .map((e) => {
                "id": null,
                "title": e.title,
                "description": e.description,
                "startMonth": e.startMonth,
                "endMonth": e.endMonth,
                "skillSets": e.skillSets!.map((e) => e.id.toString()).toList(),
              })
          .toList(),
    };

    try
    {
      await Connection.putRequest('/api/experience/updateByStudentId/$studentId', data);
      print('Experience posted');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              for (var experience in experiences) ...[
                buildProjectContainer(experience, context),
                const SizedBox(height: 16.0),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // postExperience();
                        moveToPage(const StudentInputProfile3(), context);
                      },
                      style: buildButtonStyle(Colors.blue[400]!),
                      child:
                          buildText('Next', 16, FontWeight.bold, Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildProjectContainer(Experience experience, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText(experience.title!, 20, FontWeight.bold),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  editRemoveButtons(context, experience),
                  IconButton(
                    icon: const Icon(Icons.delete_outlined, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        experiences.remove(experience);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          buildText('${experience.startMonth!} - ${experience.endMonth!}', 16,
              FontWeight.normal, Colors.grey[600]),
          const SizedBox(height: 16.0),
          buildText(
              experience.description!, 16, FontWeight.bold, Colors.grey[600]),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            direction: Axis.horizontal, // main axis (rows or columns)
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: buildText('Skillset:', 20, FontWeight.bold),
              ),
              for (var skill in experience.skillSets!) ...[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: buildText(
                      skill.name!, 20, FontWeight.normal, Colors.blueAccent),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconButton editRemoveButtons(BuildContext context, Experience experience) {
    return IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController =
                  TextEditingController(text: experience.title);
              TextEditingController descriptionController =
                  TextEditingController(text: experience.description);
              TextEditingController startMonthController =
                  TextEditingController(text: experience.startMonth);
              TextEditingController endMonthController =
                  TextEditingController(text: experience.endMonth);
              _selectedSkillSet = List.from(experience.skillSets!);
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCenterText(
                          'Edit Project', 24, FontWeight.bold, Colors.blue),
                      const SizedBox(height: 16.0),
                      TextField(
                        style: const TextStyle(fontSize: 18.0),
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      buildText('Skillset', 20, FontWeight.bold),
                      const SizedBox(height: 16.0),
                      Container(
                        height: 200,
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
                              children: widget.skillSetList
                                  .map((SkillSet skillSet) =>
                                      buildSkillsetButton(skillSet))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 18.0),
                              controller: startMonthController,
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 18.0),
                              controller: endMonthController,
                              decoration: const InputDecoration(
                                labelText: 'End Date',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        style: const TextStyle(fontSize: 18.0),
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty ||
                              startMonthController.text.isEmpty ||
                              endMonthController.text.isEmpty ||
                              descriptionController.text.isEmpty ||
                              _selectedSkillSet.isEmpty) {
                            _showValidationError(
                                context, 'You must fill all fields');
                          } else {
                            setState(() {
                              experience.title = titleController.text;
                              experience.startMonth = startMonthController.text;
                              experience.endMonth = endMonthController.text;
                              experience.description =
                                  descriptionController.text;
                              experience.skillSets =
                                  List.from(_selectedSkillSet);
                            });
                            titleController.clear();
                            startMonthController.clear();
                            endMonthController.clear();
                            descriptionController.clear();
                            _selectedSkillSet.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        style: buildButtonStyle(Colors.blue[400]!),
                        child: buildText(
                            'Edit', 16, FontWeight.bold, Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCenterText(
                              'Add Project', 24, FontWeight.bold, Colors.blue),
                          const SizedBox(height: 16.0),
                          buildTextField('Title', 1, 1),
                          const SizedBox(height: 16.0),
                          buildText('Skillset', 20, FontWeight.bold),
                          const SizedBox(height: 16.0),
                          Container(
                            height: 200,
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
                                  children: widget.skillSetList
                                      .map((SkillSet skillSet) =>
                                          buildSkillsetButton(skillSet))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField('Start date', 1, 3),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: buildTextField('End date', 1, 4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          buildTextField('Description', 5, 2),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // check all fields are filled and check if the start date is before the end date
                                  // and they are mm-YYYY format
                                  if (_titleController.text.isEmpty ||
                                      _startDateController.text.isEmpty ||
                                      _endDateController.text.isEmpty ||
                                      _descriptionController.text.isEmpty ||
                                      _selectedSkillSet.isEmpty) {
                                    _showValidationError(
                                        context, 'You must fill all fields');
                                  } else {
                                    setState(() {
                                      experiences.add(Experience(
                                        title: _titleController.text,
                                        startMonth: _startDateController.text,
                                        endMonth: _endDateController.text,
                                        description:
                                            _descriptionController.text,
                                        skillSets: List.from(_selectedSkillSet),
                                      ));
                                    });
                                    _titleController.clear();
                                    _startDateController.clear();
                                    _endDateController.clear();
                                    _descriptionController.clear();
                                    _selectedSkillSet.clear();
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: buildButtonStyle(Colors.blue[400]!),
                                child: buildText(
                                    'Add', 16, FontWeight.bold, Colors.white),
                              ),
                            ],
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

  void _showValidationError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.red[900],
          title: const Icon(
            Icons.error,
            size: 50.0,
            color: Colors.red,
          ),
          content: Text(message, style: const TextStyle(fontSize: 24.0)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: buildText('OK', 16, FontWeight.bold, Colors.red),
            ),
          ],
        );
      },
    );
  }

  TextField buildTextField(String label, int maxLines, int type) {
    return TextField(
      style: const TextStyle(fontSize: 18.0),
      controller: type == 1
          ? _titleController
          : type == 2
              ? _descriptionController
              : type == 3
                  ? _startDateController
                  : _endDateController,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        // set size of label text
        labelStyle: const TextStyle(fontSize: 18.0),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
