# 📸 Flutter Instagram Clone

A modern, production-ready, full-stack **Instagram Clone** built with **Flutter 3** and powered by a dedicated **Node.js + SQLite REST API backend**. Featuring pixel-perfect Instagram UI, fluid micro-interactions, rich animations, and full database persistence.

---

## ✨ Features

### 🔐 User Onboarding & Authentication
- **Instagram Welcome Screen:** Clean Meta-style landing page with instant login, language selection, and account switching.
- **Multi-Step Signup Wizard:** 8-step onboarding flow (Mobile/Email, 6-digit confirmation code, Name & Password, Birthday picker, Username verification, Terms & Policies, Profile picture selection with custom URL input, and Discover people).
- **Session Persistence:** Remembers user session across app restarts via `SharedPreferences`.

### 📱 Home Feed & Stories
- **Stories Tray:** Gradient story rings, user avatars with initial fallbacks, unread indicator, and "+ Add to Story" modal.
- **Rich Post Cards:** Author headers, multi-image support, double-tap heart burst animation, like/save toggles, location tagging, and time-ago timestamps.
- **Interactive Comments:** Slide-up comment modal to post and read comments in real time.
- **Zero-Data Empty State:** Clean Instagram welcome prompt when feed has no posts yet.

### ➕ Upload Your Pictures & Create Posts
- **Direct Photo URL Input:** Enter or paste any image link with real-time preview and clear button.
- **Curated Photography Presets:** 1-tap starter captures for instant testing.
- **Post Metadata:** Write captions with hashtags, add custom locations, and share immediately.

### 🎬 Reels
- **Full-Screen Vertical Feed:** Snap-scrolling vertical video reel experience.
- **Interactive Overlays:** Double-tap heart animation, like/comment/share action column, author details, follow/following toggle, audio ticker, and spinning vinyl disc animation.
- **Empty State:** Clean exploration placeholder when no reels exist.

### 🔍 Explore & Search
- **Search Bar:** Real-time search for accounts, tags, and places.
- **Category Chips Carousel:** Quick filters (All, Design, Travel, Coding, Food, Architecture, Fashion, Nature).
- **Media Grid:** Staggered visual grid with video/reel badge indicators and tap-to-expand single image view.

### 👤 Profile & Customization
- **Profile Header:** Avatar with story ring gradient, stats count (Posts, Followers, Following), bio, and clickable website link.
- **Edit Profile:** Modal dialog to update bio, full name, website, and avatar.
- **4-Tab Profile Navigation:**
  - 📷 **Posts Grid:** User-uploaded photo grid with authentic empty state (*"Share Photos and Videos"*).
  - 🎬 **Reels Tab:** Personal reels feed with empty state.
  - 🔖 **Saved Tab:** Private bookmarked photos & videos.
  - 🏷️ **Tagged Tab:** Photos and videos of the user.
- **Settings Sheet:** Slide-up sheet with account settings, Saved shortcut, QR code, and Log Out.

### 💬 Direct Messaging (DM)
- **Chat Inbox:** Conversation threads with peer avatars, unread message badges, and active status indicators.
- **Chat Screen:** Real-time message bubbles, instant message sending, and chronological chat history.

---

## 🛠️ Tech Stack & Architecture

### Frontend (Mobile App)
- **Framework:** [Flutter](https://flutter.dev/) (SDK `>=3.0.0 <4.0.0`, Dart 3.12 compatible)
- **Target Platforms:** Android, iOS, Web, macOS, Windows, Linux
- **State Management:** `InheritedNotifier` (`InstagramScope` + `InstagramState`) with **Optimistic UI Updates**
- **Networking:** `http: ^1.2.1` with custom `ApiClient` wrapper
- **Local Cache:** `shared_preferences: ^2.2.3`

### Backend (REST API Server)
- **Runtime:** Node.js (v20+)
- **Web Framework:** Express.js + CORS
- **Database:** SQLite with WAL mode (via native `node:sqlite` DatabaseSync — zero native C++ compiler dependencies)
- **Port:** `5000` (auto-routed to Android via `adb reverse`)

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0+)
- [Node.js](https://nodejs.org/) (version 20+)
- Android Studio / VS Code with Flutter extension
- Connected Android device or Emulator

---

### Step 1: Start the Backend Server

```bash
cd server
npm install
npm start
```

The server will listen at `http://localhost:5000`. You can verify health at:
```bash
curl http://localhost:5000/api/health
```

> **Note for Physical Android Devices:**
> If testing on a physical phone over USB, forward port 5000:
> ```bash
> adb reverse tcp:5000 tcp:5000
> ```

---

### Step 2: Run the Flutter Application

From the project root:

```bash
# Get Flutter packages
flutter pub get

# Run tests
flutter test

# Launch the app
flutter run
```

---

## 📂 Project Directory Structure

```
Flutter_instagram_clone/
├── lib/
│   ├── data/
│   │   └── mock_data.dart                 # Initial default state & models
│   ├── models/
│   │   ├── comment_model.dart             # Comment model with JSON serialization
│   │   ├── message_model.dart             # DirectMessage and ChatThread models
│   │   ├── post_model.dart                # Post model with JSON serialization
│   │   ├── reel_model.dart                # Reel model with JSON serialization
│   │   ├── story_model.dart               # UserStory and StoryItem models
│   │   └── user_model.dart                # User profile model with JSON serialization
│   ├── screens/
│   │   ├── onboarding/
│   │   │   ├── welcome_screen.dart        # Instagram Welcome / Log In screen
│   │   │   └── signup_flow_screen.dart    # 8-step signup wizard
│   │   ├── create_post_screen.dart        # Photo upload & post composer
│   │   ├── direct_messages_screen.dart    # DM threads list & chat view
│   │   ├── explore_screen.dart            # Explore grid & category filters
│   │   ├── home_feed_screen.dart          # Main feed & stories carousel
│   │   ├── main_navigation_screen.dart    # Bottom nav bar coordinator
│   │   ├── notifications_screen.dart      # Activity / notifications list
│   │   ├── profile_screen.dart            # Profile page & empty states
│   │   ├── reels_screen.dart              # Vertical short video feed
│   │   └── story_viewer_screen.dart       # Timed fullscreen story viewer
│   ├── services/
│   │   ├── api_client.dart                # Generic HTTP client with error handling
│   │   ├── api_config.dart                # Dynamic endpoint & host configuration
│   │   └── instagram_api_service.dart     # Service layer connecting all REST endpoints
│   ├── state/
│   │   └── instagram_state.dart           # App-wide state container (InstagramScope)
│   ├── widgets/
│   │   ├── heart_animation_widget.dart    # Double-tap like heart burst animation
│   │   ├── instagram_image.dart           # Cached image with shimmer & fallback
│   │   ├── post_card.dart                 # Post item with like/save/comment UI
│   │   └── story_circle.dart              # Circular avatar with story gradient ring
│   ├── homeScreen.dart                    # Entry wrapper
│   └── main.dart                          # App initialization & theme
├── server/
│   ├── data/                              # SQLite database storage (instagram.db)
│   ├── db.js                              # SQLite database connection & schema
│   ├── index.js                           # Express REST API routes & controllers
│   ├── package.json                       # Server dependencies (express, cors)
│   └── README.md                          # Server documentation
├── test/
│   ├── backend_api_test.dart              # Serialization & API config tests
│   └── widget_test.dart                   # Smoke & navigation tests
└── pubspec.yaml                           # Flutter dependencies & assets
```

---

## 🧪 Testing & Verification

Run all test suites:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

Build release or debug APK:
```bash
flutter build apk --debug
```

---

## 📄 License

This project is open-source under the MIT License.
