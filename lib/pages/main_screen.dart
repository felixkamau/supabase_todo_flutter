import 'package:flutter/material.dart';
import 'package:flutter_db/pages/create_task.dart';
import 'package:flutter_db/pages/home_page.dart';
import 'package:flutter_db/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabidx = 0;

  final List<Widget> _pages = [HomePage(), CreateTask(), ProfilePage()];

  void _selectedTab(int index) {
    setState(() {
      _selectedTabidx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTabidx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabidx,
        selectedItemColor: Color.fromRGBO(255, 114, 94, 1),
        unselectedItemColor: Colors.grey[600],
        onTap: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
