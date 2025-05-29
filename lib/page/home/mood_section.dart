import 'package:flutter/material.dart';

import '../mood/model/mood.dart';
import '../mood/mood_flow.dart';

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
            //
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 10.0),
              child: Text(
                "আজকে আপনার অনুভূতি কেমন?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ),
            //
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
                        Text(mood.title, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
