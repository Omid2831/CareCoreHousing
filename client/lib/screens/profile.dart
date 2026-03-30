import 'package:flutter/material.dart';
import '../services/user_session.dart';
import '../widgets/profile_screen/profile_header.dart';
import '../widgets/profile_screen/section_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _locationServices = true;
  bool _biometricLogin = false;
  String _displayName = 'Guest User';
  String _displayEmail = 'guest@casacorehousing.com';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final Map<String, String?> userData = await UserSession.load();
    final String name = userData['name']?.trim() ?? '';
    final String email = userData['email']?.trim() ?? '';

    if (!mounted) {
      return;
    }

    setState(() {
      _displayName = name.isEmpty ? 'Guest User' : name;
      _displayEmail = email.isEmpty ? 'guest@casacorehousing.com' : email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ProfileHeader(displayName: _displayName, displayEmail: _displayEmail),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Preferences',
            children: [
              SwitchListTile(
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                },
                title: const Text('Push notifications'),
                secondary: const Icon(Icons.notifications_outlined),
              ),
              SwitchListTile(
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                },
                title: const Text('Email updates'),
                secondary: const Icon(Icons.email_outlined),
              ),
              SwitchListTile(
                value: _locationServices,
                onChanged: (value) {
                  setState(() => _locationServices = value);
                },
                title: const Text('Location services'),
                secondary: const Icon(Icons.location_on_outlined),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Security',
            children: [
              SwitchListTile(
                value: _biometricLogin,
                onChanged: (value) {
                  setState(() => _biometricLogin = value);
                },
                title: const Text('Biometric login'),
                secondary: const Icon(Icons.fingerprint),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Saved homes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help and support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await UserSession.clear();
              if (!context.mounted) {
                return;
              }
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }

  // ProfileHeader now in widgets/profile_header.dart

  // SectionCard now in widgets/section_card.dart
}
