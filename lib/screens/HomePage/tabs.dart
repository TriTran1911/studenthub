import 'package:flutter/material.dart';
import '/screens/HomePage/dashBoard/studentDashBoard.dart';
import 'projects/projects.dart';
// import 'dashBoard/dashboard.dart';
import 'message/message.dart';
import 'alerts/alerts.dart';
import '/components/controller.dart';
import '/components/appbar.dart';
import 'dashBoard/studentDashboard.dart';

class TabsPage extends StatefulWidget {
  final int index;

  TabsPage({required this.index});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }
   
  final List<TabInfo> _tabs = [
    TabInfo(page: ProjectsPage(), label: 'Projects', icon: Icons.folder),
    TabInfo(page: StudentDashboardPage(), label: 'Dashboard', icon: Icons.dashboard),
    //TabInfo(page: DashboardPage(), label: 'Dashboard', icon: Icons.dashboard),
    TabInfo(page: MessagePage(), label: 'Message', icon: Icons.chat),
    TabInfo(page: AlertsPage(), label: 'Alerts', icon: Icons.notifications),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _tabs[_selectedIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs.map((tab) => _buildBottomNavigationBarItem(tab)).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(TabInfo tab) {
    return BottomNavigationBarItem(
      icon: Icon(tab.icon),
      label: tab.label,
    );
  }
}
