import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wellbeingclinic/page/profile.dart';

import '/page/blog/blog_screen.dart';
import '/test/screens/tests.dart';
import '../utils/set_tab_title.dart';
import 'exercise/exercise.dart';
import 'home_page.dart';
import 'mood/mood_track.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MoodTrackScreen(),
    MentalHealthExercisesPage(),
    const Tests(),
    const BlogScreen(),
    Profile(),
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
                      icon: Icon(LucideIcons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.smilePlus),
                      label: Text('Mood'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.box),
                      label: Text('Exercise'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.listChecks),
                      label: Text('Tests'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.book),
                      label: Text('Blog'),
                    ),

                    //profile
                    NavigationRailDestination(
                      icon: Icon(LucideIcons.user),
                      label: Text('Profile'),
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
                      icon: Icon(LucideIcons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.smilePlus),
                      label: 'Mood',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.box),
                      label: 'Exercise',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.listChecks),
                      label: 'Tests',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.book),
                      label: 'Blog',
                    ),
                    //profile
                    BottomNavigationBarItem(
                      icon: Icon(LucideIcons.user),
                      label: 'Profile',
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
