import 'package:expense_tracker/core/widgets/userprofile.dart';
import 'package:expense_tracker/core/widgets/userprofile2.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Account'),
            _buildSettingItem(
              title: 'Account Details',
              subtitle: 'Manage your account details',
              onTap: () => _navigateToUserPage(context),
              icon: Icon(Icons.person_3_outlined),
            ),
            _buildSettingItem(
              title: 'Subscription',
              subtitle: 'Manage your subscription',

              icon: Icon(Icons.star_border_outlined),
            ),
            _buildSettingItem(
              title: 'Linked Accounts',
              subtitle: 'Manage your linked accounts',

              icon: Icon(Icons.link),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Preferences'),
            _buildSettingItem(
              title: 'App Preferences',
              subtitle: 'Customize your app experience',

              icon: Icon(Icons.settings_outlined),
            ),
            _buildSettingItem(
              title: 'Notifications',
              subtitle: 'Manage your notifications',

              icon: Icon(Icons.notifications_outlined),
            ),
            _buildSettingItem(
              title: 'Privacy',
              subtitle: 'Manage your privacy settings',

              icon: Icon(Icons.shield_outlined),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Support'),
            _buildSettingItem(
              title: 'Help Center',
              subtitle: 'Get help and support',

              icon: Icon(Icons.help_outline),
            ),
            _buildSettingItem(
              title: 'Contact Us',
              subtitle: 'Contact us for support',

              icon: Icon(Icons.messenger_outline_sharp),
            ),
            _buildSettingItem(
              title: 'About',
              subtitle: 'Learn more about our app',

              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
    );
  }
}

void _navigateToUserPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          MinimalProfileV2(), // Replace with your actual user page
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    ),
  );
}

Widget _buildSettingItem({
  required String title,
  required String subtitle,
  required Icon icon,
  VoidCallback? onTap, // Function pointer parameter (optional)
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: icon,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
    ),
    subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
    onTap: onTap, // Pass the function pointer here
    trailing: onTap != null
        ? Icon(Icons.chevron_right, color: Colors.grey)
        : null,
  );
}
