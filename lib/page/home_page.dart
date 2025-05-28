import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellbeingclinic/page/tools/schedule_week.dart';

import '../utils/set_tab_title.dart';
import 'exercise/exercise.dart';
import 'mood/mood_track.dart';

//
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    setTabTitle('Home - Wellbeing Clinic', context);

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: Text(
          'ওয়েলবিং ক্লিনিক',
          style: TextStyle(
            color: Colors.indigo.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
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

              const SizedBox(height: 16),

              //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/chat');
                  },
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  child: Ink(
                    decoration: BoxDecoration(
                      color:
                          Colors.black87, // Background color of the container
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity, // Take full width
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          //
                          const Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.support, // Chat icon
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'ওয়েলবিং ক্লিনিক এআই', // Title
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              //
                              Text(
                                "আমাদের এআই সহকারী আপনাকে মানসিক স্বাস্থ্য সম্পর্কিত বিভিন্ন প্রশ্নের সহজ ও বোধগম্য উত্তর প্রদানের মাধ্যমে দ্রুত প্রাথমিক সহায়তা দিতে প্রস্তুত",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),

                          //
                          Icon(
                            Icons.arrow_right_alt_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      top: 20.0,
                    ),
                    child: Text(
                      'প্রয়োজনীয় ব্যায়াম',
                      // Title for the horizontal section
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    // This ensures the ListView takes all remaining vertical space
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 20),
                      scrollDirection: Axis.horizontal,
                      // Enable horizontal scrolling
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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

              //
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 20.0,
                ),
                child: Text(
                  'মানসিক সুস্থতা ও অনুশীলন',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),

              //
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  tileColor: Colors.indigo.shade50,
                  isThreeLine: true,
                  contentPadding: EdgeInsets.zero,
                  subtitle: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      //
                      Column(
                        children: [
                          SizedBox(height: 8),

                          //
                          Text(
                              'পরিকল্পিত সময়সূচি যেখানে প্রতিদিনের গুরুত্বপূর্ণ কাজগুলো নির্দিষ্ট সময়ে করা হয়। এটি সময় ব্যবস্থাপনা উন্নত করে, দায়িত্বশীলতা বাড়ায় এবং মানসিক স্থিরতা এনে দেয়। নিয়মিত স্কেজুল অনুসরণ করলে প্রোডাক্টিভিটি ও আত্মনিয়ন্ত্রণ বৃদ্ধি পায়।'),
                        ],
                      ),

                      //
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    // go to ScheduleListPage
                    Get.to(() => ScheduleListPage());
                  },
                  title: Text(
                    'Activity Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
              ),

              //
              SizedBox(height: 40),
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
                        Text(mood.name.capitalizeFirst,
                            style: const TextStyle(fontSize: 14)),
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
