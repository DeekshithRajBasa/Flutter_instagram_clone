const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Request logger
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Helper: Format Time Ago
function formatTimeAgo(timestamp) {
  const seconds = Math.floor((Date.now() - timestamp) / 1000);
  if (seconds < 60) return 'Just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return `${Math.floor(days / 7)}w ago`;
}

// Helper: Build Full User Object
function getUserProfile(userId, currentUserId = null) {
  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(userId);
  if (!user) return null;

  const postsCount = db
    .prepare('SELECT COUNT(*) as count FROM posts WHERE user_id = ?')
    .get(userId).count;

  const followersCount = db
    .prepare('SELECT COUNT(*) as count FROM follows WHERE following_id = ?')
    .get(userId).count;

  const followingCount = db
    .prepare('SELECT COUNT(*) as count FROM follows WHERE follower_id = ?')
    .get(userId).count;

  let isFollowing = false;
  if (currentUserId && currentUserId !== userId) {
    const followCheck = db
      .prepare('SELECT 1 FROM follows WHERE follower_id = ? AND following_id = ?')
      .get(currentUserId, userId);
    isFollowing = Boolean(followCheck);
  }

  return {
    id: user.id,
    username: user.username,
    fullName: user.full_name || user.username,
    avatarUrl: user.avatar_url || '',
    bio: user.bio || '',
    website: user.website || '',
    isVerified: Boolean(user.is_verified),
    postsCount,
    followersCount,
    followingCount,
    isFollowing,
  };
}

// Helper: Build Post Object
function getPostDetails(postRow, currentUserId = null) {
  const author = getUserProfile(postRow.user_id, currentUserId);

  const likesCount = db
    .prepare('SELECT COUNT(*) as count FROM post_likes WHERE post_id = ?')
    .get(postRow.id).count;

  const isLiked = currentUserId
    ? Boolean(
        db
          .prepare('SELECT 1 FROM post_likes WHERE post_id = ? AND user_id = ?')
          .get(postRow.id, currentUserId)
      )
    : false;

  const isSaved = currentUserId
    ? Boolean(
        db
          .prepare('SELECT 1 FROM saved_posts WHERE post_id = ? AND user_id = ?')
          .get(postRow.id, currentUserId)
      )
    : false;

  const commentRows = db
    .prepare(
      `SELECT c.*, u.username, u.avatar_url 
       FROM comments c 
       JOIN users u ON c.user_id = u.id 
       WHERE c.post_id = ? 
       ORDER BY c.created_at DESC`
    )
    .all(postRow.id);

  const comments = commentRows.map((c) => ({
    id: c.id,
    username: c.username,
    userAvatar: c.avatar_url || '',
    text: c.text,
    timeAgo: formatTimeAgo(c.created_at),
  }));

  return {
    id: postRow.id,
    author: author || {
      id: postRow.user_id,
      username: 'User',
      fullName: 'Instagram User',
      avatarUrl: '',
      isVerified: false,
    },
    imageUrls: [postRow.image_url],
    caption: postRow.caption || '',
    location: postRow.location || '',
    timeAgo: formatTimeAgo(postRow.created_at),
    likesCount,
    isLiked,
    isSaved,
    comments,
  };
}

// --- HEALTH CHECK ---
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', service: 'Instagram Clone REST API', timestamp: Date.now() });
});

// --- AUTH ENDPOINTS ---

// Register
app.post('/api/auth/register', (req, res) => {
  const { username, fullName, emailOrPhone, password, avatarUrl } = req.body;

  if (!username || !username.trim()) {
    return res.status(400).json({ error: 'Username is required' });
  }

  const cleanUsername = username.trim().toLowerCase();
  const existing = db
    .prepare('SELECT id FROM users WHERE username = ?')
    .get(cleanUsername);

  if (existing) {
    return res.status(409).json({ error: 'Username is already taken' });
  }

  const userId = 'u_' + Date.now();
  const now = Date.now();

  db.prepare(
    `INSERT INTO users (id, username, full_name, email_or_phone, password, avatar_url, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?)`
  ).run(
    userId,
    cleanUsername,
    fullName ? fullName.trim() : cleanUsername,
    emailOrPhone ? emailOrPhone.trim() : '',
    password || '',
    avatarUrl ? avatarUrl.trim() : '',
    now
  );

  const user = getUserProfile(userId);
  res.status(201).json({ message: 'User registered successfully', user });
});

// Login
app.post('/api/auth/login', (req, res) => {
  const { usernameOrEmail } = req.body;

  if (!usernameOrEmail || !usernameOrEmail.trim()) {
    return res.status(400).json({ error: 'Username or email is required' });
  }

  const queryStr = usernameOrEmail.trim().toLowerCase();
  let userRow = db
    .prepare('SELECT id FROM users WHERE username = ? OR email_or_phone = ?')
    .get(queryStr, queryStr);

  if (!userRow) {
    // Auto-create user for instant seamless experience
    const userId = 'u_' + Date.now();
    db.prepare(
      `INSERT INTO users (id, username, full_name, created_at)
       VALUES (?, ?, ?, ?)`
    ).run(userId, queryStr, queryStr, Date.now());
    userRow = { id: userId };
  }

  const user = getUserProfile(userRow.id);
  res.json({ message: 'Login successful', user });
});

// Get Current User Profile
app.get('/api/auth/me', (req, res) => {
  const { userId } = req.query;
  if (!userId) {
    return res.status(400).json({ error: 'userId parameter is required' });
  }

  const user = getUserProfile(userId);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json({ user });
});

// Update Profile
app.put('/api/auth/profile', (req, res) => {
  const { userId, bio, website, fullName, avatarUrl } = req.body;
  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  const user = db.prepare('SELECT * FROM users WHERE id = ?').get(userId);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  db.prepare(
    `UPDATE users 
     SET bio = COALESCE(?, bio),
         website = COALESCE(?, website),
         full_name = COALESCE(?, full_name),
         avatar_url = COALESCE(?, avatar_url)
     WHERE id = ?`
  ).run(
    bio !== undefined ? bio : user.bio,
    website !== undefined ? website : user.website,
    fullName !== undefined ? fullName : user.full_name,
    avatarUrl !== undefined ? avatarUrl : user.avatar_url,
    userId
  );

  const updated = getUserProfile(userId);
  res.json({ message: 'Profile updated', user: updated });
});

// --- POSTS ENDPOINTS ---

// Get Feed Posts
app.get('/api/posts', (req, res) => {
  const currentUserId = req.query.userId || null;
  const rows = db.prepare('SELECT * FROM posts ORDER BY created_at DESC').all();
  const posts = rows.map((r) => getPostDetails(r, currentUserId));
  res.json({ posts });
});

// Create Post
app.post('/api/posts', (req, res) => {
  const { userId, imageUrl, caption, location } = req.body;

  if (!userId || !imageUrl) {
    return res.status(400).json({ error: 'userId and imageUrl are required' });
  }

  const postId = 'p_' + Date.now();
  const now = Date.now();

  db.prepare(
    `INSERT INTO posts (id, user_id, image_url, caption, location, created_at)
     VALUES (?, ?, ?, ?, ?, ?)`
  ).run(postId, userId, imageUrl.trim(), caption ? caption.trim() : '', location ? location.trim() : '', now);

  const postRow = db.prepare('SELECT * FROM posts WHERE id = ?').get(postId);
  const post = getPostDetails(postRow, userId);

  res.status(201).json({ message: 'Post created', post });
});

// Toggle Post Like
app.post('/api/posts/:id/like', (req, res) => {
  const postId = req.params.id;
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  const existing = db
    .prepare('SELECT 1 FROM post_likes WHERE post_id = ? AND user_id = ?')
    .get(postId, userId);

  let isLiked = false;
  if (existing) {
    db.prepare('DELETE FROM post_likes WHERE post_id = ? AND user_id = ?').run(postId, userId);
    isLiked = false;
  } else {
    db.prepare('INSERT INTO post_likes (post_id, user_id, created_at) VALUES (?, ?, ?)').run(
      postId,
      userId,
      Date.now()
    );
    isLiked = true;
  }

  const likesCount = db
    .prepare('SELECT COUNT(*) as count FROM post_likes WHERE post_id = ?')
    .get(postId).count;

  res.json({ postId, isLiked, likesCount });
});

// Toggle Post Save / Bookmark
app.post('/api/posts/:id/save', (req, res) => {
  const postId = req.params.id;
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  const existing = db
    .prepare('SELECT 1 FROM saved_posts WHERE post_id = ? AND user_id = ?')
    .get(postId, userId);

  let isSaved = false;
  if (existing) {
    db.prepare('DELETE FROM saved_posts WHERE post_id = ? AND user_id = ?').run(postId, userId);
    isSaved = false;
  } else {
    db.prepare('INSERT INTO saved_posts (post_id, user_id, created_at) VALUES (?, ?, ?)').run(
      postId,
      userId,
      Date.now()
    );
    isSaved = true;
  }

  res.json({ postId, isSaved });
});

// Add Comment
app.post('/api/posts/:id/comments', (req, res) => {
  const postId = req.params.id;
  const { userId, text } = req.body;

  if (!userId || !text || !text.trim()) {
    return res.status(400).json({ error: 'userId and text are required' });
  }

  const commentId = 'c_' + Date.now();
  const now = Date.now();

  db.prepare('INSERT INTO comments (id, post_id, user_id, text, created_at) VALUES (?, ?, ?, ?, ?)').run(
    commentId,
    postId,
    userId,
    text.trim(),
    now
  );

  const user = db.prepare('SELECT username, avatar_url FROM users WHERE id = ?').get(userId);

  const comment = {
    id: commentId,
    username: user ? user.username : 'User',
    userAvatar: user ? user.avatar_url || '' : '',
    text: text.trim(),
    timeAgo: 'Just now',
  };

  res.status(201).json({ message: 'Comment added', comment });
});

// Get User's Saved Posts
app.get('/api/posts/saved', (req, res) => {
  const { userId } = req.query;
  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  const rows = db
    .prepare(
      `SELECT p.* 
       FROM posts p 
       JOIN saved_posts sp ON p.id = sp.post_id 
       WHERE sp.user_id = ? 
       ORDER BY sp.created_at DESC`
    )
    .all(userId);

  const posts = rows.map((r) => getPostDetails(r, userId));
  res.json({ posts });
});

// --- STORIES ENDPOINTS ---

// Get Stories Tray
app.get('/api/stories', (req, res) => {
  const currentUserId = req.query.currentUserId || null;

  // Get users who have stories in the last 24 hours
  const oneDayAgo = Date.now() - 24 * 60 * 60 * 1000;
  const storyRows = db
    .prepare('SELECT * FROM stories WHERE created_at >= ? ORDER BY created_at ASC')
    .all(oneDayAgo);

  // Group by user
  const grouped = new Map();
  for (const s of storyRows) {
    if (!grouped.has(s.user_id)) {
      grouped.set(s.user_id, []);
    }
    grouped.get(s.user_id).push(s);
  }

  const stories = [];
  for (const [userId, items] of grouped.entries()) {
    const author = getUserProfile(userId, currentUserId);
    if (!author) continue;

    // Check if current user has seen all stories
    let allSeen = true;
    const storyItems = items.map((item) => {
      let isSeen = false;
      if (currentUserId) {
        const viewCheck = db
          .prepare('SELECT 1 FROM story_views WHERE story_id = ? AND user_id = ?')
          .get(item.id, currentUserId);
        isSeen = Boolean(viewCheck);
        if (!isSeen) allSeen = false;
      }
      return {
        id: item.id,
        mediaUrl: item.media_url,
        timeAgo: formatTimeAgo(item.created_at),
      };
    });

    stories.push({
      user: author,
      stories: storyItems,
      isSeen: allSeen,
    });
  }

  res.json({ stories });
});

// Add Story
app.post('/api/stories', (req, res) => {
  const { userId, mediaUrl } = req.body;
  if (!userId || !mediaUrl) {
    return res.status(400).json({ error: 'userId and mediaUrl are required' });
  }

  const storyId = 's_' + Date.now();
  db.prepare('INSERT INTO stories (id, user_id, media_url, created_at) VALUES (?, ?, ?, ?)').run(
    storyId,
    userId,
    mediaUrl.trim(),
    Date.now()
  );

  res.status(201).json({ message: 'Story added', storyId });
});

// Mark Story Seen
app.post('/api/stories/:id/view', (req, res) => {
  const storyId = req.params.id;
  const { userId } = req.body;
  if (userId) {
    try {
      db.prepare('INSERT OR IGNORE INTO story_views (story_id, user_id, created_at) VALUES (?, ?, ?)').run(
        storyId,
        userId,
        Date.now()
      );
    } catch (_) {}
  }
  res.json({ success: true });
});

// --- REELS ENDPOINTS ---

// Get Reels
app.get('/api/reels', (req, res) => {
  const currentUserId = req.query.userId || null;
  const rows = db.prepare('SELECT * FROM reels ORDER BY created_at DESC').all();

  const reels = rows.map((r) => {
    const author = getUserProfile(r.user_id, currentUserId);
    const likesCount = db
      .prepare('SELECT COUNT(*) as count FROM reel_likes WHERE reel_id = ?')
      .get(r.id).count;

    const isLiked = currentUserId
      ? Boolean(
          db
            .prepare('SELECT 1 FROM reel_likes WHERE reel_id = ? AND user_id = ?')
            .get(r.id, currentUserId)
        )
      : false;

    return {
      id: r.id,
      author: author || {
        id: r.user_id,
        username: 'Creator',
        fullName: 'Creator',
        avatarUrl: '',
        isVerified: true,
      },
      mediaUrl: r.media_url,
      caption: r.caption || '',
      songTitle: r.song_title || 'Original Audio',
      songArtist: r.song_artist || (author ? author.username : ''),
      likesCount,
      commentsCount: 0,
      sharesCount: 0,
      isLiked,
    };
  });

  res.json({ reels });
});

// Create Reel
app.post('/api/reels', (req, res) => {
  const { userId, mediaUrl, caption, songTitle, songArtist } = req.body;
  if (!userId || !mediaUrl) {
    return res.status(400).json({ error: 'userId and mediaUrl are required' });
  }

  const reelId = 'r_' + Date.now();
  db.prepare(
    `INSERT INTO reels (id, user_id, media_url, caption, song_title, song_artist, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?)`
  ).run(
    reelId,
    userId,
    mediaUrl.trim(),
    caption ? caption.trim() : '',
    songTitle || 'Original Audio',
    songArtist || '',
    Date.now()
  );

  res.status(201).json({ message: 'Reel created', reelId });
});

// Toggle Reel Like
app.post('/api/reels/:id/like', (req, res) => {
  const reelId = req.params.id;
  const { userId } = req.body;
  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  const existing = db
    .prepare('SELECT 1 FROM reel_likes WHERE reel_id = ? AND user_id = ?')
    .get(reelId, userId);

  let isLiked = false;
  if (existing) {
    db.prepare('DELETE FROM reel_likes WHERE reel_id = ? AND user_id = ?').run(reelId, userId);
    isLiked = false;
  } else {
    db.prepare('INSERT INTO reel_likes (reel_id, user_id, created_at) VALUES (?, ?, ?)').run(
      reelId,
      userId,
      Date.now()
    );
    isLiked = true;
  }

  const likesCount = db
    .prepare('SELECT COUNT(*) as count FROM reel_likes WHERE reel_id = ?')
    .get(reelId).count;

  res.json({ reelId, isLiked, likesCount });
});

// --- DIRECT MESSAGES ENDPOINTS ---

// Get User's Threads
app.get('/api/messages/threads', (req, res) => {
  const { userId } = req.query;
  if (!userId) {
    return res.status(400).json({ error: 'userId is required' });
  }

  // Find all distinct peers
  const peerRows = db
    .prepare(
      `SELECT DISTINCT 
         CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END AS peer_id 
       FROM direct_messages 
       WHERE sender_id = ? OR receiver_id = ?`
    )
    .all(userId, userId, userId);

  const threads = [];
  for (const row of peerRows) {
    const peer = getUserProfile(row.peer_id, userId);
    if (!peer) continue;

    const messages = db
      .prepare(
        `SELECT * FROM direct_messages 
         WHERE (sender_id = ? AND receiver_id = ?) 
            OR (sender_id = ? AND receiver_id = ?)
         ORDER BY created_at ASC`
      )
      .all(userId, row.peer_id, row.peer_id, userId);

    const hasUnread = messages.some((m) => m.sender_id === row.peer_id && !m.is_read);

    threads.push({
      id: `t_${row.peer_id}`,
      peer,
      hasUnread,
      lastActive: 'Active now',
      messages: messages.map((m) => ({
        id: m.id,
        senderId: m.sender_id,
        text: m.text,
        timestamp: new Date(m.created_at).toISOString(),
        isMe: m.sender_id === userId,
      })),
    });
  }

  res.json({ threads });
});

// Send Direct Message
app.post('/api/messages', (req, res) => {
  const { senderId, receiverId, text } = req.body;
  if (!senderId || !receiverId || !text || !text.trim()) {
    return res.status(400).json({ error: 'senderId, receiverId, and text are required' });
  }

  const msgId = 'msg_' + Date.now();
  const now = Date.now();

  db.prepare(
    `INSERT INTO direct_messages (id, sender_id, receiver_id, text, is_read, created_at)
     VALUES (?, ?, ?, ?, 0, ?)`
  ).run(msgId, senderId, receiverId, text.trim(), now);

  const message = {
    id: msgId,
    senderId,
    text: text.trim(),
    timestamp: new Date(now).toISOString(),
    isMe: true,
  };

  res.status(201).json({ message });
});

// --- EXPLORE & USERS ENDPOINTS ---

// Explore Posts / Images
app.get('/api/explore', (req, res) => {
  const rows = db.prepare('SELECT image_url FROM posts ORDER BY created_at DESC LIMIT 30').all();
  const images = rows.map((r) => r.image_url);
  res.json({ images });
});

// Search Users
app.get('/api/users/search', (req, res) => {
  const query = req.query.q ? req.query.q.trim().toLowerCase() : '';
  const currentUserId = req.query.userId || null;

  let rows;
  if (query) {
    rows = db
      .prepare('SELECT id FROM users WHERE username LIKE ? OR full_name LIKE ? LIMIT 20')
      .all(`%${query}%`, `%${query}%`);
  } else {
    rows = db.prepare('SELECT id FROM users LIMIT 15').all();
  }

  const users = rows.map((r) => getUserProfile(r.id, currentUserId)).filter(Boolean);
  res.json({ users });
});

// Follow / Unfollow User
app.post('/api/users/:id/follow', (req, res) => {
  const targetUserId = req.params.id;
  const { currentUserId } = req.body;

  if (!currentUserId || currentUserId === targetUserId) {
    return res.status(400).json({ error: 'Invalid follower or target user' });
  }

  const existing = db
    .prepare('SELECT 1 FROM follows WHERE follower_id = ? AND following_id = ?')
    .get(currentUserId, targetUserId);

  let isFollowing = false;
  if (existing) {
    db.prepare('DELETE FROM follows WHERE follower_id = ? AND following_id = ?').run(
      currentUserId,
      targetUserId
    );
    isFollowing = false;
  } else {
    db.prepare('INSERT INTO follows (follower_id, following_id, created_at) VALUES (?, ?, ?)').run(
      currentUserId,
      targetUserId,
      Date.now()
    );
    isFollowing = true;
  }

  const targetProfile = getUserProfile(targetUserId, currentUserId);
  res.json({ targetUserId, isFollowing, user: targetProfile });
});

// Start Server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`===============================================`);
  console.log(`Instagram Clone REST API Server running!`);
  console.log(`Local URL:   http://localhost:${PORT}`);
  console.log(`Health Check: http://localhost:${PORT}/api/health`);
  console.log(`===============================================`);
});
