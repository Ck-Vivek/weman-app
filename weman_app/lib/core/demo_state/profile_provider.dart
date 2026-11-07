import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Athlete user profile data model for WEMAN FIT.
class UserProfile {
  final String id;
  final String name;
  final String handle;
  final String bio;
  final String fitnessGoal;
  final String avatarUrl;
  final String athleteBadge;
  final String college;
  final String followersCount;
  final String followingCount;

  const UserProfile({
    this.id = 'user-pavan',
    this.name = 'Pavan',
    this.handle = '@pavan.fit',
    this.bio = 'Building strength, one day at a time.',
    this.fitnessGoal = 'Hypertrophy & Strength PRs',
    this.avatarUrl = 'assets/images/pavan_avatar.png',
    this.athleteBadge = 'MASTER ATHLETE',
    this.college = 'PES University, Bangalore',
    this.followersCount = '1.4k',
    this.followingCount = '382',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? handle,
    String? bio,
    String? fitnessGoal,
    String? avatarUrl,
    String? athleteBadge,
    String? college,
    String? followersCount,
    String? followingCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      bio: bio ?? this.bio,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      athleteBadge: athleteBadge ?? this.athleteBadge,
      college: college ?? this.college,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          handle == other.handle &&
          bio == other.bio &&
          fitnessGoal == other.fitnessGoal &&
          avatarUrl == other.avatarUrl &&
          athleteBadge == other.athleteBadge &&
          college == other.college &&
          followersCount == other.followersCount &&
          followingCount == other.followingCount;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        handle,
        bio,
        fitnessGoal,
        avatarUrl,
        athleteBadge,
        college,
        followersCount,
        followingCount,
      );
}

/// StateNotifier that manages session profile edits for WEMAN FIT.
class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(const UserProfile());

  static const UserProfile _defaultProfile = UserProfile();

  /// Updates profile fields with validation and normalization.
  ///
  /// Ensures the username/handle starts with '@' and trims whitespace.
  void updateProfile({
    required String name,
    required String handle,
    required String bio,
    required String fitnessGoal,
  }) {
    final cleanName = name.trim();
    var cleanHandle = handle.trim();
    if (!cleanHandle.startsWith('@') && cleanHandle.isNotEmpty) {
      cleanHandle = '@$cleanHandle';
    }
    final cleanBio = bio.trim();
    final cleanGoal = fitnessGoal.trim();

    state = state.copyWith(
      name: cleanName.isNotEmpty ? cleanName : state.name,
      handle: cleanHandle.isNotEmpty ? cleanHandle : state.handle,
      bio: cleanBio.isNotEmpty ? cleanBio : state.bio,
      fitnessGoal: cleanGoal.isNotEmpty ? cleanGoal : state.fitnessGoal,
    );
  }

  /// Resets profile to demo baseline.
  void reset() {
    state = _defaultProfile;
  }
}

/// Shared global Riverpod provider for athlete profile state.
final userProfileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
