//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'model/mood_entry_model.dart';

final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

class MoodEntryCard extends StatelessWidget {
  final MoodEntry entry;

  const MoodEntryCard(BuildContext context, {super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMoodEntryDialog(context, entry),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(
                  entry.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a', 'bn').format(entry.date),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  _showDeleteConfirmation(context, entry.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
void _showMoodEntryDialog(BuildContext context, MoodEntry entry) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with emoji and mood
              Row(
                children: [
                  Text(
                    entry.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.title.capitalizeFirst,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date and score
              Text(
                "Date: ${DateFormat('d MMMM,  hh:mm a').format(entry.date)}",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.indigo[700]),
              ),

              // Activities
              if (entry.activities.isNotEmpty) ...[
                const Divider(height: 20, thickness: 1),
                const Text(
                  'Activities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: entry.activities
                      .map((act) => Chip(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            label: Text(
                              act,
                              style: TextStyle(fontSize: 12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            backgroundColor: Colors.indigo.shade50,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
              ],

// People
              if (entry.people.isNotEmpty) ...[
                const Text(
                  'People',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: entry.people
                      .map((p) => Chip(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            label: Text(
                              p,
                              style: TextStyle(fontSize: 12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            backgroundColor: Colors.green.shade50,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
              ],

              // Places
              if (entry.places.isNotEmpty) ...[
                const Text(
                  'Places',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: entry.places
                      .map((place) => Chip(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            label: Text(
                              place,
                              style: TextStyle(fontSize: 12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            backgroundColor: Colors.orange.shade50,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
              ],

              // Notes
              if (entry.notes.isNotEmpty) ...[
                const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.notes,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

//
void _showDeleteConfirmation(BuildContext context, String entryId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Mood Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (_currentUserId == null) return;

              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUserId)
                    .collection('moods')
                    .doc(entryId)
                    .delete();

                Navigator.of(context).pop(); // Close just the dialog
              } catch (_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error deleting mood entry")),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
