import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination_model.dart';
import 'package:intl/intl.dart';
import 'favorites_screen.dart';
import 'add_destination_screen.dart';
import '../data/database_helper.dart';
import 'profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  final Function()? onPlaceVisited;
  
  const ExploreScreen({
    super.key,
    this.onPlaceVisited,
  });

  @override
  State<ExploreScreen> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  double _opacity = 0.0;
  Set<String> _visitedPlaces = {};
  Set<String> _favoritePlaces = {};
  int? _expandedIndex;
  List<Map<String, String>> destinations = [
    {
      'name': 'Paris',
      'location': 'France',
      'description': 'The City of Light',
      'image': 'assets/city.png',
    },
    {
      'name': 'Tokyo',
      'location': 'Japan',
      'description': 'A blend of traditional and modern',
      'image': 'assets/tokyo.png',
    },
    {
      'name': 'Amsterdam',
      'location': 'Netherlands',
      'description': 'Famous for its canals and museums',
      'image': 'assets/amsterdam.jpg',
    },
    {
      'name': 'Roma',
      'location': 'Italy',
      'description': 'The Eternal City with rich history',
      'image': 'assets/roma.jpg',
    },
    {
      'name': 'Venedik',
      'location': 'Italy',
      'description': 'The city of canals and gondolas',
      'image': 'assets/venedik.jpg',
    },
    {
      'name': 'Singapur',
      'location': 'Singapore',
      'description': 'The Lion City, a global financial hub',
      'image': 'assets/singapur.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVisitedPlaces();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  Future<void> _loadVisitedPlaces() async {
    final visited = await DatabaseHelper().getVisited();
    setState(() {
      _visitedPlaces = visited.map((e) => '${destinations[e['destinationId']]['name']}|${destinations[e['destinationId']]['location']}|${destinations[e['destinationId']]['description']}').toSet();
    });
  }

  Future<void> _markAsVisited(Map<String, String> destination) async {
    await DatabaseHelper().insertVisited(destinations.indexOf(destination));
    
    setState(() {
      _visitedPlaces.add('${destination['name']}|${destination['location']}|${destination['description']}');
    });
    
    // Notify parent widget that a place was visited
    widget.onPlaceVisited?.call();
    
    // Notify ProfileScreen to update visited places count
    ProfileScreen.notifyVisitedPlacesChanged();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${destination['name']} marked as visited!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isVisited(Map<String, String> destination) {
    final placeString = '${destination['name']}|${destination['location']}|${destination['description']}';
    return _visitedPlaces.contains(placeString);
  }

  void addNewDestination(Map<String, String> destination) {
    setState(() {
      destinations.add(destination);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Destinations'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Today: ' + formattedDate,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isVisited = _isVisited(destination);
                final placeString = '${destination['name']}|${destination['location']}|${destination['description']}';
                final isFavorite = _favoritePlaces.contains(placeString);
                final isExpanded = _expandedIndex == index;

                if (isExpanded) {
                  // Expanded detailed card layout
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: _opacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            destination['image']!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(destination['name']!),
                                subtitle: Text(
                                    '${destination['location']} - ${destination['description']}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isFavorite) {
                                        _favoritePlaces.remove(placeString);
                                        FavoritesScreen.removeFavorite(destination);
                                      } else {
                                        _favoritePlaces.add(placeString);
                                        FavoritesScreen.addFavorite(destination);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  onPressed: isVisited ? null : () => _markAsVisited(destination),
                                  icon: Icon(isVisited ? Icons.check_circle : Icons.check),
                                  label: Text(isVisited ? 'Visited' : 'Mark as Visited'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isVisited ? Colors.green : null,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _expandedIndex = null;
                                  });
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Compact tile layout
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: _opacity,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            destination['image']!,
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(destination['name']!),
                        subtitle: Text(destination['location']!),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                _favoritePlaces.remove(placeString);
                                FavoritesScreen.removeFavorite(destination);
                              } else {
                                _favoritePlaces.add(placeString);
                                FavoritesScreen.addFavorite(destination);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _expandedIndex = index;
                          });
                          ProfileScreen.incrementReviews();
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}