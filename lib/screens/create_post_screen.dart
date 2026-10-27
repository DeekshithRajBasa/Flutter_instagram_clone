import 'package:flutter/material.dart';
import '../state/instagram_state.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback? onPostSuccess;

  const CreatePostScreen({super.key, this.onPostSuccess});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1518770660439-4636190af475?w=1080&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1080&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1080&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=1080&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1080&auto=format&fit=crop&q=80',
  ];

  String _selectedImageUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _handleShare() {
    final imageUrl = _selectedImageUrl.isNotEmpty
        ? _selectedImageUrl
        : _photoUrlController.text.trim();

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste a photo URL or pick an image.')),
      );
      return;
    }

    final caption = _captionController.text.trim();
    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a caption for your post.')),
      );
      return;
    }

    InstagramScope.of(context).addNewPost(
      imageUrl: imageUrl,
      caption: caption,
      location: _locationController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your post was shared successfully! 🎉'),
        backgroundColor: Colors.black87,
      ),
    );

    if (widget.onPostSuccess != null) {
      widget.onPostSuccess!();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeImageUrl = _selectedImageUrl.isNotEmpty
        ? _selectedImageUrl
        : _photoUrlController.text.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          'New Post',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleShare,
            child: const Text(
              'Share',
              style: TextStyle(
                color: Color(0xFF0095F6),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Selected Image Preview & Caption Input Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: activeImageUrl.isNotEmpty
                    ? Image.network(
                        activeImageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.grey.shade500, size: 28),
                            const SizedBox(height: 4),
                            Text(
                              'No photo',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _captionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption or add #hashtags...',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Direct Photo URL Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, color: Color(0xFF0095F6), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _photoUrlController,
                    decoration: const InputDecoration(
                      hintText: 'Paste photo URL (https://...)',
                      hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _selectedImageUrl = val.trim();
                      });
                    },
                  ),
                ),
                if (_photoUrlController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                    onPressed: () {
                      _photoUrlController.clear();
                      setState(() => _selectedImageUrl = '');
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Location Input
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading:
                const Icon(Icons.location_on_outlined, color: Colors.black87),
            title: TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Add Location (e.g. Tokyo, Bengaluru)',
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 12),

          // Quick Tag People
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline, color: Colors.black87),
            title: const Text('Tag People'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(height: 12),

          // Quick Music
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading:
                const Icon(Icons.music_note_outlined, color: Colors.black87),
            title: const Text('Add Music'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(height: 24),

          // Choose from Samples or Presets
          const Text(
            'Or pick a sample photo:',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleImages.length,
              itemBuilder: (context, index) {
                final img = _sampleImages[index];
                final isSelected = img == activeImageUrl;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageUrl = img;
                      _photoUrlController.text = img;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0095F6)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        img,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
