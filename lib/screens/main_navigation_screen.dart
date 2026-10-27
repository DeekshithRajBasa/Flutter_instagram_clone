import 'package:flutter/material.dart';
import '../state/instagram_state.dart';
import 'create_post_screen.dart';
import 'explore_screen.dart';
import 'home_feed_screen.dart';
import 'profile_screen.dart';
import 'reels_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // Create Post Modal
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => CreatePostScreen(
            onPostSuccess: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final isDark = _currentIndex == 3; // Reels tab has dark theme

    final pages = [
      HomeFeedScreen(onAddPost: () => _onTabTapped(2)),
      const ExploreScreen(),
      const SizedBox.shrink(), // Placeholder for Create Post
      const ReelsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 1,
                  icon:
                      _currentIndex == 1 ? Icons.search : Icons.search_outlined,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.add_box_outlined,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 3,
                  icon: _currentIndex == 3
                      ? Icons.video_collection
                      : Icons.video_collection_outlined,
                  isDark: isDark,
                ),
                _buildProfileNavItem(
                  index: 4,
                  avatarUrl: state.currentUser.avatarUrl,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final color = isDark
        ? (isSelected ? Colors.white : Colors.white60)
        : (isSelected ? Colors.black : Colors.black87);

    return IconButton(
      icon: Icon(icon, color: color, size: 28),
      onPressed: () => _onTabTapped(index),
    );
  }

  Widget _buildProfileNavItem({
    required int index,
    required String avatarUrl,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          radius: 13,
          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          backgroundImage:
              avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty
              ? Icon(
                  Icons.person,
                  size: 15,
                  color: isDark ? Colors.white70 : Colors.black87,
                )
              : null,
        ),
      ),
    );
  }
}
