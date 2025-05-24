import 'package:flutter/material.dart';

import '/blog/blog_screen.dart';
import '/test/screens/tests.dart';
import 'exercise/exercise.dart';
import 'mood/home_temp.dart';
import 'mood/mood_track.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MoodTrackScreen(),
    MentalHealthExercisesPage(),
    const Tests(),
    const BlogScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black12, // Border color
              width: .5, // Thickness of the border
            ),
          ),
          color: Colors.white, // Same as BottomNavigationBar background
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.earbuds),
              label: 'Exercise',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Tests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.blinds_outlined),
              label: 'Blog',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent.shade700,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
