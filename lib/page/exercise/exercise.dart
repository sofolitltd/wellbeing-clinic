import 'package:flutter/material.dart';
import 'package:wellbeingclinic/page/exercise/pmr.dart';

// Assuming these imports are correct and point to your updated pages
import '../../utils/set_tab_title.dart';
import 'breath.dart'; // This should contain your BreathingExercisePage (the info page)
import 'cbt.dart'; // This should contain your CBTPage
import 'ground.dart'; // This should contain your GroundingPage
import 'mindful.dart'; // This should contain your MindfulnessPage

// --- Data for the exercise categories with gradient colors ---
final List<Map<String, dynamic>> exerciseCategories = [
  {
    'title': 'Breathing Techniques',
    'description':
        'শান্ত ও ছন্দবদ্ধ শ্বাস-প্রশ্বাসের অনুশীলনের মাধ্যমে আপনার মন ও শরীরকে স্থির করুন।',
    // English: Calm your mind and body with rhythmic breathing exercises.
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
    // English: Enhance awareness and presence by focusing on the moment.
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
    // English: Reconnect with your senses to reduce anxiety and overwhelm.
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
    // English: Challenge and re-frame negative thoughts into balanced perspectives.
    'icon': Icons.lightbulb_outline,
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
    // English: Systematically tense and relax muscles to release physical tension.
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
          'Guided Mental Health Exercises',
          style: TextStyle(
            color: Colors.indigo.shade700, // Deep indigo AppBar
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0, // No shadow for a flat, modern look
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, thickness: .5),
              //
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 24),
                child: Text(
                  'Explore Our Exercises', // Title for the horizontal section
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),

              //
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        MediaQuery.sizeOf(context).width < 700 ? .85 : 1.3,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: exerciseCategories.length,
                  itemBuilder: (context, index) {
                    final category = exerciseCategories[index];

                    //
                    return buildDetailedHorizontalCard(
                      // Using the detailed card builder
                      context: context,
                      title: category['title']!,
                      description: category['description']!,
                      icon: category['icon'] as IconData,
                      gradientColors: category['gradientColors'] as List<Color>,
                      onPressed:
                          category['onPressed'] as Function(BuildContext),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
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
          color: Colors.grey.shade300.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 5),
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
          padding:
              const EdgeInsets.all(20), // Increased padding for full height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Distributes content vertically
            children: [
              Icon(
                icon,
                size: 60, // Slightly larger icon for more prominence
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 16), // Increased spacing
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  // color: Colors.white10.withValues(alpha: .05),
                ),
                height: 60,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Slightly larger title font
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8), // Spacing below title
              Expanded(
                // Ensures description fits
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14, // Slightly larger description font
                    height: 1.4,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines:
                      4, // Allow more lines for description in a taller card
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
