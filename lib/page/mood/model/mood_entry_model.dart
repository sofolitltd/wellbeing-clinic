import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  final String id;
  final DateTime date;
  final String title;
  final String emoji;
  final double score;
  final List<String> activities;
  final List<String> people;
  final List<String> places;
  final String notes;

  MoodEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.emoji,
    required this.score,
    required this.activities,
    required this.people,
    required this.places,
    this.notes = '',
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': title,
      'emoji': emoji,
      'score': score,
      'activities': activities,
      'people': people,
      'places': places,
      'notes': notes,
    };
  }

  factory MoodEntry.fromFirestore(Map<String, dynamic> data, String id) {
    final Timestamp timestamp = data['date'] as Timestamp;

    return MoodEntry(
      id: id,
      date: timestamp.toDate(),
      title: data['mood'] as String,
      emoji: data['emoji'] as String,
      score: data['score'] as double,
      activities: List<String>.from(data['activities'] ?? []),
      people: List<String>.from(data['people'] ?? []),
      places: List<String>.from(data['places'] ?? []),
      notes: data['notes'] as String? ?? '',
    );
  }
}
