import 'package:flutter/material.dart';

import '../../../../components/appbar.dart';
import '../../../../components/decoration.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(backWard: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: buildText('Project Detail', 24, FontWeight.bold, Colors.blueAccent),
            ),
            Container(
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(
                    child: Text('Proposal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: Text('Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: Text('Message',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: Text('Hired',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        
                      ],
                    ),
                  ),
                  // Tab 2
                  Container(
                    child: Column(
                      children: [
                        // Nội dung tab 2
                      ],
                    ),
                  ),
                  // Tab 3
                  Container(
                    child: Column(
                      children: [
                        // Nội dung tab 3
                      ],
                    ),
                  ),
                  // Tab 4
                  Container(
                    child: Column(
                      children: [
                        // Nội dung tab 4
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
