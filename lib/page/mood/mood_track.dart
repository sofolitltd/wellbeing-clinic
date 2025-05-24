import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/set_tab_title.dart';

enum Mood {
  veryHappy('😄', Colors.green, 5),
  happy('🙂', Colors.lightGreen, 4),
  neutral('😐', Colors.grey, 3),
  sad('🙁', Colors.blue, 2),
  verySad('😢', Colors.indigo, 1),
  anxious('😟', Colors.deepPurple, 2),
  angry('😠', Colors.red, 2),
  tired('😩', Colors.brown, 2),
  sick('🤒', Colors.teal, 2),
  calm('😌', Colors.cyan, 4);

  final String emoji;
  final Color color;
  final int score;

  const Mood(this.emoji, this.color, this.score);
}

var auth = FirebaseAuth.instance;
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
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       final user = FirebaseAuth.instance.currentUser;
          //       if (user == null) return;
          //
          //       final userId = user.uid;
          //       final moodsRef = FirebaseFirestore.instance
          //           .collection('users')
          //           .doc(userId)
          //           .collection('moods');
          //
          //       final now = DateTime.now();
          //       final random = Random();
          //
          //       for (int i = 0; i < 10; i++) {
          //         final randomDay =
          //             DateTime(now.year, now.month, 1 + random.nextInt(28));
          //         final moodScore = 1 + random.nextInt(5);
          //
          //         final mood = Mood.values[random.nextInt(Mood.values.length)];
          //         final emoji = mood.emoji;
          //
          //         MoodEntry moodEntry = MoodEntry(
          //           id: DateTime.now().millisecondsSinceEpoch.toString(),
          //           date: Timestamp.fromDate(randomDay).toDate(),
          //           mood: mood.name,
          //           emoji: emoji,
          //           score: moodScore,
          //           notes: 'notes',
          //           activities: [],
          //           people: [],
          //           places: [],
          //         );
          //         await moodsRef.add(moodEntry.toFirestore());
          //       }
          //
          //       debugPrint("✅ Demo mood data added.");
          //     },
          //     icon: Icon(Icons.upcoming)),

          // if (_currentUserId != null)
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: Center(
          //       child: Text(
          //         'ID: $_currentUserId',
          //         style: const TextStyle(fontSize: 12, color: Colors.black54),
          //       ),
          //     ),
          //   ),
        ],
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 250,
                  child: MoodMonthlyChart(userId: _currentUserId),
                ),
              ),
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

//
class MoodEntryCard extends StatelessWidget {
  final MoodEntry entry;

  const MoodEntryCard(BuildContext context, {super.key, required this.entry});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
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
                    entry.mood.capitalize(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(entry.date),
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
    );
  }
}

class AddMoodFlowScreen extends StatefulWidget {
  const AddMoodFlowScreen({super.key, this.selectedMood});

  final Mood? selectedMood;

  @override
  State<AddMoodFlowScreen> createState() => _AddMoodFlowScreenState();
}

class _AddMoodFlowScreenState extends State<AddMoodFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Mood _selectedMood = Mood.veryHappy;
  List<String> _selectedActivities = [];
  List<String> _selectedPeople = [];
  List<String> _selectedPlaces = [];
  String _notes = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMood != null) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _submitMood() async {
    setState(() => _isSaving = true);

    final moodEntry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      mood: _selectedMood.name,
      emoji: _selectedMood.emoji,
      score: _selectedMood.score,
      activities: _selectedActivities,
      people: _selectedPeople,
      places: _selectedPlaces,
      notes: _notes,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('moods')
          .add(moodEntry.toFirestore());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading mood: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  void _nextPage() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await _submitMood();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mood'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MoodSelectionPage(
                      selectedMood: _selectedMood,
                      onMoodSelected: (mood) =>
                          setState(() => _selectedMood = mood),
                    ),
                    EmotionTriggerPage(
                      selectedActivities: _selectedActivities,
                      selectedPeople: _selectedPeople,
                      selectedPlaces: _selectedPlaces,
                      onActivitiesSelected: (val) =>
                          setState(() => _selectedActivities = val),
                      onPeopleSelected: (val) =>
                          setState(() => _selectedPeople = val),
                      onPlacesSelected: (val) =>
                          setState(() => _selectedPlaces = val),
                    ),
                    NotesPage(
                      initialNotes: _notes,
                      onNotesChanged: (val) => _notes = val,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _nextPage,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : Text(_currentPage < 2 ? 'Next' : 'Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodSelectionPage extends StatelessWidget {
  final Function(Mood) onMoodSelected;
  final Mood selectedMood;

  const MoodSelectionPage({
    super.key,
    required this.onMoodSelected,
    required this.selectedMood,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling right now?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: Mood.values.length,
              itemBuilder: (context, index) {
                final mood = Mood.values[index];
                final isSelected = mood == selectedMood;
                return GestureDetector(
                  onTap: () => onMoodSelected(mood),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? mood.color.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: mood.color, width: 2)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: mood.color.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood.name.capitalize(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmotionTriggerPage extends StatefulWidget {
  final Function(List<String>) onActivitiesSelected;
  final Function(List<String>) onPeopleSelected;
  final Function(List<String>) onPlacesSelected;
  final List<String> selectedActivities;
  final List<String> selectedPeople;
  final List<String> selectedPlaces;

  const EmotionTriggerPage({
    super.key,
    required this.onActivitiesSelected,
    required this.onPeopleSelected,
    required this.onPlacesSelected,
    required this.selectedActivities,
    required this.selectedPeople,
    required this.selectedPlaces,
  });

  @override
  State<EmotionTriggerPage> createState() => _EmotionTriggerPageState();
}

class _EmotionTriggerPageState extends State<EmotionTriggerPage> {
  late List<String> _currentActivities;
  late List<String> _currentPeople;
  late List<String> _currentPlaces;

  final List<String> _allActivities = [
    'Office',
    'Resting',
    'Hobbies',
    'Fitness',
    'Hanging out',
    'Driving',
    'Exciting',
  ];
  final List<String> _allPeople = [
    'By myself',
    'New acquittance',
    'Family',
    'Co-workers',
    'Friends',
    'Pets',
  ];
  final List<String> _allPlaces = [
    'Work',
    'Home',
    'School',
    'University',
    'Commuting',
  ];

  @override
  void initState() {
    super.initState();
    _currentActivities = List.from(widget.selectedActivities);
    _currentPeople = List.from(widget.selectedPeople);
    _currentPlaces = List.from(widget.selectedPlaces);
  }

  void _toggleSelection(
      List<String> list, String item, Function(List<String>) onUpdate) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
      onUpdate(list);
    });
  }

  Widget _buildTagSection({
    required String title,
    required List<String> allTags,
    required List<String> selectedTags,
    required Function(List<String>) onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: allTags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return ChoiceChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                _toggleSelection(selectedTags, tag, onUpdate);
              },
              selectedColor: Colors.green.shade100,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.green[800] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.green : Colors.transparent,
                  width: isSelected ? 1.5 : 0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What triggered your EMOTION',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTagSection(
            title: 'Activity',
            allTags: _allActivities,
            selectedTags: _currentActivities,
            onUpdate: widget.onActivitiesSelected,
          ),
          _buildTagSection(
            title: 'People',
            allTags: _allPeople,
            selectedTags: _currentPeople,
            onUpdate: widget.onPeopleSelected,
          ),
          _buildTagSection(
            title: 'Place',
            allTags: _allPlaces,
            selectedTags: _currentPlaces,
            onUpdate: widget.onPlacesSelected,
          ),
        ],
      ),
    );
  }
}

class NotesPage extends StatelessWidget {
  final Function(String) onNotesChanged;
  final String initialNotes;

  const NotesPage({
    super.key,
    required this.onNotesChanged,
    required this.initialNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anything you want to note',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            '(your feelings, thoughts, music, photos etc.)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          //
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: TextEditingController(text: initialNotes),
              onChanged: onNotesChanged,
              maxLines: 8,
              minLines: 6,
              // expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Write the text...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0),
              ),
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }
}

class MoodEntry {
  final String id;
  final DateTime date;
  final String mood;
  final String emoji;
  final int score;
  final List<String> activities;
  final List<String> people;
  final List<String> places;
  final String notes;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
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
      'mood': mood,
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
      mood: data['mood'] as String,
      emoji: data['emoji'] as String,
      score: data['score'] as int,
      activities: List<String>.from(data['activities'] ?? []),
      people: List<String>.from(data['people'] ?? []),
      places: List<String>.from(data['places'] ?? []),
      notes: data['notes'] as String? ?? '',
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class MonthlyMoodChartData {
  final List<FlSpot> spots;
  final double overallAverageScore;

  MonthlyMoodChartData(
      {required this.spots, required this.overallAverageScore});
}

String getEmojiForScore(double score) {
  if (score >= 4.5) return ' Excellent 😄';
  if (score >= 3.5) return ' Good 🙂 ';
  if (score >= 2.5) return ' Neutral 😐 ';
  if (score >= 1.5) return ' Low 🙁 ';
  return 'Poor 😢 ';
}

//

class MoodMonthlyChart extends StatelessWidget {
  final String? userId;

  const MoodMonthlyChart({super.key, required this.userId});

  Stream<MonthlyMoodChartData> _streamMonthlyMoodData() {
    if (userId == null) {
      print("Error: userId is null. Cannot stream mood data.");
      return const Stream.empty();
    }

    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);

    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0).day;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThan: startOfNextMonth)
        .snapshots()
        .map((snapshot) {
      final moodData = <int, List<int>>{};
      double totalScoresSum = 0;
      int totalScoresCount = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final score = data['score'] as int?;

        if (timestamp != null && score != null) {
          final date = timestamp.toDate();
          final day = date.day;

          moodData.putIfAbsent(day, () => []);
          moodData[day]!.add(score);

          totalScoresSum += score;
          totalScoresCount++;
        }
      }

      final spots = <FlSpot>[];

      for (var day = 1; day <= lastDayOfCurrentMonth; day++) {
        final scores = moodData[day];
        if (scores != null && scores.isNotEmpty) {
          final avgScore = scores.reduce((a, b) => a + b) / scores.length;

          spots.add(FlSpot(day.toDouble(), avgScore));
        }
      }

      final overallAverageScore =
          totalScoresCount > 0 ? totalScoresSum / totalScoresCount : 0.0;

      return MonthlyMoodChartData(
          spots: spots, overallAverageScore: overallAverageScore);
    }).handleError((e) {
      print("Error streaming monthly mood data: $e");

      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MonthlyMoodChartData>(
      stream: _streamMonthlyMoodData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final chartData = snapshot.data;
        final spots = chartData?.spots ?? [];
        final overallAverageScore = chartData?.overallAverageScore ?? 0.0;

        final overallStatusText = overallAverageScore > 0
            ? "Overall Mood for ${DateFormat.MMMM().format(DateTime.now())}: ${getEmojiForScore(overallAverageScore)}"
            : "No mood data for ${DateFormat.MMMM().format(DateTime.now())}";

        return Column(
          children: [
            Divider(
              thickness: .5,
              height: 1,
            ),
            SizedBox(height: 8),
            //
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        dotData: FlDotData(
                          show: true,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.3),
                        ),
                        color: Colors.green,
                        preventCurveOverShooting: true,
                        shadow:
                            const Shadow(color: Colors.black12, blurRadius: 4),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                    minX: 1,
                    maxX: DateTime(
                            DateTime.now().year, DateTime.now().month + 1, 0)
                        .day
                        .toDouble(),
                    minY: 0,
                    maxY: 5,
                  ),
                ),
              ),
            ),

            //
            Text(
              overallStatusText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
