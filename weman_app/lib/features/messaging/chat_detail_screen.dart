import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailScreen({
    super.key,
    this.conversationId = 'maya_torres',
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark conversation as read upon entering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(chatProvider.notifier).markConversationAsRead(widget.conversationId);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _textController.text.trim();
    if (text.isEmpty) return;

    final success = ref.read(chatProvider.notifier).sendMessage(
          conversationId: widget.conversationId,
          text: text,
        );

    if (success && customText == null) {
      _textController.clear();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages =
        chatState.messagesByConversation[widget.conversationId] ?? const [];

    final conversation = chatState.conversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => const WemanConversation(
        id: 'unknown',
        participantName: 'Athlete',
        participantHandle: '@athlete',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB4WnhnmY8wJ5adD31MNRs5MtqgCfNfqV6XznomGTFUyT3LzJzfFiFZPyD2Nxkg5yw6bq_uTyKYCw2CyoAbUit3t70SUNWq3iXn-jYO6QJbP7tK-5KAq3KRtuGLXTOhnwYR-bHVXaHVZQBkpEGPJjVKnez20peVLC9cNIZ4lv-3-cfpfixugsTJwvwCTJJzFMFvkRd9vy3kjpUTz8WsDDnaZ6WTuehX08FLbxDdb_M-kIRuu14ckH_-',
        lastMessage: '',
        lastTimestamp: '',
      ),
    );

    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: WemanColors.neonLime,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(conversation.avatarUrl),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WemanColors.neonLime,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        conversation.participantName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      if (conversation.badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: WemanColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            conversation.badge!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: WemanColors.deepMoss,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        conversation.participantHandle.split(' • ').first,
                        style: WemanTypography.labelSmall.copyWith(
                          fontSize: 11,
                          color: WemanColors.secondary,
                        ),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(color: WemanColors.secondary),
                      ),
                      Text(
                        conversation.statusText ?? 'Active in Gym now',
                        style: WemanTypography.labelSmall.copyWith(
                          fontSize: 11,
                          color: WemanColors.deepMoss,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, color: WemanColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined,
                color: WemanColors.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Security Channel Pill
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: WemanColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 12, color: WemanColors.deepMoss),
                  SizedBox(width: 6),
                  Text(
                    'Verified Athlete Channel • TLS 1.3 Protected',
                    style: TextStyle(
                      fontSize: 11,
                      color: WemanColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat Feed
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WemanColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'TODAY, OCT 24',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: WemanColors.secondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }
                final msg = messages[index - 1];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Message Input Dock
          _buildInputDock(conversation.participantName),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isOutgoing) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 290),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: WemanColors.charcoal,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        msg.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: WemanColors.secondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.done_all,
                  size: 14,
                  color: WemanColors.neonLime,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 310),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: WemanColors.onSurface,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (msg.hasExerciseCard) ...[
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: WemanColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC6BPuZIICVc2Sq8r_dtFscAFhDAEm_AjCbaQifteFzYFCVsTYuv9sa90iMYJ5-wRcNSVeR9azMINBqvqmE5xN9K-MUOIEn5iZ9XjGV9MX9OrqnfKZuzk3cqNQLO2rCfAi_xTR_H_Kl9v1xDEMb1bnqtaB_4qQ6w0LLGegKz7xyNgjuipnZSVxeOC15O3NzPRmrPOKLJRnRTAFkend_AeV3cZEyPxynZBA1WsCnQz4U5zpAIEz-m7Ax',
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    color: const Color(0xFF2E3132),
                                    child: const Center(
                                      child: Icon(
                                        Icons.fitness_center,
                                        color: WemanColors.neonLime,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Accessory Core',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: WemanColors.neonLime,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Level 3',
                                    style: TextStyle(
                                      color: WemanColors.onSurface,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hanging Leg Raises & Core Anti-Extension',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: WemanColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '4 Sets × 12-15 Reps',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: WemanColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        context.push('/workout-details'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: WemanColors.neonLime,
                                      foregroundColor: WemanColors.onSurface,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Inspect Drill',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: const TextStyle(
                fontSize: 10,
                color: WemanColors.secondary,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInputDock(String participantName) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Action Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionPill('🏋️', 'Lifting',
                    () => _sendMessage('🏋️ Heavy lifting set locked in!')),
                const SizedBox(width: 8),
                _buildQuickActionPill('⚡', 'Power',
                    () => _sendMessage('⚡ Power output felt phenomenal!')),
                const SizedBox(width: 8),
                _buildQuickActionPill(
                    '💪', 'Pump', () => _sendMessage('💪 Bracing felt great!')),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Text Field Row
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: WemanColors.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: WemanColors.onSurface),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: WemanColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const Key('chat_message_input'),
                          controller: _textController,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Message ${participantName.split(' ').first}...',
                            hintStyle: const TextStyle(
                              color: WemanColors.secondary,
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: WemanColors.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.mic_none,
                          color: WemanColors.secondary,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                key: const Key('chat_send_button'),
                onTap: () => _sendMessage(),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: WemanColors.neonLime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 20,
                    color: WemanColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionPill(String emoji, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: WemanColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: WemanColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
