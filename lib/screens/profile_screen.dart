import 'package:flutter/material.dart';
import '../singleimage.dart';
import '../state/instagram_state.dart';
import 'create_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _highlights = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    final state = InstagramScope.of(context);
    final bioController =
        TextEditingController(text: state.currentUser.bio);
    final webController =
        TextEditingController(text: state.currentUser.website);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: webController,
                  decoration: const InputDecoration(
                    labelText: 'Website Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                state.updateBio(bioController.text, webController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final state = InstagramScope.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings and privacy'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('Saved'),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QR code'),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Log out', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  state.logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final user = state.currentUser;
    final userPosts = state.myPosts;
    final savedPosts = state.savedPosts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              user.username,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined,
                color: Colors.black87, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar and Stats Row
                    Row(
                      children: [
                        // Avatar with story ring
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFBAA47),
                                Color(0xFFD91A46),
                                Color(0xFFA60F93),
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: user.avatarUrl.isNotEmpty
                                ? NetworkImage(user.avatarUrl)
                                : null,
                            child: user.avatarUrl.isEmpty
                                ? Text(
                                    user.username.isNotEmpty
                                        ? user.username[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Stats
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('${user.postsCount}', 'Posts'),
                              _buildStatItem(
                                  '${user.followersCount}', 'Followers'),
                              _buildStatItem(
                                  '${user.followingCount}', 'Following'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Name & Bio
                    if (user.fullName.isNotEmpty)
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: Colors.black87,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      user.bio,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    if (user.website.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.link, size: 14, color: Color(0xFF00376B)),
                          const SizedBox(width: 4),
                          Text(
                            user.website,
                            style: const TextStyle(
                              color: Color(0xFF00376B),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showEditProfileDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEFEFEF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profile link copied!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEFEFEF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Share Profile',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person_add_outlined,
                                color: Colors.black87, size: 18),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Story Highlights Tray
                    SizedBox(
                      height: 85,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ..._highlights.map((h) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 14.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1.5),
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(h['img']!),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    h['title']!,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black87),
                                  ),
                                ],
                              ),
                            );
                          }),
                          // Add new highlight circle
                          Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'New',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black87,
                  indicatorWeight: 1.5,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on_sharp)),
                    Tab(icon: Icon(Icons.video_library_outlined)),
                    Tab(icon: Icon(Icons.bookmark_border)),
                    Tab(icon: Icon(Icons.person_pin_outlined)),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Grid Posts Tab
            userPosts.isEmpty
                ? _buildEmptyTabState(
                    icon: Icons.camera_alt_outlined,
                    title: 'Share Photos and Videos',
                    subtitle:
                        'When you share photos and videos, they will appear on your profile.',
                    actionLabel: 'Share your first photo',
                    onAction: _openCreatePost,
                  )
                : _buildGridTab(userPosts.map((p) => p.imageUrls.first).toList()),

            // Reels Tab
            state.reels.isEmpty
                ? _buildEmptyTabState(
                    icon: Icons.video_collection_outlined,
                    title: 'Share Reels',
                    subtitle:
                        'When you share reels, they will appear on your profile.',
                    actionLabel: 'Create a reel',
                    onAction: _openCreatePost,
                  )
                : _buildGridTab(state.reels.map((r) => r.mediaUrl).toList()),

            // Saved Tab
            savedPosts.isEmpty
                ? _buildEmptyTabState(
                    icon: Icons.bookmark_border,
                    title: 'Save Photos and Videos',
                    subtitle:
                        'Save photos and videos that you want to see again. No one is notified, and only you can see what you\'ve saved.',
                  )
                : _buildGridTab(
                    savedPosts.map((p) => p.imageUrls.first).toList()),

            // Tagged Tab
            _buildEmptyTabState(
              icon: Icons.person_pin_outlined,
              title: 'Photos and videos of you',
              subtitle:
                  'When people tag you in photos and videos, they\'ll appear here.',
            ),
          ],
        ),
      ),
    );
  }

  void _openCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreatePostScreen(
          onPostSuccess: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildEmptyTabState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2),
              ),
              child: Icon(icon, size: 36, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Color(0xFF0095F6),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGridTab(List<String> images) {
    return GridView.builder(
      padding: const EdgeInsets.all(1.5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final img = images[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => singleimage(link: img),
              ),
            );
          },
          child: Image.network(
            img,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
