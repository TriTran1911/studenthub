import 'package:flutter/material.dart';
import '/components/proposer.dart';
import '/components/appbar.dart';
import '/components/project.dart';
import '/components/projectDetail.dart';

class ProposalsPage extends StatelessWidget {
  Project project;
  final int initialTabIndex;

  ProposalsPage({required this.project, this.initialTabIndex = 0});

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
      initialIndex: initialTabIndex,
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            project.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          TabBar(
            indicatorColor: Colors.blue,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.blue,
            ),
            tabs: [
              Tab(text: 'Proposals'),
              Tab(text: 'Detail'),
              Tab(text: 'Message'),
              Tab(text: 'Hired'),
            ],
          ),
          SizedBox(height: 16),
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
          contentPadding: EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 48),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proposer.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(proposer.position),
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
                        } else {}
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                hireProposer(index);
                Navigator.of(context).pop();
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
