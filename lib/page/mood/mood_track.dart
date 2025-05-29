import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/set_tab_title.dart';
import 'model/mood_entry_model.dart';
import 'mood_chart.dart';
import 'mood_entry.dart';
import 'mood_flow.dart';

final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

class MoodTrackScreen extends StatefulWidget {
  const MoodTrackScreen({super.key});

  @override
  State<MoodTrackScreen> createState() => _MoodTrackScreenState();
}

class _MoodTrackScreenState extends State<MoodTrackScreen> {
  @override
  Widget build(BuildContext context) {
    setTabTitle('Mood - Wellbeing Clinic', context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker',
            style: TextStyle(
                color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddMoodFlowScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Add mood'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Column(
            children: [
              Divider(
                thickness: .5,
                height: 1,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 250,
                  child: MoodMonthlyChart(userId: _currentUserId),
                ),
              ),

              //
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_currentUserId)
                      .collection('moods')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (asyncSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${asyncSnapshot.error}'));
                    }

                    if (!asyncSnapshot.hasData ||
                        asyncSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No mood entries yet!'),
                      );
                    }

                    final moodEntries = asyncSnapshot.data!.docs
                        .map((doc) =>
                            MoodEntry.fromFirestore(doc.data(), doc.id))
                        .toList();

                    final Map<String, List<MoodEntry>> grouped = {};

                    for (final entry in moodEntries) {
                      final dateKey =
                          DateFormat('yyyy-MM-dd').format(entry.date);
                      if (!grouped.containsKey(dateKey)) {
                        grouped[dateKey] = [];
                      }
                      grouped[dateKey]!.add(entry);
                    }

                    final sortedKeys = grouped.keys.toList()
                      ..sort((a, b) => b.compareTo(a));

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        final dateKey = sortedKeys[index];
                        final entries = grouped[dateKey]!;
                        final DateTime date = DateTime.parse(dateKey);
                        final isToday = DateTime.now().year == date.year &&
                            DateTime.now().month == date.month &&
                            DateTime.now().day == date.day;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isToday
                                  ? 'Today - ${DateFormat("d MMM, yy").format(date)}'
                                  : DateFormat("d MMM, yy").format(date),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...entries.map((entry) => MoodEntryCard(
                                  context,
                                  entry: entry,
                                )),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
