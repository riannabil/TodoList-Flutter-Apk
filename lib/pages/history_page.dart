import 'package:flutter/material.dart';

import '../models/note.dart';

class HistoryPage extends StatelessWidget {
  final List<Note> notes;

  const HistoryPage({super.key, required this.notes});

  // Format key untuk pengelompokan & pengurutan (YYYY-MM-DD)
  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // Format tampilan tanggal ke user (DD/MM/YYYY)
  String _displayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // 1. Kelompokkan catatan berdasarkan tanggal
    final Map<String, List<Note>> groupedNotes = {};
    for (final note in notes) {
      final key = _dateKey(note.date);
      groupedNotes.putIfAbsent(key, () => []).add(note);
    }

    // 2. Urutkan tanggal dari yang paling baru ke terlama
    final sortedKeys = groupedNotes.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Per Hari')),
      body: sortedKeys.isEmpty
          ? const Center(child: Text('Belum ada riwayat catatan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final key = sortedKeys[index];
                final dayNotes = groupedNotes[key]!;
                final completedCount = dayNotes.where((n) => n.isDone).length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _displayDate(dayNotes.first.date),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label: Text(
                                'Selesai: $completedCount/${dayNotes.length}',
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const Divider(),
                        ...dayNotes.map(
                          (note) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  note.isDone
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 20,
                                  color: note.isDone
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: TextStyle(
                                      decoration: note.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
