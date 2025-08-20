import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  const EditNotePage({super.key, required this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final DBHelper dbHelper = DBHelper();
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  void updateNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title dan content tidak boleh kosong')),
      );
      return;
    }

    final updatedNote = Note(
      id: widget.note.id,
      title: title,
      content: content,
    );

    await dbHelper.updateNote(updatedNote);
    Navigator.pop(context);
  }

  void deleteNote() async {
    if (widget.note.id != null) {
      await dbHelper.deleteNote(widget.note.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            onPressed: deleteNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 15,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: updateNote, child: const Text('Update')),
          ],
        ),
      ),
    );
  }
}
