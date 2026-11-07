import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/weman_colors.dart';

/// Single chat message representation.
class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isOutgoing;
  final String? imageUrl;
  final bool hasExerciseCard;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isOutgoing,
    this.imageUrl,
    this.hasExerciseCard = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    String? time,
    bool? isOutgoing,
    String? imageUrl,
    bool? hasExerciseCard,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      time: time ?? this.time,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      imageUrl: imageUrl ?? this.imageUrl,
      hasExerciseCard: hasExerciseCard ?? this.hasExerciseCard,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          time == other.time &&
          isOutgoing == other.isOutgoing &&
          imageUrl == other.imageUrl &&
          hasExerciseCard == other.hasExerciseCard;

  @override
  int get hashCode => Object.hash(
        id,
        text,
        time,
        isOutgoing,
        imageUrl,
        hasExerciseCard,
      );
}

/// Conversation metadata model for WEMAN FIT Inbox.
class WemanConversation {
  final String id;
  final String participantName;
  final String participantHandle;
  final String avatarUrl;
  final String lastMessage;
  final String lastTimestamp;
  final int unreadCount;
  final bool isOnline;
  final String? badge;
  final bool hasBoltBadge;
  final bool isGroup;
  final String? statusText;
  final IconData? statusIcon;
  final bool isStatusRead;
  final Color? timeColor;

  const WemanConversation({
    required this.id,
    required this.participantName,
    required this.participantHandle,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastTimestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    this.badge,
    this.hasBoltBadge = false,
    this.isGroup = false,
    this.statusText,
    this.statusIcon,
    this.isStatusRead = false,
    this.timeColor,
  });

  WemanConversation copyWith({
    String? id,
    String? participantName,
    String? participantHandle,
    String? avatarUrl,
    String? lastMessage,
    String? lastTimestamp,
    int? unreadCount,
    bool? isOnline,
    String? badge,
    bool? hasBoltBadge,
    bool? isGroup,
    String? statusText,
    IconData? statusIcon,
    bool? isStatusRead,
    Color? timeColor,
  }) {
    return WemanConversation(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantHandle: participantHandle ?? this.participantHandle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      badge: badge ?? this.badge,
      hasBoltBadge: hasBoltBadge ?? this.hasBoltBadge,
      isGroup: isGroup ?? this.isGroup,
      statusText: statusText ?? this.statusText,
      statusIcon: statusIcon ?? this.statusIcon,
      isStatusRead: isStatusRead ?? this.isStatusRead,
      timeColor: timeColor ?? this.timeColor,
    );
  }
}

/// Combined state for WEMAN FIT messaging and inbox.
class ChatState {
  final List<WemanConversation> conversations;
  final Map<String, List<ChatMessage>> messagesByConversation;

  const ChatState({
    required this.conversations,
    required this.messagesByConversation,
  });

  ChatState copyWith({
    List<WemanConversation>? conversations,
    Map<String, List<ChatMessage>>? messagesByConversation,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      messagesByConversation:
          messagesByConversation ?? this.messagesByConversation,
    );
  }
}

/// Riverpod StateNotifier managing in-session chat and inbox state.
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(_buildInitialState());

  static ChatState _buildInitialState() {
    final conversations = <WemanConversation>[
      const WemanConversation(
        id: 'maya_torres',
        participantName: 'Maya Torres',
        participantHandle: '@maya.fit • Master Coach',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB4WnhnmY8wJ5adD31MNRs5MtqgCfNfqV6XznomGTFUyT3LzJzfFiFZPyD2Nxkg5yw6bq_uTyKYCw2CyoAbUit3t70SUNWq3iXn-jYO6QJbP7tK-5KAq3KRtuGLXTOhnwYR-bHVXaHVZQBkpEGPJjVKnez20peVLC9cNIZ4lv-3-cfpfixugsTJwvwCTJJzFMFvkRd9vy3kjpUTz8WsDDnaZ6WTuehX08FLbxDdb_M-kIRuu14ckH_-',
        lastMessage:
            'Great form on that 180kg deadlift video! Try widening your grip slightly.',
        lastTimestamp: '10m ago',
        unreadCount: 2,
        isOnline: true,
        badge: 'COACH',
        hasBoltBadge: true,
        timeColor: WemanColors.deepMoss,
        statusText: 'Active in Gym now',
      ),
      const WemanConversation(
        id: 'rohan_sharma',
        participantName: 'Rohan Sharma',
        participantHandle: '@rohan.lifts',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCmF7CNoxwRBJFH9irs9sHwd8JZQKcCOFMnOJvdXysjGgw2VyNqZc-k4iTimc_zmp0tD2r-t4JQPE-Aa_38tUEA84Be9JEpRw9luXk16PBHIVkLnyhhYs6JtUhZ4k2VYHrUeG7pSFiF1hae8mlaSNfyr6iBzu-XbyNjYZPfEG0GvpUgBYioyYzY4tn7cxzY2U3TxazPH2txMHO1njwnLf14Ala4bKHYImprwDKNKtJFyXgER6gywGdO',
        lastMessage: 'Sent an image: Post-workout protein bowl 🥗',
        lastTimestamp: '1h ago',
        unreadCount: 0,
        statusIcon: Icons.done_all,
        statusText: 'Read',
        isStatusRead: true,
      ),
      const WemanConversation(
        id: 'iron_district_crew',
        participantName: 'Iron District Crew',
        participantHandle: '14 Members active',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD8FeGwX7XqAHBOuSN6avYbSbyAuQe_MPFi24ORvkdqEudjRcyjSNDeSE5ro0-I4DNWW1N83IfqeB__48C3hWRrE_rmo3pZBwYG3dk9YxQBvy-aMPpnuP3xxsZx01q8VtaOO4kpOtv_59UIhcqXJytEpHbwJGm-9AG_xiLvB85Tf2NGF3wqBj_xNeWYvBflNsqdpy7NystKUpvEuqddCyLt-Ify3FG_wrHMFwmaJhcMCf0VjkDQC3gE',
        lastMessage: 'Dev: Anyone hitting morning legs at 6:30 AM tomorrow?',
        lastTimestamp: '3h ago',
        unreadCount: 5,
        isGroup: true,
        timeColor: WemanColors.deepMoss,
      ),
      const WemanConversation(
        id: 'alex_chen',
        participantName: 'Coach Alex Chen',
        participantHandle: '@alex.coach',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDRRnuHkjw-VHbGxIxay4iLhEi0VoUISf1FcUMtcv73vvmOb2IQ4bJ8oHIbZuRV1dImfgLo2olMFu08tN2zvNhta5PlGm2uACOCT06ixmG9sapRDR8fIxCyinaACQghK1PGgXpGYZ8QYv3NhrvIEDQ4EWAxBAF7P2zf62Bn5oXSJcnfinq8XHC3l2A1Ws4-PJeyV1PKFyA-Uvu8nh_8_CD0AQg-9KXdQrGqCSF7aWEWHAtJJaL5d_Co',
        lastMessage:
            'Your weekly volume targets are calibrated for Hyrox prep.',
        lastTimestamp: 'Yesterday',
        unreadCount: 0,
        statusIcon: Icons.done,
        statusText: 'Delivered',
        isStatusRead: false,
      ),
      const WemanConversation(
        id: 'aanya_patel',
        participantName: 'Aanya Patel',
        participantHandle: '@aanya.run',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDD0JU5vA4toFYft4CHGiz2NlIrnO2-jLld99QFDDuFRw9aMPipmkwHpuN1hC4_rfyFwJnLzGZUlyatdXNUIefT8vY21sfUKRmB8ICIBWyoAyOibZty5Q-7jlDA3umsLc0zkRgGGxy4J09y2FsR0MhopotXx-6W1x-IZfU0Vq5PJUnsDA6qKEHQUUsakKI9ZSkymL9PQWD1tN01crFdAp8_o1KnlVQbV8URYFGPBA7TXCKsHrGsMXqA',
        lastMessage: 'Shared routine: Core & Abdominals Sculpt ⚡',
        lastTimestamp: 'Oct 22',
        unreadCount: 0,
        statusIcon: Icons.done_all,
        statusText: 'Saved to log',
        isStatusRead: true,
      ),
    ];

    final messagesByConversation = <String, List<ChatMessage>>{
      'maya_torres': [
        const ChatMessage(
          id: 'maya_msg_1',
          text:
              'Hey Pavan! Saw your 180kg deadlift PR check-in on the feed. Solid hip drive! 💥',
          time: '09:15 AM',
          isOutgoing: false,
        ),
        const ChatMessage(
          id: 'maya_msg_2',
          text:
              'Thanks Maya! Felt really explosive off the floor. Tweaked my setup as you suggested.',
          time: '09:18 AM',
          isOutgoing: true,
        ),
        const ChatMessage(
          id: 'maya_msg_3',
          text:
              'Take a look at this accessory drill to pair with your deadlifts:',
          time: '09:21 AM',
          isOutgoing: false,
          hasExerciseCard: true,
        ),
        const ChatMessage(
          id: 'maya_msg_4',
          text: "Got the new lever belt calibrated for Friday's heavy session!",
          time: '09:24 AM',
          isOutgoing: true,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCOeM--XGM-GRpwatth6vFV451PZ2bKnCZWDqSFYh1GZwQXqc-H4gdr_P0SQrWcBTFmgsVeVK2Ip5Dk2Qn77stK5V7U4nDZafRBOBrxNwWoxxEmNX1Ui41cZbhsGDaTcV-yVHfkmlU_wURCLP-raKlG6b26tQPp21wUCtW6xcgVrgrIx9CRAsAkoqi9uOEL_0lu2jKI3wCNCmrqiSZO2L81Z8c-bCZXlft60rSWUDd8bgQ9W11BbSnx',
        ),
        const ChatMessage(
          id: 'maya_msg_5',
          text:
              'Perfect. Keep the bracing tight and maintain intra-abdominal pressure.',
          time: '09:25 AM',
          isOutgoing: false,
        ),
      ],
      'rohan_sharma': [
        const ChatMessage(
          id: 'rohan_msg_1',
          text: 'Hey Pavan! Are you heading to the gym this afternoon?',
          time: '10:00 AM',
          isOutgoing: false,
        ),
        const ChatMessage(
          id: 'rohan_msg_2',
          text: 'Sent an image: Post-workout protein bowl 🥗',
          time: '1h ago',
          isOutgoing: false,
        ),
      ],
      'iron_district_crew': [
        const ChatMessage(
          id: 'crew_msg_1',
          text: 'Dev: Anyone hitting morning legs at 6:30 AM tomorrow?',
          time: '3h ago',
          isOutgoing: false,
        ),
      ],
      'alex_chen': [
        const ChatMessage(
          id: 'alex_msg_1',
          text: 'Your weekly volume targets are calibrated for Hyrox prep.',
          time: 'Yesterday',
          isOutgoing: false,
        ),
      ],
      'aanya_patel': [
        const ChatMessage(
          id: 'aanya_msg_1',
          text: 'Shared routine: Core & Abdominals Sculpt ⚡',
          time: 'Oct 22',
          isOutgoing: false,
        ),
      ],
    };

    return ChatState(
      conversations: conversations,
      messagesByConversation: messagesByConversation,
    );
  }

  /// Sends a message to a conversation. Rejects empty or whitespace-only messages.
  ///
  /// Immediately appends the new message, updates the conversation's
  /// preview and timestamp, and moves it to the front of the inbox.
  bool sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
    bool hasExerciseCard = false,
  }) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return false;
    }

    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
      text: cleanText,
      time: 'Just now',
      isOutgoing: true,
      imageUrl: imageUrl,
      hasExerciseCard: hasExerciseCard,
    );

    final currentMessages =
        List<ChatMessage>.from(state.messagesByConversation[conversationId] ?? []);
    currentMessages.add(newMessage);

    final updatedMessagesMap =
        Map<String, List<ChatMessage>>.from(state.messagesByConversation);
    updatedMessagesMap[conversationId] = currentMessages;

    // Update conversation metadata and bump to top
    final currentConversations = List<WemanConversation>.from(state.conversations);
    final convIndex =
        currentConversations.indexWhere((c) => c.id == conversationId);

    if (convIndex != -1) {
      final oldConv = currentConversations.removeAt(convIndex);
      final updatedConv = oldConv.copyWith(
        lastMessage: cleanText,
        lastTimestamp: 'Just now',
      );
      currentConversations.insert(0, updatedConv);
    }

    state = state.copyWith(
      conversations: currentConversations,
      messagesByConversation: updatedMessagesMap,
    );
    return true;
  }

  /// Resets unread counter for a conversation upon opening.
  void markConversationAsRead(String conversationId) {
    final convIndex =
        state.conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex == -1) return;

    final conv = state.conversations[convIndex];
    if (conv.unreadCount == 0) return;

    final updatedConversations =
        List<WemanConversation>.from(state.conversations);
    updatedConversations[convIndex] = conv.copyWith(unreadCount: 0);

    state = state.copyWith(conversations: updatedConversations);
  }

  /// Resets chat and inbox state back to initial baseline for testing.
  void reset() {
    state = _buildInitialState();
  }
}

/// Global Riverpod provider for messaging and inbox state.
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
