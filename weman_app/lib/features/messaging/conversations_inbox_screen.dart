import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/demo_state/demo_state.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class ConversationsInboxScreen extends ConsumerStatefulWidget {
  const ConversationsInboxScreen({super.key});

  @override
  ConsumerState<ConversationsInboxScreen> createState() =>
      _ConversationsInboxScreenState();
}

class _ConversationsInboxScreenState
    extends ConsumerState<ConversationsInboxScreen> {
  int _selectedTab = 0; // 0 = Direct Messages, 1 = Crew Channels
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final totalUnread = chatState.conversations
        .fold<int>(0, (sum, c) => sum + c.unreadCount);

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
          'Notify Inbox',
          style: TextStyle(
            color: WemanColors.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_outlined, color: WemanColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: WemanColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: WemanColors.surfaceWhite,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                key: const Key('inbox_search_field'),
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: WemanColors.secondary,
                    size: 20,
                  ),
                  hintText: 'Search athlete conversations or crews...',
                  hintStyle: const TextStyle(
                    color: WemanColors.secondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Tabs: Direct Messages vs Crew Channels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabItem(
                  0,
                  'DIRECT MESSAGES',
                  totalUnread > 0 ? '$totalUnread' : '${chatState.conversations.length}',
                ),
                const SizedBox(width: 24),
                _buildTabItem(1, 'CREW CHANNELS', '2'),
              ],
            ),
          ),
          const Divider(height: 1, color: WemanColors.border),

          // Conversation List
          Expanded(
            child: _selectedTab == 0
                ? _buildDirectMessages(chatState.conversations)
                : _buildCrewChannels(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, String countBadge) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? WemanColors.onSurface
                      : WemanColors.secondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? WemanColors.neonLime
                      : WemanColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  countBadge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? WemanColors.onSurface
                        : WemanColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? WemanColors.neonLime : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectMessages(List<WemanConversation> conversations) {
    var filtered = conversations;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = conversations.where((c) {
        return c.participantName.toLowerCase().contains(query) ||
            c.participantHandle.toLowerCase().contains(query) ||
            c.lastMessage.toLowerCase().contains(query);
      }).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No conversations found',
          style: WemanTypography.bodyMedium.copyWith(
            color: WemanColors.secondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final conv = filtered[index];
        return _buildConversationTile(
          key: Key('conversation_${conv.id}'),
          name: conv.participantName,
          badge: conv.badge,
          handle: conv.participantHandle,
          time: conv.lastTimestamp,
          timeColor: conv.timeColor,
          message: conv.lastMessage,
          avatarUrl: conv.avatarUrl,
          unreadCount: conv.unreadCount > 0 ? conv.unreadCount : null,
          hasBoltBadge: conv.hasBoltBadge,
          isGroup: conv.isGroup,
          statusIcon: conv.statusIcon,
          statusText: conv.statusText,
          isStatusRead: conv.isStatusRead,
          onTap: () {
            ref.read(chatProvider.notifier).markConversationAsRead(conv.id);
            context.push('/chat-detail', extra: conv.id);
          },
        );
      },
    );
  }

  Widget _buildCrewChannels() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCrewTile(
          name: 'Metro Sprint Club',
          time: '4m ago',
          preview: 'Coach Marcus: Track intervals locked for 7:00 PM tonight.',
          memberCount: '32 Athletes active',
          icon: Icons.electric_bolt,
        ),
        const SizedBox(height: 10),
        _buildCrewTile(
          name: 'Iron District Powerlifting',
          time: '2h ago',
          preview: 'Pavan: 180kg deadlift set verified! Platform clear.',
          memberCount: '18 Athletes active',
          icon: Icons.fitness_center,
        ),
      ],
    );
  }

  Widget _buildConversationTile({
    Key? key,
    required String name,
    required String handle,
    required String time,
    required String message,
    required String avatarUrl,
    required VoidCallback onTap,
    String? badge,
    Color? timeColor,
    int? unreadCount,
    bool hasBoltBadge = false,
    bool isGroup = false,
    IconData? statusIcon,
    String? statusText,
    bool isStatusRead = false,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WemanColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasBoltBadge
                        ? WemanColors.neonLime
                        : WemanColors.surfaceContainerHigh,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                if (hasBoltBadge)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: WemanColors.charcoal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bolt,
                        size: 12,
                        color: WemanColors.neonLime,
                      ),
                    ),
                  ),
                if (isGroup)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: WemanColors.charcoal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.groups,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: WemanTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: WemanColors.onSurface,
                            ),
                          ),
                          if (badge != null) ...[
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
                                badge,
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
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: timeColor ?? WemanColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: WemanTypography.bodySmall.copyWith(
                      color: unreadCount != null
                          ? WemanColors.onSurface
                          : WemanColors.secondary,
                      fontWeight: unreadCount != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        handle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: WemanColors.secondary,
                        ),
                      ),
                      if (unreadCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: WemanColors.neonLime,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: WemanColors.onSurface,
                            ),
                          ),
                        )
                      else if (statusIcon != null)
                        Row(
                          children: [
                            Icon(
                              statusIcon,
                              size: 14,
                              color: isStatusRead
                                  ? WemanColors.deepMoss
                                  : WemanColors.secondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              statusText ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: isStatusRead
                                    ? WemanColors.deepMoss
                                    : WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrewTile({
    required String name,
    required String time,
    required String preview,
    required String memberCount,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WemanColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: WemanColors.charcoal,
            child: Icon(icon, color: WemanColors.neonLime, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: WemanTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: WemanColors.deepMoss,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  preview,
                  style: WemanTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  memberCount,
                  style: const TextStyle(
                    fontSize: 11,
                    color: WemanColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
