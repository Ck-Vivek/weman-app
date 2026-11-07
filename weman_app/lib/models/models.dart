/// Core Data Models for WEMAN
library;

class WemanUser {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final String college;
  final bool isVerifiedTrainer;

  const WemanUser({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.college,
    this.isVerifiedTrainer = false,
  });
}

class WemanFeedPost {
  final String id;
  final WemanUser author;
  final String content;
  final String? imageUrl;
  final String? exerciseTag;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final String timestamp;
  final bool isLiked;
  final bool isSaved;

  // Stitch Design Rich Attributes
  final String postType; // 'strength', 'nutrition', 'running', 'standard'
  final String? authorRole;
  final String? categoryTag;
  final String? imageBadgeTop;
  final String? imageBadgeBottom;
  final String? timerBadge;
  final String? rpeBadge;
  final String? exerciseName;
  final String? routineButtonText;
  final String? macroHeadline;
  final String? postTitle;
  final Map<String, String>? metrics;
  final String? location;

  const WemanFeedPost({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    this.exerciseTag,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.timestamp,
    this.isLiked = false,
    this.isSaved = false,
    this.postType = 'standard',
    this.authorRole,
    this.categoryTag,
    this.imageBadgeTop,
    this.imageBadgeBottom,
    this.timerBadge,
    this.rpeBadge,
    this.exerciseName,
    this.routineButtonText,
    this.macroHeadline,
    this.postTitle,
    this.metrics,
    this.location,
  });

  WemanFeedPost copyWith({
    String? id,
    WemanUser? author,
    String? content,
    String? imageUrl,
    String? exerciseTag,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    String? timestamp,
    bool? isLiked,
    bool? isSaved,
    String? postType,
    String? authorRole,
    String? categoryTag,
    String? imageBadgeTop,
    String? imageBadgeBottom,
    String? timerBadge,
    String? rpeBadge,
    String? exerciseName,
    String? routineButtonText,
    String? macroHeadline,
    String? postTitle,
    Map<String, String>? metrics,
    String? location,
  }) {
    return WemanFeedPost(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      exerciseTag: exerciseTag ?? this.exerciseTag,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      timestamp: timestamp ?? this.timestamp,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      postType: postType ?? this.postType,
      authorRole: authorRole ?? this.authorRole,
      categoryTag: categoryTag ?? this.categoryTag,
      imageBadgeTop: imageBadgeTop ?? this.imageBadgeTop,
      imageBadgeBottom: imageBadgeBottom ?? this.imageBadgeBottom,
      timerBadge: timerBadge ?? this.timerBadge,
      rpeBadge: rpeBadge ?? this.rpeBadge,
      exerciseName: exerciseName ?? this.exerciseName,
      routineButtonText: routineButtonText ?? this.routineButtonText,
      macroHeadline: macroHeadline ?? this.macroHeadline,
      postTitle: postTitle ?? this.postTitle,
      metrics: metrics ?? this.metrics,
      location: location ?? this.location,
    );
  }
}

class WemanReel {
  final String id;
  final WemanUser creator;
  final String videoUrl;
  final String caption;
  final String audioTrack;
  final String linkedExercise;
  final int likesCount;
  final int commentsCount;
  final int bookmarksCount;
  final List<String> tags;

  const WemanReel({
    required this.id,
    required this.creator,
    required this.videoUrl,
    required this.caption,
    required this.audioTrack,
    required this.linkedExercise,
    required this.likesCount,
    required this.commentsCount,
    required this.bookmarksCount,
    required this.tags,
  });
}

class WemanExercise {
  final String id;
  final String name;
  final String targetMuscle;
  final String difficulty;
  final String category;
  final String equipment;
  final String thumbnailUrl;
  final String repsSetsGuide;

  const WemanExercise({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.difficulty,
    required this.category,
    required this.equipment,
    required this.thumbnailUrl,
    required this.repsSetsGuide,
  });
}
