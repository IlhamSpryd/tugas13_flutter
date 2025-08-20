import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/note.dart';
import 'edit_note_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DBHelper dbHelper = DBHelper();
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    final fetchedNotes = await dbHelper.getNotes();
    setState(() {
      notes = fetchedNotes;
      filteredNotes = fetchedNotes;
    });
  }

  void filterNotes(String query) {
    final filtered = notes.where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      filteredNotes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            onChanged: filterNotes,
          ),
        ),
        Expanded(
          child: filteredNotes.isEmpty
              ? const Center(child: Text('No notes found'))
              : ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
                        ).then((_) => fetchNotes());
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
