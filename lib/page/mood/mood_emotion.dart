import 'package:flutter/material.dart';

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
    'অফিস',
    'বিশ্রাম',
    'শখ',
    'ফিটনেস',
    'বন্ধুদের সঙ্গে আড্ডা',
    'গাড়ি চালানো',
    'রোমাঞ্চকর কিছু',
  ];
  final List<String> _allPeople = [
    'একাই',
    'নতুন পরিচিত',
    'পরিবার',
    'সহকর্মী',
    'বন্ধুরা',
    'পোষা প্রাণী',
  ];
  final List<String> _allPlaces = [
    'কাজের জায়গা',
    'বাড়ি',
    'স্কুল',
    'বিশ্ববিদ্যালয়',
    'যাতায়াতকালীন',
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

  Future<void> _showAddDialog({
    required String title,
    required Function(String) onAdd,
  }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'নতুন আইটেম লিখুন'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onAdd(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('যোগ করুন'),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSection({
    required String title,
    required List<String> allTags,
    required List<String> selectedTags,
    required Function(List<String>) onUpdate,
    required VoidCallback onAddCustom,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: onAddCustom,
            )
          ],
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
              onSelected: (_) => _toggleSelection(selectedTags, tag, onUpdate),
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
            'আপনার অনুভূতির কারণ কী?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTagSection(
            title: 'দৈনন্দিন কাজ',
            allTags: _allActivities,
            selectedTags: _currentActivities,
            onUpdate: widget.onActivitiesSelected,
            onAddCustom: () => _showAddDialog(
              title: 'নতুন কাজ যুক্ত করুন',
              onAdd: (newTag) {
                setState(() {
                  _allActivities.add(newTag);
                  _currentActivities.add(newTag);
                  widget.onActivitiesSelected(_currentActivities);
                });
              },
            ),
          ),
          _buildTagSection(
            title: 'সামাজিক সম্পর্ক',
            allTags: _allPeople,
            selectedTags: _currentPeople,
            onUpdate: widget.onPeopleSelected,
            onAddCustom: () => _showAddDialog(
              title: 'নতুন সম্পর্ক যুক্ত করুন',
              onAdd: (newTag) {
                setState(() {
                  _allPeople.add(newTag);
                  _currentPeople.add(newTag);
                  widget.onPeopleSelected(_currentPeople);
                });
              },
            ),
          ),
          _buildTagSection(
            title: 'অবস্থান',
            allTags: _allPlaces,
            selectedTags: _currentPlaces,
            onUpdate: widget.onPlacesSelected,
            onAddCustom: () => _showAddDialog(
              title: 'নতুন অবস্থান যুক্ত করুন',
              onAdd: (newTag) {
                setState(() {
                  _allPlaces.add(newTag);
                  _currentPlaces.add(newTag);
                  widget.onPlacesSelected(_currentPlaces);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
