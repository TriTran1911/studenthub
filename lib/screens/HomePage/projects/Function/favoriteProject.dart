import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import 'projectDetail.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '../../../../components/decoration.dart';
import '../../../../connection/server.dart';

// ignore: must_be_immutable
class FavoriteProjectsPage extends StatefulWidget {
  List<Project> projects = [];

  FavoriteProjectsPage({super.key, required this.projects});

  @override
  State<FavoriteProjectsPage> createState() => _FavoriteProjectsPageState();
}

class _FavoriteProjectsPageState extends State<FavoriteProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      moveToPage(const TabsPage(index: 0), context);
                    },
                  ),
                  buildCenterText('Favorite Projects', 24, FontWeight.bold,
                      Colors.blueAccent),
                ],
              ),
              const SizedBox(height: 16),
              buildCards()
            ],
          ),
        ),
      ),
    );
  }

  ListView buildCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.projects.length,
      itemBuilder: (context, index) {
        Project pro = widget.projects[index];
        if (pro.isFavorite == true) {
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3,
            surfaceTintColor: Colors.blue,
            margin: const EdgeInsets.all(12),
            shadowColor: Colors.blue,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(pro, context),
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
              onTap: () {
                moveToPage(ProjectDetailPage(project: pro), context);
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Row buildHeader(Project pro, BuildContext context) {
    return Row(
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
                  ? timeDif(DateTime.parse(pro.createdAt!.toString()))
                  : '0', // or some default value
              16,
              FontWeight.bold,
              Colors.blue[800]),
        ),
        // if role is student show the icon
        IconButton(
          icon: Icon(
            pro.isFavorite! ? Icons.bookmark : Icons.bookmark_outline,
            color: pro.isFavorite! ? Colors.red : Colors.blue,
          ),
          onPressed: () {
            setState(() {
              pro.isFavorite = !pro.isFavorite!;
              Connection()
                  .setFavorite(pro.id!, pro.isFavorite! ? 0 : 1, context);
            });
          },
        ),
      ],
    );
  }
}
