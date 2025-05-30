import 'package:flutter/material.dart';
import 'package:wellbeingclinic/page/exercise/pmr.dart';

import '../../utils/set_tab_title.dart';
import 'breath.dart';
import 'cbt.dart';
import 'ground.dart';
import 'mindful.dart';

final List<Map<String, dynamic>> exerciseCategories = [
  {
    'title': 'Breathing Techniques',
    'description':
        'শান্ত ও ছন্দবদ্ধ শ্বাস-প্রশ্বাসের অনুশীলনের মাধ্যমে আপনার মন ও শরীরকে স্থির করুন।',
    'icon': Icons.self_improvement,
    'gradientColors': [Colors.blueAccent.shade200, Colors.blue.shade400],
    'onPressed': (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
      );
    },
  },
  {
    'title': 'Mindfulness & Meditation',
    'description':
        'মনের প্রশান্তি ও একাগ্রতা বাড়াতে বর্তমান মুহূর্তে মনোযোগ দিন। এর মাধ্যমে আপনার ভেতরের সচেতনতা বৃদ্ধি পাবে ।',
    'icon': Icons.spa,
    'gradientColors': [Colors.green.shade200, Colors.lightGreen.shade400],
    'onPressed': (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MindfulnessPage()),
      );
    },
  },
  {
    'title': 'Grounding Exercises',
    'description':
        'উদ্বেগ কমাতে ও আবেগ নিয়ন্ত্রণ করতে আপনার ইন্দ্রিয়গুলোর সাথে পুনরায় সংযোগ স্থাপন করুন।',
    'icon': Icons.location_on,
    'gradientColors': [Colors.purple.shade200, Colors.deepPurple.shade400],
    'onPressed': (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GroundingPage()),
      );
    },
  },
  {
    'title': 'CBT Thought Restructuring',
    'description':
        'নেতিবাচক চিন্তাভাবনাকে চ্যালেঞ্জ করে সেগুলোকে আরও ভারসাম্যপূর্ণ দৃষ্টিভঙ্গিতে রূপান্তর করুন।',
    'icon': Icons.lightbulb_rounded,
    'gradientColors': [Colors.orange.shade200, Colors.deepOrange.shade400],
    'onPressed': (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CBTPage()),
      );
    },
  },
  {
    'title': 'Progressive Muscle Relaxation',
    'description':
        'শারীরিক উত্তেজনা দূর করতে পেশীগুলোকে পদ্ধতিগতভাবে টান টান করে তারপর শিথিল করুন।',
    'icon': Icons.accessibility_new,
    'gradientColors': [Colors.red.shade200, Colors.red.shade400],
    'onPressed': (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PMRPage()),
      );
    },
  },
];

class MentalHealthExercisesPage extends StatelessWidget {
  const MentalHealthExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    setTabTitle('Exercises - Wellbeing Clinic', context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mental Health Exercises',
          style: TextStyle(
            color: Colors.indigo.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: ListView(
            children: [
              Divider(height: 1, thickness: .5),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 24),
                child: Text(
                  'Explore Our Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),

              //
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;

                  final items = <Widget>[];
                  for (int i = 0;
                      i < exerciseCategories.length;
                      i += isWide ? 2 : 1) {
                    final rowChildren = <Widget>[];

                    for (int j = i;
                        j < i + (isWide ? 2 : 1) &&
                            j < exerciseCategories.length;
                        j++) {
                      final category = exerciseCategories[j];

                      rowChildren.add(
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            child: buildDetailedHorizontalCard(
                              context: context,
                              title: category['title']!,
                              description: category['description']!,
                              icon: category['icon'] as IconData,
                              gradientColors:
                                  category['gradientColors'] as List<Color>,
                              onPressed: category['onPressed'] as Function(
                                  BuildContext),
                            ),
                          ),
                        ),
                      );
                    }

                    items.add(Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: rowChildren,
                    ));
                  }

                  return Column(children: items);
                },
              ),

              //
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDetailedHorizontalCard({
  required BuildContext context,
  required String title,
  required String description,
  required IconData icon,
  required List<Color> gradientColors,
  required Function(BuildContext) onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withValues(alpha: 0.05),
          spreadRadius: 8,
          blurRadius: 8,
          offset: const Offset(2, 2),
        ),
      ],
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => onPressed(context),
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Allow dynamic height
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 26,
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.9),
                ),
                maxLines: 6, // Optional: allow more lines
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
