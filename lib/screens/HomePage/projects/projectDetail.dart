import 'package:flutter/material.dart';
import '/components/project.dart';
import '/components/appbar.dart';
import 'proposalSubmit.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = Project.isFavorite(widget.project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title ?? "No title",
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Duration: ${widget.project.getProjectScopeAsString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: ${widget.project.getProjectTypeFlagAsString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Created: ${DateTime.now().difference(widget.project.createdAt ?? DateTime.now()).inDays} days ago',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Divider(), // Horizontal line
                    SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (widget.project.description ?? '')
                      .split('\n')
                      .map(
                        (descriptionItem) => Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('• $descriptionItem'),
                        ),
                      )
                      .toList(),

                    ),
                    SizedBox(height: 8),
                    Divider(), // Horizontal line
                    SizedBox(height: 8),
                    Text(
                      'Proposals: ${widget.project.countProposals}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    // Text(
                    //   'Messages: ${widget.project.messages}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // SizedBox(height: 8),
                    // Text(
                    //   'Hired: ${widget.project.hiredCount}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // SizedBox(height: 8),
                    Text(
                      'Students Needed: ${widget.project.numberOfStudents}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time Needed: ${widget.project.getProjectScopeAsString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16), // Add some spacing between the project details and buttons
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToCoverLetterPage(context);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        // color blue
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Apply Now',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        toggleFavorite();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isFavorite ? Color.fromARGB(255, 107, 167, 206) : Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          isFavorite ? 'Saved' : 'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        Project.favoriteProjects.remove(widget.project);
      } else {
        Project.favoriteProjects.add(widget.project);
      }
      isFavorite = !isFavorite;
    });
  }

  void _navigateToCoverLetterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CoverLetterPage(project: widget.project)), 
    );
  }

}
