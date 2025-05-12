import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool appUpdates = true;
  bool newDestinations = true;
  bool promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('App Updates'),
            value: appUpdates,
            onChanged: (val) => setState(() => appUpdates = val),
          ),
          SwitchListTile(
            title: const Text('New Destinations'),
            value: newDestinations,
            onChanged: (val) => setState(() => newDestinations = val),
          ),
          SwitchListTile(
            title: const Text('Promotional Offers'),
            value: promotionalOffers,
            onChanged: (val) => setState(() => promotionalOffers = val),
          ),
        ],
      ),
    );
  }
}