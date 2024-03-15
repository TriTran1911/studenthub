import 'package:flutter/material.dart';
import '/components/project.dart';
import '/screens/Action/projectTab.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // count number of time open the page
  late List<Project> workingProjects;
  late List<Project> achievedProjects;

  @override
  void initState() {
    super.initState();

    _updateProjectsList();
  }

  @override
  Widget build(BuildContext context) {
    _updateProjectsList();

    return _buildDefaultTabController();
  }

  DefaultTabController _buildDefaultTabController() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your projects',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            _buildPostJobButton(),
          ],
          bottom: TabBar(
            tabs: [
              _buildTab('All Projects'),
              _buildTab('Working'),
              _buildTab('Achieved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildProjectsList(Project.projects),
            buildProjectsList(workingProjects),
            buildProjectsList(achievedProjects),
          ],
        ),
      ),
    );
  }

  Widget _buildPostJobButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () => _addProject(context),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Post a job',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  void _updateProjectsList() {
    workingProjects = Project.projects
        .where((project) => project.status == 'Working')
        .toList();
    achievedProjects = Project.projects
        .where((project) => project.status == 'Achieved')
        .toList();
  }

  void _addProject(BuildContext context) {}

  Widget buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildProjectsList(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        String durationText;
        if (projects[index].duration == ProjectDuration.oneToThreeMonths) {
          durationText = '1 to 3 months';
        } else {
          durationText = '3 to 6 months';
        }

        // Calculate days since creation
        final daysSinceCreation =
            DateTime.now().difference(projects[index].creationDate).inDays;

        return Column(
          children: [
            ListTile(
              title: Text(
                projects[index].title,
                style: TextStyle(color: Colors.green),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Created $daysSinceCreation days ago'),
                  Text(
                    'Students are looking for:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: projects[index]
                          .description
                          .map((descriptionItem) => Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('• $descriptionItem'),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${projects[index].proposals}'),
                          Text('Proposals'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].messages}'),
                          Text('Messages'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${projects[index].hiredCount}'),
                          Text('Hired'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  _showBottomSheet(context, projects[index]);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProposalsPage(project: projects[index]),
                  ),
                );
              },
            ),
            Divider(
              height: 17,
              color: Colors.grey,
            ),
          ],
        );
      },
    );
  }

  void _removeProject(Project project) {
    setState(() {
      Project.removeProject(project);
    });
  }

  void _showBottomSheet(BuildContext context, Project project) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 430,
          child: Column(
            children: [
              ListTile(
                title: Text('View Proposals',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              ListTile(
                title: Text('View Messages',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              ListTile(
                title: Text('View Hired',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('View job posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              ListTile(
                title: Text('Edit posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
              ListTile(
                title: Text('Remove posting',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {
                  _removeProject(project);
                  Navigator.pop(context);
                },
              ),
              Divider(height: 17, color: Colors.grey),
              ListTile(
                title: Text('Start working this project',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
