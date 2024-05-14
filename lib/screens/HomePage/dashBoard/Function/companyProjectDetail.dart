import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/screens/HomePage/message/pages/ChatDetailPage.dart';
import 'package:studenthub/screens/HomePage/message/widgets/RecentChatsByProject.dart';

import '../../../../components/appbar.dart';
import '../../../../components/decoration.dart';
import '../../../../components/modelController.dart';
import '../../../../connection/server.dart';

class ProjectDetailPage extends StatefulWidget {
  Project project;

  ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<Proposal> proposalsList = [];
  Future<List<Proposal>>? _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = getProposalList();
  }

  Future<List<Proposal>> getProposalList() async {
    try {
      var response = await Connection.getRequest(
          '/api/proposal/getByProjectId/${widget.project.id}', {});
      var responseDecode = jsonDecode(response);
      print(responseDecode['result']['items']);

      if (responseDecode['result'] != null) {
        List<Proposal> proposalList =
            Proposal.buildListGetByProjectId(responseDecode['result']['items']);

        proposalsList = proposalList;

        return proposalList;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Project pro = widget.project;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomAppBar(backWard: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child:
                  buildText(pro.title!, 24, FontWeight.bold, Colors.blueAccent),
            ),
            buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  buildProposal(),
                  buildDetail(pro),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: RecentChatsByProject(
                            project: widget.project,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Tab 4
                  Column(
                    children: [
                      // Nội dung tab 4
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TabBar buildTabBar() {
    return const TabBar(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      dragStartBehavior: DragStartBehavior.start,
      tabs: [
        Tab(
          child: Text('Proposal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Tab(
          child: Text('Detail',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Tab(
          child: Text('Message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Tab(
          child: Text('Hired',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  FutureBuilder<List<Proposal>> buildProposal() {
    /*senderId: modelController.user.id,
                                              receiverId: proposal.student!.id!,
                                              projectId: widget.project.id!,
                                              senderName:
                                                  modelController.user.fullname,
                                              receiverName:
                                                  proposal.student!.fullname!,*/
    print('senderID: ${modelController.user.id}');
    // print('receiverID: ${proposalsList[0].studentId}');
    print('projectID: ${widget.project.id}');
    print('senderName: ${modelController.user.fullname}');
    // print('receiverName: ${proposalsList[0].student!.fullname}');
    return FutureBuilder(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return ListView.builder(
              itemCount: proposalsList.length,
              itemBuilder: (context, index) {
                Proposal proposal = proposalsList[index];
                Student student = proposalsList[index].student!;
                print('receiverID 222: ${proposal.student!.userId}');
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  surfaceTintColor: Colors.blue,
                  margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  shadowColor: Colors.blue,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: buildText(
                              proposal.createdAt != null
                                  ? timeDif(DateTime.parse(
                                      proposal.createdAt!.toString()))
                                  : '0', // or some default value
                              16,
                              FontWeight.bold,
                              Colors.blue[800]),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_outlined, size: 80),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(
                                      student.fullname!, 20, FontWeight.bold),
                                  buildText(student.techStack!.name!, 20,
                                      FontWeight.normal),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (student.educations!.isNotEmpty) ...[
                          buildText(
                              'Education:', 20, FontWeight.bold, Colors.blue),
                          for (var edu in student.educations!)
                            buildText(
                              '${edu.schoolName} - ${edu.startYear} - ${edu.endYear}',
                              18,
                              FontWeight.normal,
                            )
                        ],

                        const SizedBox(height: 16),
                        buildText(
                            'Cover Letter:', 20, FontWeight.bold, Colors.blue),
                        buildText(
                          addBulletPoints(proposal.coverLetter!),
                          18,
                          FontWeight.normal,
                        ),
                        const SizedBox(height: 16),
                        // two buttons message and hire
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                onPressed: () {
                                  // send message to student
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatDetailPage(
                                              senderId: modelController.user.id,
                                              receiverId:
                                                  proposal.student!.userId!,
                                              projectId: widget.project.id!,
                                              senderName:
                                                  modelController.user.fullname,
                                              receiverName:
                                                  proposal.student!.fullname!,
                                            )),
                                  );
                                },
                                child: buildText('Message', 18, FontWeight.bold,
                                    Colors.black),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                onPressed: () {
                                  // hire student
                                },
                                child: buildText(
                                    'Hire', 18, FontWeight.bold, Colors.black),
                              ),
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
        }
      },
    );
  }

  Column buildDetail(Project pro) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.search_rounded, size: 30),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                          'Student are looking for:', 20, FontWeight.bold),
                      // add bullet point before each row in description
                      buildText(addBulletPoints(pro.description!), 18,
                          FontWeight.normal),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 30),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText('Project scope:', 20, FontWeight.bold),
                      // add bullet point before each row in description
                      buildText(
                          pro.projectScopeFlag == 0
                              ? 'Less than 1 month'
                              : pro.projectScopeFlag == 1
                                  ? '1 to 3 months'
                                  : pro.projectScopeFlag == 2
                                      ? '3 to 6 months'
                                      : 'More than 6 months',
                          18,
                          FontWeight.normal),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    pro.numberOfStudents == 1
                        ? Icons.person_outlined
                        : Icons.people_outlined,
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText('Student required:', 20, FontWeight.bold),
                      // add bullet point before each row in description
                      buildText(
                          pro.numberOfStudents == 1
                              ? '${pro.numberOfStudents} student'
                              : '${pro.numberOfStudents} students',
                          18,
                          FontWeight.normal),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String addBulletPoints(String input) {
    List<String> lines = input.split('\n');
    List<String> bulletPoints = lines.map((line) => '• $line').toList();
    return bulletPoints.join('\n');
  }
}
