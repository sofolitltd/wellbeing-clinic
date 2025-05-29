import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/mood.dart';
import 'model/mood_entry_model.dart';
import 'mood_emotion.dart';
import 'mood_note.dart';
import 'mood_selection.dart';

class AddMoodFlowScreen extends StatefulWidget {
  const AddMoodFlowScreen({super.key, this.selectedMood, this.selectedDate});

  final Mood? selectedMood;
  final DateTime? selectedDate;

  @override
  State<AddMoodFlowScreen> createState() => _AddMoodFlowScreenState();
}

class _AddMoodFlowScreenState extends State<AddMoodFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Mood _selectedMood = Mood.veryHappy;
  DateTime _selectedDate = DateTime.now();
  List<String> _selectedActivities = [];
  List<String> _selectedPeople = [];
  List<String> _selectedPlaces = [];
  String _notes = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMood != null) {
      _selectedMood = widget.selectedMood!;
    }
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitMood() async {
    setState(() => _isSaving = true);

    final moodEntry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      title: _selectedMood.title,
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

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _submitMood();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
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
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //
                    MoodSelectionPage(
                      selectedMood: _selectedMood,
                      selectedDate: _selectedDate,
                      onMoodSelected: (mood) =>
                          setState(() => _selectedMood = mood),
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                    ),

                    //
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

                    //
                    NotesPage(
                      initialNotes: _notes,
                      onNotesChanged: (val) => _notes = val,
                    ),
                  ],
                ),
              ),
              //
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving ? null : _previousPage,
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: _currentPage > 0 ? 2 : 1,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
