import 'package:flutter/material.dart';

class MinimalProfileScreen extends StatelessWidget {
  final String userName = "Alex Morgan";
  final String userHandle = "@alex_morgan";
  final String bio = "Digital Creator • Photographer\n📍 San Francisco\n📧 alex@example.com\n";
  final int posts = 156;
  final int followers = 2543;
  final int following = 342;
  final String profileImageUrl = "https://via.placeholder.com/150"; // Replace with actual image

  const MinimalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          userName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 32),

                  // Stats
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(posts.toString(), "Posts"),
                            _buildStatColumn(followers.toString(), "Followers"),
                            _buildStatColumn(following.toString(), "Following"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // User Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userHandle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bio,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 30),

            // Highlights
            _buildHighlights(),

            const Divider(thickness: 1, height: 30),

            // Options Grid
            _buildOptionsGrid(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Icon(Icons.person_add, size: 20, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildHighlights() {
    final highlights = [
      {"icon": Icons.camera_alt, "label": "Camera"},
      {"icon": Icons.favorite_border, "label": "Likes"},
      {"icon": Icons.bookmark_border, "label": "Saved"},
      {"icon": Icons.add_box_outlined, "label": "New"},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: highlights.length,
        itemBuilder: (context, index) {
          final highlight = highlights[index];
          return Container(
            width: 70,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                  ),
                  child: Icon(highlight['icon'] as IconData, color: Colors.black, size: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  highlight['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final options = [
      {"icon": Icons.settings_outlined, "title": "Settings", "subtitle": "Privacy and account"},
      {"icon": Icons.lock_outline, "title": "Privacy", "subtitle": "Who can see your content"},
      {"icon": Icons.notifications_outlined, "title": "Notifications", "subtitle": "Push and email alerts"},
      {"icon": Icons.security_outlined, "title": "Security", "subtitle": "Password and 2FA"},
      {"icon": Icons.help_outline, "title": "Help", "subtitle": "FAQ and support"},
      {"icon": Icons.info_outline, "title": "About", "subtitle": "App version and info"},
    ];

    return Column(
      children: options.map((option) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Icon(option['icon'] as IconData, color: Colors.black, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavIcon(Icons.home_outlined, true),
          _buildNavIcon(Icons.search, false),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
          _buildNavIcon(Icons.favorite_outline, false),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage("https://via.placeholder.com/30"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 28,
      color: isActive ? Colors.black : Colors.grey[600],
    );
  }
}

// Usage in your app:
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Roboto',
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    ),
    home: const MinimalProfileScreen(),
  ));
}