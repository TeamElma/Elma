// lib/screens/inbox.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../messaging/models/chat_contact.dart';
import '../messaging/models/chat_message.dart';
import '../messaging/repositories/chat_repository.dart';
import 'message_screen.dart';

/// Displays your list of chat contacts (the “Inbox”).
class InboxScreen extends StatefulWidget {
  /// Supply your repository (or create a new one here).
  final ChatRepository chatRepository;

  const InboxScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  // Inbox is index 3 in our bottom bar.
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    // Seed some sample data if empty
    if (widget.chatRepository.contacts.isEmpty) {
      _addSampleData();
    }
  }

  void _addSampleData() {
    // Sample contacts
    final contacts = [
      ChatContact(id: '1', name: 'John Doe', avatarUrl: 'https://i.pravatar.cc/150?img=1'),
      ChatContact(id: '2', name: 'Jane Smith', avatarUrl: 'https://i.pravatar.cc/150?img=2'),
      ChatContact(id: '3', name: 'Mike Johnson', avatarUrl: 'https://i.pravatar.cc/150?img=3'),
    ];
    for (var c in contacts) {
      widget.chatRepository.debugAddContact(c);
    }

    // Sample messages
    final now = DateTime.now();
    final messages = [
      {
        'contactId': '1',
        'message': ChatMessage(
          id: 'm1',
          senderId: '1',
          text: 'Hello there!',
          timestamp: now.subtract(const Duration(minutes: 10)),
          isMe: false,
        ),
      },
      {
        'contactId': '1',
        'message': ChatMessage(
          id: 'm2',
          senderId: '0',
          text: 'Hi! How are you?',
          timestamp: now.subtract(const Duration(minutes: 5)),
          isMe: true,
        ),
      },
      {
        'contactId': '2',
        'message': ChatMessage(
          id: 'm3',
          senderId: '2',
          text: 'Meeting at 3pm',
          timestamp: now.subtract(const Duration(hours: 2)),
          isMe: false,
        ),
      },
    ];
    for (var entry in messages) {
      widget.chatRepository.debugAddMessage(
        entry['contactId'] as String,
        entry['message'] as ChatMessage,
      );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (time.isAfter(today)) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return '${time.month}/${time.day}/${time.year}';
    }
  }

  void _onTabTapped(int idx) {
    if (idx == _currentIndex) return;
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, '/explore');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/services');
        break;
      case 3:
      // already here
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = widget.chatRepository.contacts;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Inbox'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = contacts[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage:
              c.avatarUrl != null ? NetworkImage(c.avatarUrl!) : null,
              child: c.avatarUrl == null ? Text(c.name[0]) : null,
            ),
            title: Text(c.name, style: AppTextStyle.titleLarge),
            subtitle: c.lastMessage != null
                ? Text(
              c.lastMessage!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyLarge,
            )
                : const Text(
              'No messages yet',
              style:
              TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            trailing: c.lastMessageTime != null
                ? Text(
              _formatTime(c.lastMessageTime!),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
                : null,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessageScreen(
                    contact: c,
                    chatRepository: widget.chatRepository,
                  ),
                ),
              );
              setState(() {}); // refresh updated last message
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onTabTapped,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.room_service_outlined), label: 'Services'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), label: 'Inbox'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
