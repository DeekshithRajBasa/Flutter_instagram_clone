# Instagram Clone REST API Backend

This is the custom REST API backend for the Flutter Instagram Clone application.

## Tech Stack
- **Runtime:** Node.js (v20+)
- **Framework:** Express.js
- **Database:** SQLite with WAL mode (using native `node:sqlite` DatabaseSync — zero native C++ build requirements, ultra-fast and lightweight)
- **Port:** `5000` (configurable via `PORT` environment variable)

---

## Getting Started

### 1. Install Dependencies
```bash
cd server
npm install
```

### 2. Start the Server
```bash
# Production mode
npm start

# Development mode with auto-reload
npm run dev
```

The server will start at:
- **Local:** `http://localhost:5000`
- **Health Check:** `http://localhost:5000/api/health`

---

## Device Connectivity (Android USB / Emulator)

- **Physical Android Device over USB:**
  Port forwarding is pre-configured via ADB so the phone seamlessly routes requests to your PC:
  ```bash
  adb reverse tcp:5000 tcp:5000
  ```
- **Android Emulator:**
  `http://10.0.2.2:5000` automatically routes to host machine `localhost:5000`.

---

## API Endpoints

### 🔐 Authentication
- `POST /api/auth/register` — Register a new account (`username`, `fullName`, `emailOrPhone`, `password`, `avatarUrl`)
- `POST /api/auth/login` — Log into an existing account or auto-create (`usernameOrEmail`, `password`)
- `GET /api/auth/me?userId=...` — Fetch current user profile with posts, followers, and following count
- `PUT /api/auth/profile` — Update bio, website, full name, or profile picture

### 📸 Posts
- `GET /api/posts?userId=...` — Retrieve all posts for the home feed with author info, like status, and comments
- `POST /api/posts` — Create a new post (`userId`, `imageUrl`, `caption`, `location`)
- `POST /api/posts/:id/like` — Toggle like/unlike on a post
- `POST /api/posts/:id/save` — Bookmark or remove post from Saved
- `POST /api/posts/:id/comments` — Add a comment to a post
- `GET /api/posts/saved?userId=...` — Retrieve all saved posts for a user

### ⭕ Stories
- `GET /api/stories?currentUserId=...` — Retrieve active stories grouped by user with viewed status
- `POST /api/stories` — Add a photo to your story (`userId`, `mediaUrl`)
- `POST /api/stories/:id/view` — Mark a story as viewed

### 🎬 Reels
- `GET /api/reels?userId=...` — Retrieve all short video reels
- `POST /api/reels` — Upload/share a reel (`userId`, `mediaUrl`, `caption`, `songTitle`, `songArtist`)
- `POST /api/reels/:id/like` — Toggle like on a reel

### 💬 Direct Messages
- `GET /api/messages/threads?userId=...` — List all direct message conversations
- `POST /api/messages` — Send a direct message (`senderId`, `receiverId`, `text`)

### 🔍 Explore & Users
- `GET /api/explore` — Explore media grid
- `GET /api/users/search?q=...` — Search accounts by username or name
- `POST /api/users/:id/follow` — Follow or unfollow an account
