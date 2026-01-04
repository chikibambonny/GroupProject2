import 'package:flutter/material.dart';
import 'package:sign_translate_app/pages/homepage.dart';
import 'package:sign_translate_app/pages/profilepage.dart';

import '../pages/speechpage.dart';
import '../pages/videopage.dart';
import '../pages/settingspage.dart';
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
    Widget page = pages[selectedIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Sign Translate',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ), // The main title of the app bar
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 800,
                  minWidth: 56,

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
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),

              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: pages[selectedIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
