# WEMAN FIT — Project Status & Handover Documentation

**Document Created:** November 2026  
**Repository:** [https://github.com/Ck-Vivek/weman-app.git](https://github.com/Ck-Vivek/weman-app.git)  
**Target Platform:** Flutter (Android-first, iOS-compatible) & Polyglot Microservices  

---

## 1. Current Status & Architecture

WEMAN FIT (formerly Stitch) is an athletic social fitness application designed for college gym-goers and student athletes (initial pilot cohort focused on Karnataka engineering colleges). The codebase is structured as a decoupled polyglot microservices system paired with a high-fidelity Flutter frontend.

### Architecture Overview

```
                      +---------------------------------------+
                      |         FLUTTER MOBILE CLIENT         |
                      |              (weman_app)              |
                      +---------------------------------------+
                                          |
                                          | HTTP / REST (Port 80)
                                          v
                      +---------------------------------------+
                      |         API GATEWAY (NGINX)           |
                      |               (gateway)               |
                      +---------------------------------------+
                                    |           |
                /api/v1/auth /workouts |           | /api/v1/reels /stream
                                    v           v
             +------------------------+       +------------------------+
             |      JAVA BACKEND      |       |       GO BACKEND       |
             |      (weman_core)      |       |     (weman_stream)     |
             |    Spring Boot :8080   |       |       Golang :8081     |
             +------------------------+       +------------------------+
                         |                                |
                         +---------------+----------------+
                                         |
                                         v
                         +--------------------------------+
                         |  CENTRAL DATABASES & QUEUES    |
                         |   PostgreSQL:5432 | Redis:6379 |
                         +--------------------------------+
```

### Module Breakdown
- **`weman_app/` (Flutter Frontend):** Built with Flutter 3+, Dart, Riverpod for state management, and GoRouter. Styled with Stitch athletic design tokens featuring a dark surface theme (`#0D0F11`, `#16191D`), neon-lime accents (`#CCFF00`, `#00FF66`), tactile card elevations, and custom athletic typography.
- **`weman_core/` (Spring Boot Java Service):** Port `8080`. Handles relational transactional workflows, user authentication, profile data, and workout routine templates / synchronization.
- **`weman_stream/` (Golang Service):** Port `8081`. High-concurrency engine managing real-time Reels feeds, stream upload tokens, and high-frequency content operations.
- **`gateway/` (Nginx Reverse Proxy):** Port `80`. Unified reverse proxy routing frontend requests to either `weman_core` or `weman_stream`.
- **`docker-compose.yml`:** Orchestrates PostgreSQL 16 Alpine, Redis 7 Alpine, `weman-core`, `weman-stream`, and `weman-gateway`.

---

## 2. Completed Features

### UI Screens & Mobile Features
1. **Modern Profile Screen (`profile_screen.dart`):**
   - High-fidelity neon-lime athletic aesthetic with athlete badges, college affiliation ("City Engineering College"), bio, and training stats.
   - Interactive **Edit Profile Sheet (`edit_profile_sheet.dart`)**: Bottom modal sheet validating and updating display name, handle (`@`), bio, and fitness goals with instant reactive sync.
2. **Bottom Navigation Bar (`weman_bottom_nav.dart`):**
   - 5-tab athletic navigation (`Feed`, `Hub`, `Explore`, `Inbox`, `Profile`) with active neon-lime glow indicators and dynamic unread notification badges.
3. **Social Feed & Stories (`social_feed_screen.dart`):**
   - Horizontal stories carousel with college campus athlete avatars.
   - Category filter chips (`All`, `Workouts`, `PRs`, `Form Check`, `Diet`).
   - Dynamic post cards with reactive like counters, bookmark toggles, and author metadata binding (`feedProvider`).
4. **Create Post Flow (`create_post_screen.dart`):**
   - Full post creation interface with caption input, media toggle, and category selector.
   - Submitting injects posts dynamically to the top of the feed immediately without resetting view state.
5. **Fitness Hub & Categories (`fitness_hub_screen.dart`):**
   - Quick action shortcuts navigating to Training, Tracking, Nutrition, and Leaderboards.
   - Horizontal workout plan carousel with intensity indicators and estimated durations.
6. **Workout Details & Active Training (`workout_details_screen.dart`, `active_training_screen.dart`):**
   - Workout breakdown with exercise list, target muscle groups, sets/reps, and equipment details.
   - Active workout timer, set progression tracker, and rep logger.
   - Tapping "LOG & RETURN" saves active minutes, calories burned, and logs telemetry to `workoutTelemetryProvider`.
7. **Fitness Tracking Dashboard (`fitness_tracking_screen.dart`):**
   - Hero energy burn circular progress ring showing daily calorie targets.
   - Recorded Workouts History feed displaying freshly completed sessions with timestamps and metric tags.
8. **Diet Tracker & Hydration (`diet_tracker_screen.dart`):**
   - **Daily Fuel Card:** Dynamic circular progress gauge, target calories, and macro percentages.
   - **Daily Macros:** Protein, complex carbs, healthy fats, and dietary fiber breakdown gauges.
   - **Meal Category Cards (Breakfast, Lunch, Snacks, Dinner):** Dynamic meal item lists with calories, macros, empty states, and deletion support.
   - **Add Meal Bottom Sheet (`add_meal_sheet.dart`):** Custom food logging with category chips, Indian/athletic quick presets (Eggs & Toast, Spiced Paneer Bowl, Whey Shake), and non-negative integer validation.
   - **Hydration Tile:** Liters consumed (`/ 4.0L`) with increment (`+ 250ml`) and decrement (`- 250ml`) buttons safely clamped between `0.0L` and `6.0L`.
9. **Messaging & Conversations Inbox (`conversations_inbox_screen.dart`, `chat_detail_screen.dart`):**
   - Real-time in-session chat with message partitioning by conversation ID.
   - Dynamic inbox preview with last message snippet, timestamp updates ("Just now"), and bump-to-top on message dispatch.
   - Instant unread badge clearing upon conversation opening.
   - Athlete search filtering by name, handle, or message body.
10. **Rankings & Leaderboards (`rankings_screen.dart`):**
    - Multi-tier scope selector: `National`, `State`, `District`, `College`, `Gym`.
    - Visual top 3 podium card with medal badges, avatars, and college titles.
11. **Badge Gallery (`badge_gallery_screen.dart`):**
    - Tier tabs (`All`, `Strength`, `Consistency`, `Elite`) with earned vs. locked visual states and progress detail sheets.
12. **Explore Screen (`explore_screen.dart`):**
    - Search bar, trending fitness categories, and prominent neon-lime quick card to Fitness Tracker.
13. **My Space Screen (`my_space_screen.dart`):**
    - Personal athlete dashboard syncing workout counts and profile identity.
14. **Reels Screen (`reels_screen.dart`):**
    - Fullscreen vertical layout with side action bar (likes, comments, share, audio track) and linked exercise tag.
15. **Auth & Onboarding Screens (`login_screen.dart`, `onboarding_screen.dart`, `splash_screen.dart`):**
    - Clean onboarding cards and login flow.

### Backend Endpoints Configured
- **Java Spring Boot (`weman_core` on :8080):**
  - `POST /api/v1/auth/login` — Returns JWT auth token and athlete profile details.
  - `POST /api/v1/auth/register` — Registers new athlete ID and campus hub affiliation.
  - `GET /api/v1/workouts/templates` — Returns workout routine templates (PPL Split, HIIT).
  - `POST /api/v1/workouts/sync` — Ingests offline-logged workout session batches.
- **Go Stream Service (`weman_stream` on :8081):**
  - `GET /api/v1/reels` — Returns high-speed streaming reels metadata feed.
  - `POST /api/v1/stream/upload-token` — Pre-signs secure upload tokens for workout clips.
  - `GET /health` — Microservice health status.
- **API Gateway (`gateway` on :80):**
  - Routes `/api/v1/auth` & `/api/v1/workouts` -> `weman-core`.
  - Routes `/api/v1/reels` & `/api/v1/stream` -> `weman-stream`.
  - `GET /health` -> Gateway health check.

---

## 3. Pending Tasks & Next Steps

### Exact Place Where Work Was Stopped
- **Front-end Phase 1 & Phase 2 Stabilization is Complete:** All 51 unit & widget tests are passing (`feed_provider_test`, `workout_telemetry_test`, `profile_editing_test`, `diet_tracker_test`, `chat_messaging_test`).
- **Containerization is Ready:** Microservices compile and can run under `docker compose`.
- Work stopped prior to connecting Flutter network clients (`Dio` / `http`) to the Nginx gateway and expanding feature depth.

### Immediate Features / UI Updates to Build
1. **Streaks & Consistency System:**
   - Daily gym check-in streak logic with streak freeze mechanisms and milestone celebration animations.
   - Campus streak leaderboards (competing college hostels/gyms by consecutive workout days).
2. **District / State / College Leaderboards:**
   - Real-time Redis-backed sorted sets (`ZREVRANGE`) ranking athletes by total workout volume (kg lifted) and weekly consistency.
   - Dynamic filters for Karnataka districts (Bengaluru Urban, Mysuru, Mangaluru, etc.) and engineering colleges (City Eng, CMRIT, RVCE, PES).
3. **Indian Food Macro Tracker:**
   - Enrich `add_meal_sheet.dart` with a searchable Indian food composition database (e.g. Idli, Masala Dosa, Dal Tadka, Paneer Bhurji, Roti, Chicken Biryani, Sattu, Sprouts Salad).
   - Gram-based quantity selector with automatic macronutrient recalculations (carbs, protein, fats).
4. **Rep / Set Rest Timer & Audio Cues:**
   - Build a circular countdown rest timer modal between sets in `active_training_screen.dart`.
   - Add haptic feedback and chimes on timer completion (e.g., 60s, 90s, 120s rest periods).
5. **Gateway & Live API Connection:**
   - Create an API client in `weman_app/lib/core/network/api_client.dart` configured to hit `http://localhost/api/v1` (or local network IP on Android emulator `10.0.2.2`).
   - Replace in-memory Riverpod initializers with live API calls and fallback local caching (`Hive` / `shared_preferences`).
6. **Video Player Integration for Reels:**
   - Replace placeholder image thumbnails in `reels_screen.dart` with `video_player` / `chewie` streaming from the Go microservice endpoint.

---

## 4. Environment & Setup Notes

### Prerequisites
- **Docker & Docker Compose** (Docker Desktop on Windows/macOS or Docker Engine on Linux)
- **Flutter SDK** (Version 3.22+ or compatible)
- **Dart SDK** (Bundled with Flutter)
- **Java 17+** & Maven (Optional, for building `weman_core` without Docker)
- **Go 1.21+** (Optional, for building `weman_stream` without Docker)

### Starting the Backend Services (Docker)
To launch PostgreSQL, Redis, Java Core, Go Stream, and the Nginx Gateway:
```bash
# In the root project directory:
docker compose up --build -d

# Check running containers:
docker compose ps

# Verify Gateway health:
curl http://localhost/health

# Verify Go Reels API:
curl http://localhost/api/v1/reels
```

### Running the Flutter Mobile App
```bash
# Navigate to the mobile app directory:
cd weman_app

# Fetch dependencies:
flutter pub get

# Run test suite to verify baseline:
flutter test

# Start the application on a connected device, emulator, or chrome:
flutter run
```

> **Android Emulator Note:** When running on the Android Emulator, use `http://10.0.2.2:80` to reach the local Nginx API Gateway instead of `localhost`.

---

## 5. Repository & Branch Info
- **Remote URL:** `https://github.com/Ck-Vivek/weman-app.git`
- **Primary Branch:** `main` (or `master`)
