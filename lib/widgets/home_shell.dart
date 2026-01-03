import 'package:flutter/material.dart';
import 'package:sign_translate_app/pages/homepage.dart';
import 'package:sign_translate_app/pages/profilepage.dart';

import '../pages/speechpage.dart';
import '../pages/videopage.dart';
import '../pages/settingspage.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    SpeechPage(),
    VideoPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            //extended: constraints.maxWidth >= 600,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },

            // labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.mic),
                label: Text('Speech'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.videocam),
                label: Text('Video'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_circle),
                label: Text('Profile'),
              ),
            ],
          ),

          //place for the actual pages
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
