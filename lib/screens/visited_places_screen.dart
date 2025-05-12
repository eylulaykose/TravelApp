import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination_model.dart';

class VisitedPlacesScreen extends StatefulWidget {
  const VisitedPlacesScreen({super.key});

  @override
  State<VisitedPlacesScreen> createState() => _VisitedPlacesScreenState();
}

class _VisitedPlacesScreenState extends State<VisitedPlacesScreen> {
  List<Destination> _visitedPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadVisitedPlaces();
  }

  Future<void> _loadVisitedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final visitedPlacesJson = prefs.getStringList('visited_places') ?? [];
    
    setState(() {
      _visitedPlaces = visitedPlacesJson.map((json) {
        final parts = json.split('|');
        return Destination(
          name: parts[0],
          location: parts[1],
          description: parts[2],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visited Places'),
      ),
      body: _visitedPlaces.isEmpty
          ? const Center(
              child: Text(
                'No visited places yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _visitedPlaces.length,
              itemBuilder: (context, index) {
                final place = _visitedPlaces[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(place.name),
                    subtitle: Text('${place.location} - ${place.description}'),
                    leading: const Icon(Icons.place),
                  ),
                );
              },
            ),
    );
  }
} 