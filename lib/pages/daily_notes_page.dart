import 'package:flutter/material.dart';

import '../models/note.dart';

class DailyNotesPage extends StatelessWidget {
  final List<Note> notes;
  final Function(String title, String content, DateTime date) onAdd;
  final Function(Note note, String title, String content, DateTime date)
  onUpdate;
  final Function(String id) onDelete;
  final Function(Note note) onToggle;

  const DailyNotesPage({
    super.key,
    required this.notes,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggle,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _showNoteForm(BuildContext context, {Note? existingNote}) {
    final titleController = TextEditingController(
      text: existingNote?.title ?? '',
    );
    final contentController = TextEditingController(
      text: existingNote?.content ?? '',
    );
    DateTime selectedDate = existingNote?.date ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                // Mencegah keyboard HP menutupi kolom input
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existingNote == null ? 'Tambah Catatan' : 'Edit Catatan',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Catatan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Isi Catatan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tanggal: ${_formatDate(selectedDate)}'),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text('Pilih Tanggal'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      final content = contentController.text.trim();
                      if (title.isEmpty) return;

                      if (existingNote == null) {
                        onAdd(title, content, selectedDate);
                      } else {
                        onUpdate(existingNote, title, content, selectedDate);
                      }
                      Navigator.pop(ctx);
                    },
                    child: Text(existingNote == null ? 'Simpan' : 'Update'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      contentController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Harian')),
      body: notes.isEmpty
          ? const Center(
              child: Text('Belum ada catatan. Tekan + untuk menambah.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Checkbox(
                      value: note.isDone,
                      onChanged: (_) => onToggle(note),
                    ),
                    title: Text(
                      note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: note.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (note.content.isNotEmpty) Text(note.content),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(note.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () =>
                              _showNoteForm(context, existingNote: note),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => onDelete(note.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
