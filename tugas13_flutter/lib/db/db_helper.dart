import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

/// Helper class untuk mengelola database SQLite
/// - Membuat database & tabel `notes`
/// - Operasi CRUD (Create, Read, Update, Delete) untuk catatan (Note)
class DBHelper {
  static Database? _db;

  /// Getter untuk mengakses database.
  /// Jika database sudah ada, langsung dikembalikan.
  /// Jika belum, maka akan diinisialisasi lewat [initDB].
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  /// Inisialisasi database SQLite dengan nama `notes.db`.
  /// Saat pertama kali dibuat, akan mengeksekusi `CREATE TABLE notes`.
  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  /// Mengambil semua catatan dari tabel `notes`.
  /// Hasilnya dikonversi dari `Map<String, dynamic>` ke model [Note].
  /// Catatan diurutkan descending berdasarkan `id`.
  Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'id DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  /// Menambahkan catatan baru ke tabel `notes`.
  /// Jika ada konflik (misalnya id sama), data akan diganti (replace).
  /// Mengembalikan `int` id row yang dimasukkan.
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Memperbarui catatan yang sudah ada di tabel `notes`
  /// berdasarkan [note.id].
  /// Mengembalikan jumlah row yang ter-update.
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// Menghapus catatan dari tabel `notes` berdasarkan [id].
  /// Mengembalikan jumlah row yang terhapus.
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
