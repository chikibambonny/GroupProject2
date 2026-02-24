import 'package:flutter/material.dart';

import '../pages/homepage.dart';
import '../pages/speechpage.dart';
import '../pages/videopage.dart';
import '../pages/settingspage.dart';
import '../pages/profilepage.dart';
import '../pages/translatorpage.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    TranslatorPage(),
    //SpeechPage(),
    //VideoPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  final List<NavigationDestination> navDestinations = const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.translate), label: 'Translator'),
    //NavigationDestination(icon: Icon(Icons.mic), label: 'Speech'),
    //NavigationDestination(icon: Icon(Icons.videocam), label: 'Video'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
    NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
  ];

  final List<NavigationRailDestination> railDestinations = const [
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(
      icon: Icon(Icons.translate),
      label: Text('Translator'),
    ),
    //NavigationRailDestination(icon: Icon(Icons.mic), label: Text('Speech')),
    //NavigationRailDestination(icon: Icon(Icons.videocam), label: Text('Video')),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_circle),
      label: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final ratio = constraints.maxWidth / constraints.maxHeight;
        final useRail = ratio >= 1.0; // landscape or wide enough → side rail

        return Scaffold(
          appBar: AppBar(
            title: const Text('HandsUP'),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),

          body: useRail
              ? Row(
                  children: [
                    SafeArea(
                      child: SizedBox(
                        width: 160,
                        child: NavigationRail(
                          extended: true,
                          minWidth: 80,
                          selectedIndex: selectedIndex,
                          onDestinationSelected: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          destinations: railDestinations,
                          selectedIconTheme: IconThemeData(
                            color: theme.colorScheme.primary,
                          ),
                          selectedLabelTextStyle: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                          unselectedIconTheme: IconThemeData(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          unselectedLabelTextStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: theme.colorScheme.primaryContainer,
                        child: pages[selectedIndex],
                      ),
                    ),
                  ],
                )
              : Container(
                  color: theme.colorScheme.primaryContainer,
                  child: pages[selectedIndex],
                ),

          bottomNavigationBar: useRail
              ? null
              : Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: theme.colorScheme.primary,
                    unselectedItemColor: theme.colorScheme.onSurfaceVariant,
                    items: navDestinations
                        .map(
                          (d) => BottomNavigationBarItem(
                            icon: d.icon,
                            label: d.label,
                          ),
                        )
                        .toList(),
                  ),
                ),
        );
      },
    );
  }
}
