import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas13_flutter/pages/login_page.dart';
import 'package:tugas13_flutter/pages/settings.dart';
import '../db/db_helper.dart';
import '../models/note.dart';
import '../pages/edit_note_page.dart';
import '../widgets/menu_section.dart';
import '../widgets/menu_item.dart';
import '../widgets/note_card.dart';
import '../widgets/chat_input.dart';
import '../widgets/account_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  List<Note> notes = [];
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchNotes();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
      userEmail = prefs.getString('user_email') ?? '';
    });
  }

  void fetchNotes() async {
    final fetchedNotes = await dbHelper.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: AppBar(
            backgroundColor: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "x",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                  onPressed: () => showAccountBottomSheet(context, () => logout(context)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'Upgrade plan', child: Text('Upgrade plan')),
                  PopupMenuItem(value: 'Members', child: Text('Members')),
                  PopupMenuItem(value: 'settings', child: Text('Settings')),
                  PopupMenuItem(value: 'Trash', child: Text('Trash')),
                  PopupMenuItem(value: 'Help & support', child: Text('Help & support')),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70), // space for chat input
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Horizontal notes
                notes.isEmpty
                    ? const Center(child: Text(''))
                    : SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
                              ).then((_) => fetchNotes()),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 30),
                // Private section
                MenuSection(
                  title: "Private",
                  items: notes.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "No pages inside",
                              style: TextStyle(
                                color: Color.fromARGB(255, 201, 201, 201),
                                fontSize: 15,
                              ),
                            ),
                          )
                        ]
                      : notes
                          .map((note) => MenuItem(
                                icon: Icons.note,
                                title: note.title,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
                                ).then((_) => fetchNotes()),
                              ))
                          .toList(),
                ),
                const SizedBox(height: 50),
                // Browse templates
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/ghostBackground_FC#TemplateBrowserButton_1_29_19243931533.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/Icon_1_30_image.png", width: 24, height: 24),
                      const SizedBox(width: 8),
                      const Text(
                        "Browse templates",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Chat AI input fixed at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ChatInput(
              onSend: (text) {
                // aksi saat send chat AI
                print("Send AI: $text");
              },
            ),
          ),
        ],
      ),
    );
  }
}
