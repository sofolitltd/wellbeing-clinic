import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/mood.dart';

class MoodSelectionPage extends StatelessWidget {
  final Function(Mood) onMoodSelected;
  final Mood selectedMood;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const MoodSelectionPage({
    super.key,
    required this.onMoodSelected,
    required this.selectedMood,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth < 400) {
      crossAxisCount = 3;
    } else if (screenWidth < 600) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 5;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          HorizontalDatePicker(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 20),
          const Text(
            "আজকে আপনার অনুভূতি কেমন?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
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
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HorizontalDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HorizontalDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  final ScrollController _scrollController = ScrollController();
  late List<DateTime> daysOfMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    daysOfMonth = List.generate(
      lastDay.day,
      (index) => DateTime(now.year, now.month, index + 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = widget.selectedDate.day - 1;
      _scrollController.jumpTo(index * 70.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: daysOfMonth.length,
        itemBuilder: (context, index) {
          final date = daysOfMonth[index];
          final isSelected = date.day == widget.selectedDate.day;

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('bn').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                  Text(
                    DateFormat('dd', 'bn').format(date), // e.g., ২৯ মে
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateFormat('MMMM', 'bn').format(date), // e.g., ২৯ মে
                    style: TextStyle(
                      fontSize: 10,
                      height: 1,
                      color: isSelected ? Colors.white : Colors.black54,
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
