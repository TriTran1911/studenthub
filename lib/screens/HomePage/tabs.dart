import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/theme_provider.dart';
import 'dashBoard/SdashBoard.dart';
import 'dashBoard/CDashBoard.dart';
import 'projects/projects.dart';
import 'message/message.dart';
import 'alerts/alerts.dart';
import '/components/controller.dart';
import '/components/modelController.dart';
import '/components/appbar.dart';

class TabsPage extends StatefulWidget {
  final int index;

  const TabsPage({Key? key, required this.index}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final List<TabInfo> _tabs = [
      TabInfo(
          page: ProjectsPage(role: modelController.user.roles[0]),
          label: tr('tab_text1'),
          icon: Icons.list_alt),
      TabInfo(
          page: modelController.user.roles[0] == 1
              ? const CompanyDashboardPage()
              : const StudentDashboardPage(),
          label: tr('tab_text2'),
          icon: Icons.dashboard),
      TabInfo(page: MessagePage(), label: tr('tab_text3'), icon: Icons.chat),
      TabInfo(
          page: AlertsPage(),
          label: tr('tab_text4'),
          icon: Icons.notifications),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(backWard: false),
      body: _tabs[_selectedIndex].page,
      bottomNavigationBar: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return BottomNavigationBar(
            items: _tabs
                .map((tab) => _buildBottomNavigationBarItem(tab, themeProvider))
                .toList(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: themeProvider.getTheme().scaffoldBackgroundColor,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      TabInfo tab, ThemeProvider themeProvider) {
    return BottomNavigationBarItem(
      icon: Icon(tab.icon),
      label: tab.label,
      backgroundColor: themeProvider.getTheme().scaffoldBackgroundColor,
    );
  }
}
