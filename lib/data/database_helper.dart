import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<List<Map<String, dynamic>>> getVisited() async {
    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getStringList('visited_places') ?? [];
    return visited.map((e) => {'destinationId': int.parse(e)}).toList();
  }

  Future<void> insertVisited(int destinationId) async {
    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getStringList('visited_places') ?? [];
    visited.add(destinationId.toString());
    await prefs.setStringList('visited_places', visited);
  }
}