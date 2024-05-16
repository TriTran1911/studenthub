import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/decoration.dart';
import '../../../components/modelController.dart';
import '../../../connection/server.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  List<Proposal> proposalList = [];
  List<Proposal> submittedProposalList = [];
  List<Proposal> activeProposalList = [];
  List<Proposal> workingProposalList = [];
  List<Proposal> achievedProposalList = [];
  Future<List<Proposal>>? _proposalFuture;

  @override
  void initState() {
    super.initState();
    _initProposals();
  }

  void _initProposals() async {
    proposalList = await fetchProposal();
    setState(() {
      for (Proposal proposal in proposalList) {
        if (proposal.project!.typeFlag == 0) if (proposal.statusFlag == 0) {
          submittedProposalList.add(proposal);
        } else {
          activeProposalList.add(proposal);
        }
        else if (proposal.project!.typeFlag == 1) {
          workingProposalList.add(proposal);
        } else if (proposal.project!.typeFlag == 2) {
          achievedProposalList.add(proposal);
        }
      }
    });
  }

  Future<List<Proposal>> fetchProposal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt('studentId');
    print('Student ID: $studentId');

    try {
      var response =
          await Connection.getRequest('/api/proposal/project/$studentId', {});
      var responseDecode = jsonDecode(response);

      if (responseDecode['result'] != null) {
        print("Connected to the server successfully");
        print(responseDecode['result']);

        List<Proposal> proposalListAPI =
            Proposal.buildListProposal(responseDecode['result']);

        return proposalListAPI;
      } else {
        print("Failed to connect to the server");
      }
    } catch (e) {
      print("Failed to connect to the server");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildText("project_text21".tr(), 20, FontWeight.bold),
                ],
              ),
            ),
            bottom: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text("project_text7".tr(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text("project_text19".tr(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text("project_text20".tr(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: <Widget>[
                  ExpansionTile(
                    visualDensity: VisualDensity.standard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.blueAccent[200],
                    collapsedBackgroundColor: Colors.blueAccent[400],
                    title: buildText("project_text28".tr(), 20, FontWeight.bold,
                        Colors.white),
                    children: <Widget>[
                      buildCards(activeProposalList),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder(
                      future: _proposalFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ExpansionTile(
                            childrenPadding: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.blueAccent[200],
                            collapsedBackgroundColor: Colors.blueAccent[400],
                            title: buildText("project_text29".tr(), 20,
                                FontWeight.bold, Colors.white),
                            children: <Widget>[
                              buildCards(submittedProposalList),
                            ],
                          );
                        }
                      }),
                ],
              ),
            ),
            buildCards(workingProposalList),
            buildCards(achievedProposalList),
          ],
        ),
      ),
    );
  }

  ListView buildCards(List<Proposal> proposalList) {
    if (proposalList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Center(
            child: buildText("project_text23".tr() + "\n", 16, FontWeight.bold),
          ),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: proposalList.length,
        itemBuilder: (context, index) {
          Project pro = proposalList[index].project!;
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
            surfaceTintColor: Colors.blue,
            margin: const EdgeInsets.all(6),
            shadowColor: Colors.blue,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: buildText(
                            pro.createdAt != null
                                ? timeDif(
                                    DateTime.parse(pro.createdAt!.toString()))
                                : '0', // or some default value
                            16,
                            FontWeight.bold,
                            Colors.blue[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildText(pro.title!, 20, FontWeight.bold, Colors.blue),
                  const SizedBox(height: 10),
                  buildText(
                      pro.description!, 16, FontWeight.normal, Colors.black),
                  const SizedBox(height: 10),
                  Row(
                    //space between
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Colors.blue,
                          ),
                          buildText(
                              pro.projectScopeFlag == 0
                                  ? tr("project_text2")
                                  : pro.projectScopeFlag == 1
                                      ? tr("project_text3")
                                      : pro.projectScopeFlag == 2
                                          ? tr("project_text4")
                                          : tr("project_text5"),
                              14,
                              FontWeight.normal,
                              Colors.black),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            pro.numberOfStudents == 1
                                ? Icons.person_outlined
                                : Icons.people_outlined,
                            color: Colors.blue,
                          ),
                          buildText(
                              pro.numberOfStudents == 1 ||
                                      pro.numberOfStudents == 0
                                  ? '${pro.numberOfStudents} ' +
                                      tr('project_text13')
                                  : '${pro.numberOfStudents} ' +
                                      tr('project_text14'),
                              14,
                              FontWeight.normal,
                              Colors.black),
                        ],
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
}
