import 'package:flutter/material.dart';

import '/blog/blog_screen.dart';
import '/test/screens/tests.dart';
import '../utils/set_tab_title.dart';
import 'exercise/exercise.dart';
import 'mood/home_temp.dart';
import 'mood/mood_track.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4;

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
    setTabTitle('Home - Wellbeing Clinic', context);

    const int breakpointWidth = 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useRail = constraints.maxWidth >= breakpointWidth;

        return Scaffold(
          body: Row(
            children: [
              if (useRail) ...[
                NavigationRail(
                  backgroundColor: Colors.white,
                  // useIndicator: true,
                  // extended: true,

                  labelType: NavigationRailLabelType.all,
                  minExtendedWidth: 120,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  groupAlignment: 0,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.track_changes),
                      label: Text('Mood'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.earbuds),
                      label: Text('Exercise'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment),
                      label: Text('Tests'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.blinds_outlined),
                      label: Text('Blog'),
                    ),
                  ],
                ),
                VerticalDivider(),
              ],
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ],
          ),
          bottomNavigationBar: useRail
              ? null
              : BottomNavigationBar(
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
        );
      },
    );
  }
}
