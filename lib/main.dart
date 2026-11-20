import 'package:flutter/material.dart';

import 'models/note.dart';
import 'pages/daily_notes_page.dart';
import 'pages/history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Study Case',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Data awal (dummy) agar saat aplikasi dibuka langsung terlihat isinya
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Persiapan Masuk Lab Mobile',
      content: 'Review dasar widget tree, StatefulWidget, dan navigasi.',
      date: DateTime.now(),
    ),
    Note(
      id: '2',
      title: 'Setup Environment VS Code',
      content: 'Install Flutter SDK, JDK 17, dan Android Command-Line Tools.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isDone: true,
    ),
  ];

  void _addNote(String title, String content, DateTime date) {
    setState(() {
      _notes.insert(
        0,
        Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          date: date,
        ),
      );
    });
  }

  void _updateNote(
    Note note,
    String newTitle,
    String newContent,
    DateTime newDate,
  ) {
    setState(() {
      note.title = newTitle;
      note.content = newContent;
      note.date = newDate;
    });
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
  }

  void _toggleDone(Note note) {
    setState(() {
      note.isDone = !note.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DailyNotesPage(
        notes: _notes,
        onAdd: _addNote,
        onUpdate: _updateNote,
        onDelete: _deleteNote,
        onToggle: _toggleDone,
      ),
      HistoryPage(notes: _notes),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Catatan Harian',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat Per Hari',
          ),
        ],
      ),
    );
  }
}
