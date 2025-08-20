class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Convert Note ke Map untuk insert/update
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
    };
    if (id != null) {
      map['id'] = id; // hanya ikut kalau ada id
    }
    return map;
  }

  // Convert Map dari DB ke Object Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
