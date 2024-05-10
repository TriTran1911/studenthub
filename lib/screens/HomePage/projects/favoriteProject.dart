import 'package:flutter/material.dart';
import 'package:studenthub/components/appbar.dart';
import 'package:studenthub/components/controller.dart';
import 'package:studenthub/components/modelController.dart';
import 'package:studenthub/screens/HomePage/projects/TempProjectDetail.dart';
import 'package:studenthub/screens/HomePage/tabs.dart';
import '../../../components/decoration.dart';
import '../../../connection/server.dart';

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
                          moveToPage(TabsPage(index: 0), context);
                        },
                      ),
                  buildCenterText('Favorite Projects', 24, FontWeight.bold, Colors.blueAccent),
                ],
              ),
              const SizedBox(height: 16),
              buildCards(),
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
                      // if role is student show the icon
                      IconButton(
                        icon: Icon(
                          pro.isFavorite!
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: pro.isFavorite! ? Colors.red : Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            pro.isFavorite = !pro.isFavorite!;
                            Connection().setFavorite(pro.id!, pro.isFavorite! ? 0 : 1, context);
                          });
                        },
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

  String monthDif(DateTime? createdAt) {
    final Duration difference = DateTime.now().difference(createdAt!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1) {
        return '${difference.inMinutes} minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        return '${difference.inHours} hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays < 30) {
      if (difference.inDays == 1) {
        return '${difference.inDays} day ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } else if (difference.inDays < 365) {
      final int months = difference.inDays ~/ 30;
      if (months == 1) {
        return '$months month ago';
      } else {
        return '$months months ago';
      }
    } else {
      final int years = difference.inDays ~/ 365;
      if (years == 1) {
        return '$years year ago';
      } else {
        return '$years years ago';
      }
    }
  }
}
