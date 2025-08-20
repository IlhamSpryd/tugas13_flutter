import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas13_flutter/pages/popup_menu_button/settings.dart';
import 'add_note_page.dart';
import 'home_page.dart';
import 'inbox_page.dart';
import 'login_page.dart';
import 'search_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  String userName = '';
  String userEmail = '';

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    InboxPage(),
    AddNotePage(),
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'example@gmail.com';
    });
    print("Loaded user: $userName, $userEmail");
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: AppBar(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$userName's Notion",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Accounts',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListTile(
                                leading: Image.asset(
                                  "assets/images/add.png",
                                  width: 25,
                                  height: 25,
                                ),
                                title: const Text('Add an account'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Image.asset(
                                  "assets/images/delete.png",
                                  width: 25,
                                  height: 25,
                                ),
                                title: const Text('Logout'),
                                onTap: () {
                                  Navigator.pop(context); 
                                  logout(context); 
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  } else {
                    print('$value tapped');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Upgrade plan',
                    child: Text('Upgrade plan'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Members',
                    child: Text('Members'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Trash',
                    child: Text('Trash'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Help & support',
                    child: Text('Help & support'),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
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
