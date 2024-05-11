import 'package:flutter/material.dart';
import 'dashBoard/SdashBoard.dart';
import 'dashBoard/TempCDashBoard.dart';
import 'projects/projects.dart';
import 'message/message.dart';
import 'alerts/alerts.dart';
import '/components/controller.dart';
import '/components/modelController.dart';
import '/components/appbar.dart';

class TabsPage extends StatefulWidget {
  final int index;

  const TabsPage({super.key, required this.index});

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
    TabInfo(page: ProjectsPage(role: modelController.user.roles[0]), label: 'Projects', icon: Icons.list_alt),
    TabInfo(
        page: modelController.user.roles[0] == 1
            ? CompanyDashboardPage()
            : StudentDashboardPage(),
        label: 'Dashboard',
        icon: Icons.dashboard),
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
      appBar: const CustomAppBar(backWard: false),
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
