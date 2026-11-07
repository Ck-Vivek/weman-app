import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weman_app/core/demo_state/demo_state.dart';
import 'package:weman_app/features/messaging/chat_detail_screen.dart';
import 'package:weman_app/features/messaging/conversations_inbox_screen.dart';

// Test HTTP overrides to prevent network image errors during widget tests
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  group('ChatNotifier Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes with 5 demo conversations and separate message pools', () {
      final state = container.read(chatProvider);

      expect(state.conversations.length, 5);
      expect(state.conversations[0].id, 'maya_torres');
      expect(state.conversations[1].id, 'rohan_sharma');
      expect(state.conversations[2].id, 'iron_district_crew');
      expect(state.conversations[3].id, 'alex_chen');
      expect(state.conversations[4].id, 'aanya_patel');

      // Unread counts
      expect(state.conversations[0].unreadCount, 2);
      expect(state.conversations[1].unreadCount, 0);
      expect(state.conversations[2].unreadCount, 5);

      // Separate message pools
      expect(state.messagesByConversation['maya_torres']?.length, 5);
      expect(state.messagesByConversation['rohan_sharma']?.length, 2);
      expect(state.messagesByConversation['iron_district_crew']?.length, 1);
    });

    test('sendMessage appends new message and updates conversation preview', () {
      final notifier = container.read(chatProvider.notifier);

      final success = notifier.sendMessage(
        conversationId: 'maya_torres',
        text: 'Thanks coach, looking forward to Friday!',
      );

      expect(success, isTrue);

      final state = container.read(chatProvider);
      final mayaMessages = state.messagesByConversation['maya_torres']!;
      expect(mayaMessages.length, 6);
      expect(mayaMessages.last.text, 'Thanks coach, looking forward to Friday!');
      expect(mayaMessages.last.isOutgoing, isTrue);
      expect(mayaMessages.last.time, 'Just now');

      // Check conversation metadata update and bump to top
      final updatedConv = state.conversations.firstWhere((c) => c.id == 'maya_torres');
      expect(updatedConv.lastMessage, 'Thanks coach, looking forward to Friday!');
      expect(updatedConv.lastTimestamp, 'Just now');
      expect(state.conversations.first.id, 'maya_torres');
    });

    test('sendMessage rejects empty and whitespace-only text', () {
      final notifier = container.read(chatProvider.notifier);

      final emptyResult = notifier.sendMessage(
        conversationId: 'maya_torres',
        text: '',
      );
      expect(emptyResult, isFalse);

      final whitespaceResult = notifier.sendMessage(
        conversationId: 'maya_torres',
        text: '   \n\t  ',
      );
      expect(whitespaceResult, isFalse);

      // Message count remains untouched
      final state = container.read(chatProvider);
      expect(state.messagesByConversation['maya_torres']?.length, 5);
    });

    test('sendMessage partitions messages by conversation ID without crosstalk', () {
      final notifier = container.read(chatProvider.notifier);

      notifier.sendMessage(
        conversationId: 'rohan_sharma',
        text: 'Are we hitting deadlifts together?',
      );

      final state = container.read(chatProvider);

      // Rohan's conversation updated
      expect(state.messagesByConversation['rohan_sharma']?.length, 3);
      expect(state.messagesByConversation['rohan_sharma']?.last.text,
          'Are we hitting deadlifts together?');

      // Maya's conversation untouched
      expect(state.messagesByConversation['maya_torres']?.length, 5);
      expect(state.messagesByConversation['maya_torres']?.last.text,
          'Perfect. Keep the bracing tight and maintain intra-abdominal pressure.');
    });

    test('markConversationAsRead resets unread count to 0', () {
      final notifier = container.read(chatProvider.notifier);

      // Before: Maya Torres has 2 unread
      expect(container.read(chatProvider).conversations.firstWhere((c) => c.id == 'maya_torres').unreadCount, 2);

      notifier.markConversationAsRead('maya_torres');

      // After: Maya Torres has 0 unread
      expect(container.read(chatProvider).conversations.firstWhere((c) => c.id == 'maya_torres').unreadCount, 0);
    });
  });

  group('ChatDetailScreen & Inbox Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('ChatDetailScreen renders conversation header and messages',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('Maya Torres'), findsOneWidget);
      expect(find.text('COACH'), findsOneWidget);
      expect(find.text('@maya.fit'), findsOneWidget);

      // Verify initial demo messages
      expect(find.text('Hey Pavan! Saw your 180kg deadlift PR check-in on the feed. Solid hip drive! 💥'),
          findsOneWidget);
      expect(find.text('Thanks Maya! Felt really explosive off the floor. Tweaked my setup as you suggested.'),
          findsOneWidget);
    });

    testWidgets('ChatDetailScreen sends message, clears input, and displays immediately',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter message
      final inputFinder = find.byKey(const Key('chat_message_input'));
      expect(inputFinder, findsOneWidget);
      await tester.enterText(inputFinder, 'Just completed accessory core set!');

      // Tap send
      final sendFinder = find.byKey(const Key('chat_send_button'));
      await tester.tap(sendFinder);
      await tester.pumpAndSettle();

      // Input field should be cleared
      final textField = tester.widget<TextField>(inputFinder);
      expect(textField.controller?.text, isEmpty);

      // Sent message should appear immediately on screen
      expect(find.text('Just completed accessory core set!'), findsOneWidget);
    });

    testWidgets('ChatDetailScreen rejects sending whitespace-only input',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final initialMsgCount = container.read(chatProvider).messagesByConversation['maya_torres']!.length;

      // Enter only whitespace
      final inputFinder = find.byKey(const Key('chat_message_input'));
      await tester.enterText(inputFinder, '     ');

      final sendFinder = find.byKey(const Key('chat_send_button'));
      await tester.tap(sendFinder);
      await tester.pumpAndSettle();

      // Message count remains unchanged
      final currentMsgCount = container.read(chatProvider).messagesByConversation['maya_torres']!.length;
      expect(currentMsgCount, initialMsgCount);
    });

    testWidgets('Reopening conversation retains sent messages in current app session',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // 1. Open conversation
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 2. Send message
      await tester.enterText(
          find.byKey(const Key('chat_message_input')), 'Session-persistent test message!');
      await tester.tap(find.byKey(const Key('chat_send_button')));
      await tester.pumpAndSettle();

      expect(find.text('Session-persistent test message!'), findsOneWidget);

      // 3. Simulate leaving conversation (render dummy screen)
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: Text('Another Screen')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Another Screen'), findsOneWidget);
      expect(find.text('Session-persistent test message!'), findsNothing);

      // 4. Reopen conversation
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 5. Verify the message is still present!
      expect(find.text('Session-persistent test message!'), findsOneWidget);
    });

    testWidgets('Switching between conversations keeps messages and headers isolated',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Open Maya Torres
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'maya_torres'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Maya Torres'), findsOneWidget);
      expect(find.text('Hey Pavan! Saw your 180kg deadlift PR check-in on the feed. Solid hip drive! 💥'),
          findsOneWidget);
      expect(find.text('Rohan Sharma'), findsNothing);

      // Switch to Rohan Sharma
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatDetailScreen(conversationId: 'rohan_sharma'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rohan Sharma'), findsOneWidget);
      expect(find.text('@rohan.lifts'), findsOneWidget);
      expect(find.text('Sent an image: Post-workout protein bowl 🥗'), findsOneWidget);
      expect(find.text('Hey Pavan! Saw your 180kg deadlift PR check-in on the feed. Solid hip drive! 💥'),
          findsNothing);
    });

    testWidgets('ConversationsInboxScreen reflects updated preview and cleared unread count',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Send a message via provider directly to Maya
      container.read(chatProvider.notifier).sendMessage(
            conversationId: 'maya_torres',
            text: 'Locked in for tomorrow morning!',
          );

      // Mark Maya as read
      container.read(chatProvider.notifier).markConversationAsRead('maya_torres');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ConversationsInboxScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify updated preview is visible in the inbox
      expect(find.text('Locked in for tomorrow morning!'), findsOneWidget);

      // Verify Maya's unread badge '2' is no longer displayed
      expect(find.text('2'), findsNWidgets(1)); // Only the Crew Channels '2' badge in the tab header
    });
  });
}
