Here is your updated Product Requirements Document (PRD). The architecture foundations, technology stack tables, and dependency pathways have been completely revised to reflect your pivot to Flutter, Go, and Java while preserving the core visual guidelines, community scopes, and feature boundaries of Stitch (formerly WEMAN FIT).

STITCH — Karnataka Launch MVP PRD

Version: 3.0 — Flutter & Polyglot Backend Architecture Refactor
Prepared: 14 October 2026
Platforms: Android-first native binary via Flutter (iOS-compatible codebase)
Initial Release Strategy: Android controlled pilot in Karnataka; iOS release deferred post-equivalent testing
Audience: College students attending gyms or starting gym training
Status: Implementation-ready architectural proposal for owner review
Relationship to Original Layout: Governs MVP scope under the new architectural guidelines; overrides all previous React Native/Expo infrastructure references.

1. Product Definition

Stitch is an affordable, gym-focused social fitness application for college students. It pairs a custom, high-fidelity short-video feed with beginner-friendly exercise guidance and minimalist workout tracking.
The application UI/UX is built specifically to mimic a premium, tactile "soft texture" interface inspired by modern consumer platforms like Zepto and Uber, utilizing soft container elevation profiles, distinct card groups, and an ultra-clean visual hierarchy.
One-Sentence Promise: Discover localized gym content, access verified exercise tutorials, log your private training history, and connect with your campus gym community within a single fluid native interface.
Core Journey: Discover a gym Reel → save or follow → open a linked exercise/workout where available → train and log → see personal progress → return to the community.

2. Users and Launch Boundaries


Primary Users

1. New Gym Members: Require clean, distraction-free exercise instructions and basic starter routines.
2. Student Gym-Goers: Want to share localized content, follow creators, and maintain private logs.
3. Gym Educators/Creators: Supply instructional video assets and verified form breakdowns.

Initial Market Rules

• Target Cohort: Recruited from a managed selection of Karnataka engineering colleges (e.g., City Engineering College, CMRIT) and surrounding gyms.
• Age Bounds: Limited to an 18+ pilot cohort.
• Localization: Core UI localized using strict translation keys supporting English and Kannada. Unicode support enforced for comments and descriptions.

3. Launch Scope: Build Only These Major Features


Module	Required at Launch	Explicitly Excluded from Launch
Accounts	Email sign-up/login, verification, profile setup, account deletion	Phone OTP, multiple social logins, identity document verification
Gym Reels	Video capture/selection, vertical playback, captions, category tags, linkage	Livestreaming, stories, inline multi-clip video editor, licensed audio catalogs
Social Graph	Follow/unfollow, like/unlike, save content, comment sections, unidirectional block	Direct messaging (DMs), group chats, photo-only posts, creator monetization engines
Gym Guidance	Reviewed exercise library (40–60 movements) and 3 core starter routines	Open crowd-sourced program marketplaces, medical coaching advice
Workout Logs	Exercise selectors, log sets/reps/weight, active session local drafts, UTC history	Wearable sync, step counters, GPS run maps, active calorie burns, automated insights
Safety / Admin	Reporting tools, moderation queue, content removal, restricted access states	Fully automated or machine-learning content moderation claims


4. Technology Stack: Refactored Foundations

The engineering foundations are shifted completely away from React Native, Expo, and NestJS monorepos to a decoupled, multi-repo polyglot microservices and native mobile engine designed for enterprise scaling and high concurrency.
                     +---------------------------------------+

                     |         FLUTTER MOBILE CLIENT         |
                     +---------------------------------------+
                                         |
                                         | HTTPS / REST (v1)
                                         v
                     +---------------------------------------+

                     |         API GATEWAY (NGINX / KONG)    |
                     +---------------------------------------+

                                   |           |
               /api/v1/auth /workouts |           | /api/v1/reels /stream
                                   v           v
            +------------------------+       +------------------------+

            |      JAVA BACKEND      |       |       GO BACKEND       |
            |     (Spring Boot)      |       |    (Engine / Gin)      |
            +------------------------+       +------------------------+

                        |                                |
                        +---------------+----------------+
                                        |
                                        v
                        +--------------------------------+

                        |  CENTRAL DATABASES & QUEUES    |
                        |   (PostgreSQL / Redis Cache)   |
                        +--------------------------------+

Infrastructure Specification


Layer	Technology	Operational MVP Role
Mobile Frontend	Flutter (Dart)	Compiles to native Android binaries. Responsible for rendering the soft-texture UI cards, form selections, and vertical video rendering pipeline.
API Routing Gateway	Nginx / Kong	Single endpoint proxy facing the client. Automatically intercepts client calls and forwards traffic seamlessly to the appropriate backend service.
Secure Business Logic	Java (Spring Boot)	Handles enterprise-grade workflows: User authentication, secure profile processing, relational transactional records, and data models.
High-Speed Operations	Go (Golang)	Lightweight, highly concurrent engine managing real-time data streaming, video metadata queries, feed generation, and high-volume operations.
Primary Database	PostgreSQL	Canonical ACID storage engine holding user credentials, social graphs, exercises, and workout session tables.
Caching & Queues	Redis	In-memory storage layer running session state models, high-frequency metrics caches, and processing job queues.
Background Work	Go Workers / BullMQ	Handles asynchronous operations: payload file verification, asset processing, notification dispatch, and cleanup scripts.
Containerization	Docker & Compose	Sandbox environment orchestration for local deployment. Eliminates dependency mapping discrepancies on development machines.


5. Architectural Data Flow & Security Rules

1. Decoupled Repositories: To eliminate local configuration caching errors, codebases must be maintained in separate standalone repositories:
	• stitch-mobile/ (Pure Flutter layout client)
	• stitch-core-java/ (Spring Boot core backend services)
	• stitch-stream-go/ (Go real-time processing layer)
2. Unified Client Routing: The Flutter mobile client connects strictly to the API Gateway. The frontend client does not track separate server URLs for Go and Java services.
3. Media Pipeline Security: Flutter requests a short-lived signed upload token from the Go backend service → Uploads media binary directly to private object storage → Go background workers validate, transcode via FFmpeg wrappers, and pass metadata to Java for authorization validation. Source binaries are never stored inside PostgreSQL.
4. Local Data Isolation: Offline workout logs use Hive or standard SQFlite directly inside the Flutter runtime sandbox for local durability, syncing back via transaction versioning queues to the Java backend when connectivity resets.

6. Brand and UI Token Preservation

The design language maintains your custom premium Stitch signature profile, translating original tokens directly into standard Flutter Decoration Classes.
dart
// Flutter Custom Theme Configuration Design Tokens
class StitchTheme {
  static const Color accent = Color(0xFFCCFF00);       // Volt Neon Lime Green
  static const Color background = Color(0xFFF8F9FA);   // Premium Off-White Canvas
  static const Color cardBg = Color(0xFFFFFFFF);       // Pure White Containers
  static const Color textPrimary = Color(0xFF111111);  // Deep Charcoal/Black
  static const Color textMuted = Color(0xFF6C757D);    // Slate Gray Subtext

  static BoxDecoration softCardDecoration = BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(24.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        offset: const Offset(0, 4),
        blurRadius: 12.0,
      ),
    ],
  );
}
Use code with caution.

7. Build Plan in Dependency Order


Milestone 1 — Environment Provisioning & Sandbox Setup

• Initialize clean Flutter container layout repositories.
• Configure local Docker Compose infrastructure holding PostgreSQL, Redis, and Gateway routes.
• Exit Gate: Local environment boots via a single terminal script; container blocks connect cleanly.

Milestone 2 — Core Services & Authentication

• Implement Java Spring Boot user account management, password hashing, and token dispatching pipelines.
• Map basic database layout schemas via automated migration tracking tools.
• Exit Gate: Flutter mobile client authenticates, issues securely packed tokens, and tracks session flows.

Milestone 3 — High-Speed Feed & Media Pipelines

• Launch Go service vertical streaming layouts and video file object processing jobs.
• Link video playback engines inside Flutter using optimized asset caches to block rendering lag.
• Exit Gate: Uploaded video processing loops execute successfully and render smoothly within the Pixel emulator viewer at steady frame rates.

Milestone 4 — Local Fitness Utility Tracking

• Construct localized workout trackers using offline local storage engines.
• Build the specific visual check-card templates matching the layout profile using custom card components.
• Exit Gate: App accurately preserves unfinished session drafts across restarts and correctly resolves multi-device conflicts during database synchronization passes.
Now that the Stitch PRD has been refactored for your new Flutter, Go, and Java tech stack, what are the specific doubts you wanted to clear up about this architecture? Let's break them down.
