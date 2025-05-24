import 'package:flutter/material.dart';

import '../exercise/exercise.dart';
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
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('ওয়েলবিং ক্লিনিক',
            style: TextStyle(
                color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await auth.signOut().then((_) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                });
              } catch (_) {}
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: ListView(
            children: [
              Divider(height: 1, thickness: .5),
              // Your horizontal mood list section
              MoodTrackingSection(),

              // const SizedBox(height: 20),

              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 20.0, bottom: 10.0),
                    child: Text(
                      'Explore Our Exercises', // Title for the horizontal section
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                  ),
                  Container(
                    height: 270,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    // This ensures the ListView takes all remaining vertical space
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 16),
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: exerciseCategories.length,
                      itemBuilder: (context, index) {
                        final category = exerciseCategories[index];
                        return SizedBox(
                          width: 270,
                          child: buildDetailedHorizontalCard(
                            // Using the detailed card builder
                            context: context,
                            title: category['title']!,
                            description: category['description']!,
                            icon: category['icon'] as IconData,
                            gradientColors:
                                category['gradientColors'] as List<Color>,
                            onPressed:
                                category['onPressed'] as Function(BuildContext),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 10.0),
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
        ),
      ),
    );
  }
}
