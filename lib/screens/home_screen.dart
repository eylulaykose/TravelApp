import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'add_destination_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ExploreScreenState> _exploreKey = GlobalKey<ExploreScreenState>();
  final CupertinoTabController _tabController = CupertinoTabController();

  late final List<Widget> _screens = [
    ExploreScreen(key: _exploreKey),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        border: const Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass),
            activeIcon: Icon(CupertinoIcons.compass_fill),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        final sectionTitle = index == 0
            ? 'Explore'
            : index == 1
                ? 'Favorites'
                : 'Profile';

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/icon.png',
                width: 32,
                height: 32,
              ),
            ),
            middle: Text(
              sectionTitle,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
            border: null,
          ),
          backgroundColor: CupertinoColors.systemBackground,
          child: SafeArea(
            child: index == 0
                ? Column(
                    children: [
                      Expanded(child: _screens[index]),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton.filled(
                          child: Text(
                            'Add New Destination',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            final newDestination = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddDestinationScreen(),
                              ),
                            );
                            if (newDestination != null) {
                              _exploreKey.currentState?.addNewDestination(newDestination);
                              _tabController.index = 0;
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : _screens[index],
          ),
        );
      },
    );
  }
}