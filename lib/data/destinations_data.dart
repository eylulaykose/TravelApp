import 'package:shared_preferences/shared_preferences.dart';

class DestinationsData {
  static List<Map<String, String>> destinations = [
    {
      'name': 'Paris',
      'location': 'France',
      'description': 'The City of Light',
      'image': 'assets/city.png',
      'type': 'historical'
    },
    {
      'name': 'Tokyo',
      'location': 'Japan',
      'description': 'A blend of traditional and modern',
      'image': 'assets/tokyo.png',
      'type': 'modern'
    },
    {
      'name': 'Amsterdam',
      'location': 'Netherlands',
      'description': 'Famous for its canals and museums',
      'image': 'assets/amsterdam.jpg',
      'type': 'historical'
    },
    {
      'name': 'Roma',
      'location': 'Italy',
      'description': 'The Eternal City with rich history',
      'image': 'assets/roma.jpg',
      'type': 'historical'
    },
    {
      'name': 'Venedik',
      'location': 'Italy',
      'description': 'The city of canals and gondolas',
      'image': 'assets/venedik.jpg',
      'type': 'historical'
    },
  ];

  static Future<void> addFavorite(Map<String, String> destination) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final placeString = '${destination['name']}|${destination['location']}|${destination['description']}';
    if (!favorites.contains(placeString)) {
      favorites.add(placeString);
      await prefs.setStringList('favorites', favorites);
    }
  }

  static Future<void> removeFavorite(Map<String, String> destination) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final placeString = '${destination['name']}|${destination['location']}|${destination['description']}';
    favorites.remove(placeString);
    await prefs.setStringList('favorites', favorites);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }
} 