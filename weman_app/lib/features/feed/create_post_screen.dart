import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../models/models.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController(
    text:
        'Clean 180kg deadlift triple today! Hip drive felt effortless with the morning crew 💥🏋️‍♂️',
  );

  String _selectedCategory = 'Workout';
  final List<String> _categories = [
    'Workout',
    'Nutrition',
    'Progress',
    'Stretching',
    'Running',
    'Outdoor',
  ];

  final String _selectedLocation = 'Iron Arena Gym, Bangalore';
  bool _hasMedia = true;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _insertEmoji(String emoji) {
    final text = _captionController.text;
    final selection = _captionController.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, emoji);
      _captionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + emoji.length,
        ),
      );
    } else {
      _captionController.text += emoji;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'CREATE POST',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined, color: WemanColors.onSurface),
            onPressed: () => context.push('/inbox'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: WemanColors.neonLime, width: 2),
              ),
              child: const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/pavan_avatar.png'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Chip & Audience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          AssetImage('assets/images/pavan_avatar.png'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(profile.name, style: WemanTypography.titleMedium),
                            const SizedBox(width: 4),
                            Text(
                              '(${profile.handle})',
                              style: WemanTypography.bodySmall.copyWith(
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: WemanColors.softLime,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium,
                                size: 12,
                                color: WemanColors.onSurface,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'MASTER ATHLETE',
                                style: WemanTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: WemanColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: WemanColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: WemanColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.public,
                        size: 14,
                        color: WemanColors.deepMoss,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Public',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.expand_more,
                        size: 16,
                        color: WemanColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Media Preview Stage
            if (_hasMedia)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: WemanColors.surfaceWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAZjjSA0IKNP6RXf7kENfVmvjvAvCPnqzV2Vf6lE3C4mhkieFpzCwK5vhnRfK8AYsRLD-YiEZyl1wDxhyer3l-7owrkijMDoaQIUl6p0_pitHo06pX2TbJu0dg3CxzMgCEvx4zPQX-A8HTqCUxkvzZZwmADue220CmbxrXG2E0Yqw03rXfrRXlUUeptjebf0z_i_Ftp74D8WHgNImmGTVmiWyJ7vkpzdXrWpr2vrzOspsbrwMayfPbG',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: const Color(0xFF2E3132),
                          child: const Center(
                            child: Icon(
                              Icons.fitness_center,
                              color: WemanColors.neonLime,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Top Left PR Captured Pill
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: WemanColors.neonLime,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'PR CAPTURED',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: WemanColors.onSurface,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Top Right Quick Pickers
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          _buildMediaIconButton(Icons.photo_camera, () {}),
                          const SizedBox(width: 8),
                          _buildMediaIconButton(Icons.photo_library, () {}),
                        ],
                      ),
                    ),
                    // Bottom Action Chips
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildOverlayChip(
                            Icons.sync,
                            'Replace Photo',
                            WemanColors.deepMoss,
                            () {},
                          ),
                          _buildOverlayChip(
                            Icons.delete_outline,
                            'Remove',
                            Colors.redAccent,
                            () => setState(() => _hasMedia = false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: () => setState(() => _hasMedia = true),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: WemanColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: WemanColors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 36,
                        color: WemanColors.secondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to attach workout photo or video',
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Caption Area
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WemanColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WORKOUT NOTES & STORY',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '${_captionController.text.length} / 300',
                        style: WemanTypography.labelSmall.copyWith(
                          color: WemanColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _captionController,
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'Share your workout milestone, PR, or daily fuel...',
                      hintStyle: TextStyle(
                        color: WemanColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                    style: WemanTypography.bodyMedium.copyWith(
                      color: WemanColors.onSurface,
                    ),
                  ),
                  const Divider(color: WemanColors.border),
                  // Emoji row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Quick:',
                          style: WemanTypography.labelSmall.copyWith(
                            color: WemanColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...['🔥', '⚡', '💪', '🏋️', '🥗', '🎯', '⏱️', '🏆'].map(
                          (emoji) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => _insertEmoji(emoji),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: WemanColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Category Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category', style: WemanTypography.titleSmall),
                Text(
                  '1 Selected',
                  style: WemanTypography.labelSmall.copyWith(
                    color: WemanColors.deepMoss,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = category);
                      },
                      selectedColor: WemanColors.neonLime,
                      backgroundColor: WemanColors.surfaceWhite,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? WemanColors.onSurface
                            : WemanColors.secondary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? WemanColors.neonLime
                              : WemanColors.border,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Location Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WemanColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: WemanColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 18,
                      color: WemanColors.deepMoss,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GYM / TRAINING VENUE',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: WemanColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          _selectedLocation,
                          style: WemanTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: WemanColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: WemanColors.neonLime,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Feed Simulation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Feed Preview', style: WemanTypography.titleSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      size: 14,
                      color: WemanColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Live simulation',
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WemanColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/images/pavan_avatar.png'),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pavan',
                                style: WemanTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Just now • Bangalore',
                                style: WemanTypography.labelSmall.copyWith(
                                  fontSize: 10,
                                  color: WemanColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: WemanColors.neonLime,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedCategory.toUpperCase(),
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: WemanColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _captionController.text.isEmpty
                        ? 'Share your workout milestone, PR, or daily fuel...'
                        : _captionController.text,
                    style: WemanTypography.bodySmall.copyWith(
                      color: WemanColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Telemetry Chips
                  Row(
                    children: [
                      _buildTelemetryItem('LIFT', 'Deadlift'),
                      const SizedBox(width: 6),
                      _buildTelemetryItem('WEIGHT', '180 kg'),
                      const SizedBox(width: 6),
                      _buildTelemetryItem('SETS', '3 sets'),
                      const SizedBox(width: 6),
                      _buildTelemetryItem('REPS', '3 reps'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Share Button CTA
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  final caption = _captionController.text.trim();
                  if (caption.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter workout notes or story.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  final newPost = WemanFeedPost(
                    id: 'post-${DateTime.now().millisecondsSinceEpoch}',
                    author: WemanUser(
                      id: profile.id,
                      name: profile.name,
                      handle: profile.handle,
                      avatarUrl:
                          'https://lh3.googleusercontent.com/aida/AEtjO1X5Nj9Se13MRhEdx0DUW0NEIAabzUdDCNr-Qiwd9Dp-vagjDLTDgbcrWOd6bO0pbTwLx1gwW8EGf8pYA41kC7HekPJPiPffiAzsEkZCF3Bdi_5XNrUiJvVlzg4uuDJwKg3bmNp2od0jpr_mUIonYAI42iqH8iWQfMYZYvBJAey8z-fFwgNPNtwV1rqcMzAaYxEPHySmTfS1p1NWMg4zwCaIh-zrHalrDDBcklSRUevnQZVI2YNvLbVpZQ',
                      college: profile.college,
                      isVerifiedTrainer: true,
                    ),
                    authorRole: 'Master Athlete',
                    postType: _selectedCategory.toLowerCase() == 'nutrition'
                        ? 'nutrition'
                        : _selectedCategory.toLowerCase() == 'running'
                            ? 'running'
                            : 'strength',
                    categoryTag: _selectedCategory.toUpperCase(),
                    exerciseTag: _selectedCategory == 'Workout'
                        ? 'Deadlift PR'
                        : _selectedCategory,
                    exerciseName: _selectedCategory == 'Workout'
                        ? 'Conventional Deadlift'
                        : '$_selectedCategory Session',
                    imageBadgeTop:
                        _hasMedia ? '$_selectedCategory • 180 kg' : null,
                    timerBadge: 'Just now',
                    rpeBadge: 'RPE 8.5',
                    routineButtonText: 'TRY ROUTINE (4 EXERCISES)',
                    metrics: {
                      'LIFT': 'Deadlift',
                      'WEIGHT': '180 kg',
                      'SETS': '3',
                      'REPS': '3',
                    },
                    location: _selectedLocation,
                    content: caption,
                    imageUrl: _hasMedia
                        ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuCor2V2WtuahNK_cJsRlxMMcunM3iBgM1kQE3OukdVd6bmb0maitoBfFozFXSvVTfWs2vr6HYy2sSHxP3Q_YplgbKihLkQfd0_nTB5H1lASpXSx8S-HEvR3Ayu5i37mO98duWxscNZg6_uHZJJMq0OzRdkzA6KKH2QWAnthoiChzuYoWqrT8pLLb8t8dyEyAGR9iSPexviY4NqxlXv-GtG8h5NFALncU9qy49Ps5LxWrGAHtfy8r-RA'
                        : null,
                    likesCount: 1,
                    commentsCount: 0,
                    sharesCount: 0,
                    timestamp: 'Just now • Bangalore',
                    isLiked: true,
                    isSaved: false,
                  );

                  ref.read(feedProvider.notifier).addPost(newPost);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: WemanColors.neonLime),
                          SizedBox(width: 8),
                          Text(
                            'Workout post shared to WEMAN FIT feed!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: WemanColors.charcoal,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WemanColors.neonLime,
                  foregroundColor: WemanColors.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SHARE POST',
                      style: WemanTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: WemanColors.onSurface),
      ),
    );
  }

  Widget _buildOverlayChip(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: WemanColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: WemanColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: WemanColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
