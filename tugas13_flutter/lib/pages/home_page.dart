import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/note.dart';
import 'edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    final fetchedNotes = await dbHelper.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          notes.isEmpty
              ? const Center(child: Text('No notes yet'))
              : SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditNotePage(note: note),
                            ),
                          ).then((_) => fetchNotes());
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 15),
                          child: Card(
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      note.content,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(color: Colors.grey[50]),
            child: _buildMenuSection("Private", [
              _buildMenuItem(
                Icons.insert_drive_file,
                "Getting Started on Mobile",
                () {
                  debugPrint("Clicked Getting Started on Mobile");
                },
              ),
              _buildMenuItem(Icons.checklist, "Habit Tracker", () {
                debugPrint("Clicked Habit Tracker");
              }),
              _buildMenuItem(Icons.list, "Weekly To-do List", () {
                debugPrint("Clicked Weekly To-do List");
              }),
              _buildMenuItem(Icons.person, "Personal Website", () {
                debugPrint("Clicked Personal Website");
              }),
              SizedBox(height: 25),
              Row(
                children: [
                  Icon(Icons.more_horiz, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "View more",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 50),
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/Icon_1_30_image.png",
                  width: 24,
                  height: 24,
                ),
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
    );
  }
}

Widget _buildMenuSection(String title, List<Widget> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          const Icon(Icons.add, color: Colors.grey, size: 20),
        ],
      ),
      const SizedBox(height: 12),
      ...items,
    ],
  );
}

Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
            ),
            const Spacer(),
            const Icon(Icons.more_horiz, color: Colors.grey),
            SizedBox(width: 10),
            const Icon(Icons.add, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}
