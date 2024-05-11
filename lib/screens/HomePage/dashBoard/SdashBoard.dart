import 'dart:convert';

import 'package:flutter/material.dart';
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
    for (Proposal proposal in proposalList) {
      if (proposal.statusFlag == 0) {
        submittedProposalList.add(proposal);
      } else if (proposal.statusFlag == 1) {
        activeProposalList.add(proposal);
      } else if (proposal.statusFlag == 2) {
        workingProposalList.add(proposal);
      } else {
        achievedProposalList.add(proposal);
      }
    }
    setState(() {}); // Call setState to update the UI after the data is fetched
  }

  Future<List<Proposal>> fetchProposal() async {
    int studentId = User.id;

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
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load projects');
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildText('Your Projects', 20, FontWeight.bold),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: buildText(
                        'Post a job', 20, FontWeight.bold, Colors.white),
                  )
                ],
              ),
            ),
            bottom: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text('All Projects',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Working',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Achieved',
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
                    // delay expand
                    visualDensity: VisualDensity.standard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.blueAccent[200],
                    collapsedBackgroundColor: Colors.blueAccent[400],
                    title: buildText(
                        'Active proposal', 20, FontWeight.bold, Colors.white),
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
                            child: CircularProgressIndicator(),
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
                            title: buildText('Submitted proposal', 20,
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
            buildTabPage(workingProposalList),
            buildTabPage(achievedProposalList),
          ],
        ),
      ),
    );
  }

  Padding buildTabPage(List<Proposal> proposalList) {
    return Padding(
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
            title: buildText(
                'Working proposal', 20, FontWeight.bold, Colors.white),
            children: <Widget>[
              buildCards(proposalList),
            ],
          ),
        ],
      ),
    );
  }

  ListView buildCards(List<Proposal> proposalList) {
    if (proposalList.isEmpty) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          Center(
            child: buildText(
                'No project found\n', 16, FontWeight.bold, Colors.white),
          ),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: proposalList.length,
        itemBuilder: (context, index) {
          Project pro = proposalList[index].project;
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
                                ? monthDif(
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Colors.blue,
                          ),
                          buildText(
                              pro.projectScopeFlag == 0
                                  ? 'Less than 1 month'
                                  : pro.projectScopeFlag == 1
                                      ? '1 to 3 months'
                                      : pro.projectScopeFlag == 2
                                          ? '3 to 6 months'
                                          : 'More than 6 months',
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
                              pro.numberOfStudents == 1
                                  ? '${pro.numberOfStudents} student'
                                  : '${pro.numberOfStudents} students',
                              14,
                              FontWeight.normal,
                              Colors.black),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.assignment,
                            color: Colors.blue,
                          ),
                          buildText(
                              pro.countProposals == 1
                                  ? '${pro.countProposals.toString()} proposal'
                                  : '${pro.countProposals.toString()} proposals',
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
