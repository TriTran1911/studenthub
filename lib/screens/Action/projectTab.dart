import 'package:flutter/material.dart';
import '/components/proposer.dart';
import '/components/appbar.dart';
import '/components/project.dart';
import '/components/projectDetail.dart';

class ProposalsPage extends StatelessWidget {
  Project project;

  ProposalsPage({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _buildDefaultTabController(),
    );
  }

  DefaultTabController _buildDefaultTabController() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          SizedBox(height: 16), // Add space above the title
          Text(
            project.title, // Add your project name here
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Add space below the title
          TabBar(
            tabs: [
              Tab(text: 'Proposals'),
              Tab(text: 'Detail'),
              Tab(text: 'Message'),
              Tab(text: 'Hired'),
            ],
          ),
          SizedBox(height: 16), // Add space below the tab bar (optional
          Expanded(
            child: TabBarView(
              children: [
                ProposalsTab(),
                DetailTab(project: project),
                MessageTab(),
                HiredTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProposalsTab extends StatefulWidget {
  @override
  _ProposalsTabState createState() => _ProposalsTabState();
}

class _ProposalsTabState extends State<ProposalsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void hireProposer(int index) {
    setState(() {
      Proposer.proposers[index] = Proposer(
        name: Proposer.proposers[index].name,
        position: Proposer.proposers[index].position,
        coverLetter: Proposer.proposers[index].coverLetter,
        isHired: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: Proposer.proposers.length,
      itemBuilder: (context, index) {
        final proposer = Proposer.proposers[index];
        return ListTile(
          contentPadding: EdgeInsets.all(16), // Add padding for better spacing
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 48), // Add the icon
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proposer.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)), // Name
                      Text(proposer.position), // Position
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                proposer.coverLetter,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle message button press
                      },
                      child: Text(
                        'Message',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!proposer.isHired) {
                          _showHireConfirmationDialog(
                              context, proposer.name, index);
                        } else {
                          // Send hired offer logic goes here
                        }
                      },
                      child: Text(
                        proposer.isHired ? 'Sent hired offer' : 'Hire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHireConfirmationDialog(
      BuildContext context, String proposerName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hired offer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Do you really want to send hired offer for student $proposerName to due to this project?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // set proposer.isHired to true
                hireProposer(index);
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}

class MessageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Message Tab'),
    );
  }
}

class HiredTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hired Tab'),
    );
  }
}
