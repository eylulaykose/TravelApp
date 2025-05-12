import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool showProfilePublicly = true;
  bool allowFriendRequests = true;
  bool shareActivityStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show Profile Publicly'),
            value: showProfilePublicly,
            onChanged: (val) => setState(() => showProfilePublicly = val),
          ),
          SwitchListTile(
            title: const Text('Allow Friend Requests'),
            value: allowFriendRequests,
            onChanged: (val) => setState(() => allowFriendRequests = val),
          ),
          SwitchListTile(
            title: const Text('Share Activity Status'),
            value: shareActivityStatus,
            onChanged: (val) => setState(() => shareActivityStatus = val),
          ),
        ],
      ),
    );
  }
}