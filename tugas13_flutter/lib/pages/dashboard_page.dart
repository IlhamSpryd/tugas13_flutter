import 'package:flutter/material.dart';

import 'add_note_page.dart';
import 'home_page.dart';
import 'inbox_page.dart';
import 'search_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    InboxPage(),
    AddNotePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[50],
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/home.png"),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 24,
              child: Image.asset("assets/images/search.png"),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/inbox.png"),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 25,
              height: 24,
              child: Image.asset("assets/images/edit.png"),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
