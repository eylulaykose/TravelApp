import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'notification_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static void notifyVisitedPlacesChanged() {
    _ProfileScreenState.notifyVisitedPlacesChanged();
  }

  static void incrementReviews() async {
    final prefs = await SharedPreferences.getInstance();
    int reviews = prefs.getInt('reviews_count') ?? 0;
    reviews++;
    await prefs.setInt('reviews_count', reviews);
    _ProfileScreenState.notifyReviewsChanged();
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static final List<_ProfileScreenState> _instances = [];
  static void notifyVisitedPlacesChanged() {
    for (final instance in _instances) {
      instance._updateVisitedPlacesCount();
    }
  }

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Profile info state
  String _name = 'John Doe';
  String _bio = 'Travel Enthusiast';
  String _location = 'New York, USA';
  bool _isDarkMode = false;
  int _visitedPlacesCount = 27;
  int _reviewsCount = 0;

  @override
  void initState() {
    super.initState();
    _instances.add(this);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _updateVisitedPlacesCount();
    _updateReviewsCount();
  }

  @override
  void dispose() {
    _instances.remove(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateVisitedPlacesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getStringList('visited_places') ?? [];
    setState(() {
      _visitedPlacesCount = visited.length;
    });
  }

  Future<void> _updateReviewsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final reviews = prefs.getInt('reviews_count') ?? 0;
    setState(() {
      _reviewsCount = reviews;
    });
  }

  static void notifyReviewsChanged() {
    for (final instance in _instances) {
      instance._updateReviewsCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CupertinoColors.activeBlue,
                    CupertinoColors.activeBlue.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildStatistics(),
                    const SizedBox(height: 24),
                    _buildSettingsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CupertinoColors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: const Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  size: 120,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: CupertinoColors.white, width: 2),
                ),
                child: const Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        Text(
          _bio,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.location_fill,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
            const SizedBox(width: 4),
            Text(
              _location,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Places Visited', '$_visitedPlacesCount', CupertinoIcons.map_fill),
          _buildStatItem('Reviews', '$_reviewsCount', CupertinoIcons.star_fill),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: CupertinoColors.activeBlue,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingsGroup([
          _buildSettingsItem(
            icon: CupertinoIcons.person_crop_circle,
            label: 'Edit Profile',
            showDivider: true,
            onTap: () => _navigateToEditProfile(),
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.map,
            label: 'Saved Places',
            showDivider: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _buildSettingsGroup([
          _buildSettingsItem(
            icon: CupertinoIcons.bell,
            label: 'Notifications',
            showDivider: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationSettingsScreen()),
            ),
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.lock,
            label: 'Privacy',
            showDivider: true,
            onTap: () => _showPrivacyDialog(),
          ),
          _buildSettingsItem(
            icon: CupertinoIcons.question_circle,
            label: 'Help & Support',
            onTap: () => _showHelpSupportDialog(),
          ),
        ]),
        const SizedBox(height: 16),
        _buildSettingsGroup([
          _buildSettingsItem(
            icon: CupertinoIcons.square_arrow_left,
            label: 'Sign Out',
            color: CupertinoColors.destructiveRed,
            onTap: () => _showSignOutDialog(),
          ),
        ]),
      ],
    );
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: _name,
          bio: _bio,
          location: _location,
          onSave: (name, bio, location) {
            setState(() {
              _name = name;
              _bio = bio;
              _location = location;
            });
          },
        ),
      ),
    );
  }

  void _showPlaceholderScreen(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text('$title screen coming soon!')),
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out!')),
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        bool showProfilePublicly = true;
        bool allowFriendRequests = true;
        bool shareActivityStatus = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Privacy Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Show Profile Publicly'),
                    value: showProfilePublicly,
                    onChanged: (val) =>
                        setState(() => showProfilePublicly = val),
                  ),
                  SwitchListTile(
                    title: const Text('Allow Friend Requests'),
                    value: allowFriendRequests,
                    onChanged: (val) =>
                        setState(() => allowFriendRequests = val),
                  ),
                  SwitchListTile(
                    title: const Text('Share Activity Status'),
                    value: shareActivityStatus,
                    onChanged: (val) =>
                        setState(() => shareActivityStatus = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHelpSupportDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Help & Support'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FAQ:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Q: How do I add a destination?'),
                    const Text(
                        'A: Use the "Add New Destination" button on the Explore tab.'),
                    const SizedBox(height: 8),
                    const Text('Q: How do I edit my profile?'),
                    const Text('A: Tap "Edit Profile" on your profile page.'),
                    const Divider(height: 24),
                    const Text('Contact Us:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter your name'
                                : null,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (value) =>
                                value == null || !value.contains('@')
                                    ? 'Enter a valid email'
                                    : null,
                          ),
                          TextFormField(
                            controller: _messageController,
                            decoration:
                                const InputDecoration(labelText: 'Message'),
                            maxLines: 2,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter your message'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Thank You!'),
                          content: const Text('Your message has been sent.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String label,
    bool showDivider = false,
    Color color = CupertinoColors.label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onPressed: onTap,
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else
                Icon(
                  CupertinoIcons.chevron_forward,
                  color: CupertinoColors.systemGrey3,
                  size: 20,
                ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(left: 52),
            color: CupertinoColors.separator,
          ),
      ],
    );
  }
}