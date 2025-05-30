import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellbeingclinic/page/tools/schedule_week.dart';

import '../../utils/set_tab_title.dart';
import '../exercise/exercise.dart';
import 'mood_section.dart';

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
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   //
      //   // Get.to(() => BanglaPdf());
      //   generateAndOpenInvoice();
      // }),
      //
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
                      color: Colors.black, // Background color of the container
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
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
                          Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
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
                              const SizedBox(width: 2),

                              Text(
                                "আমাদের এআই সহকারী থেকে মানসিক স্বাস্থ্য নিয়ে আপনার যেকোনো প্রশ্নের উত্তর অথবা প্রাথমিক সহায়তা পেতে পারেন।",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily:
                                      GoogleFonts.notoSerifBengali().fontFamily,
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

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/relaxation');
                  },
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors
                              .black12), // Background color of the container
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withValues(alpha: 0.05),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity, // Take full width
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //
                          Expanded(
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'অডিও রিল্যাক্সেশন', // Title
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "এখনই সময় নিজেকে একটু সময় দেওয়ার।\n শব্দের মাধ্যমে অনুভব করুন প্রশান্তি।",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: GoogleFonts.notoSerifBengali()
                                        .fontFamily,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          //

                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Icon(
                              Icons.headset_rounded, // Chat icon
                              //gradiant color

                              color: Colors.black12.withValues(alpha: .3),
                              size: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //
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
                    height: 200,
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
                          width: 280,
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
                              'প্রতিদিনের গুরুত্বপূর্ণ কাজগুলো নির্দিষ্ট সময়ে করা পরিকল্পিত সময়সূচি । এটি সময় ব্যবস্থাপনা উন্নত করে, দায়িত্বশীলতা বাড়ায় এবং মানসিক স্থিরতা এনে দেয়। নিয়মিত স্কেজুল অনুসরণ করলে প্রোডাক্টিভিটি ও আত্মনিয়ন্ত্রণ বৃদ্ধি পায়।'),
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
