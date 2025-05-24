import 'package:flutter/material.dart';

import 'mood_track.dart'; // For date formatting

//
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আপনার ওয়েলবিং',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.calendar_month, color: Colors.white, size: 28),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MoodCalendarPage(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Your horizontal mood list section
            MoodTrackingSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//
class MoodTrackingSection extends StatelessWidget {
  const MoodTrackingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 10.0),
          child: Text(
            'How you felling today!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
          ),
        ),
        SizedBox(
          height: 100, // Fixed height for the horizontal list of mood cards
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 16),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: Mood.values.length,
            itemBuilder: (context, index) {
              final mood = Mood.values[index];
              // final isSelected = mood == selectedMood;
              return GestureDetector(
                onTap: () {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMoodFlowScreen(
                          selectedMood: mood,
                        ),
                      ));
                },
                child: Column(
                  children: [
                    Text(mood.emoji, style: const TextStyle(fontSize: 45)),
                    Text(mood.name.capitalize(),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20), // Space after the horizontal list
      ],
    );
  }
}
