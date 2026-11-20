class Note {
  final String id;
  String title;
  String content;
  DateTime date;
  bool isDone;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.isDone = false,
  });
}
