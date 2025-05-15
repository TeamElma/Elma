// lib/screens/inbox.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../messaging/models/chat_contact.dart';
import '../messaging/models/chat_message.dart';
import '../messaging/repositories/chat_repository.dart';
import 'message_screen.dart';

/// Displays your list of chat contacts (the "Inbox").
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
    // Sort contacts by last message time, newest first
    // This might be better done in the repository or when data is fetched in a real app
    // widget.chatRepository.contacts.sort((a, b) {
    //   if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
    //   if (a.lastMessageTime == null) return 1; // a is null, b is not, so b comes first
    //   if (b.lastMessageTime == null) return -1; // b is null, a is not, so a comes first
    //   return b.lastMessageTime!.compareTo(a.lastMessageTime!); // newest first
    // });
  }

  void _addSampleData() {
    // Sample contacts
    final contacts = [
      ChatContact(id: '1', name: 'John Doe', avatarUrl: 'https://i.pravatar.cc/150?img=1'),
      ChatContact(id: '2', name: 'Jane Smith', avatarUrl: 'https://i.pravatar.cc/150?img=2'),
      ChatContact(id: '3', name: 'Mike Johnson', avatarUrl: 'https://i.pravatar.cc/150?img=3'),
      ChatContact(id: '4', name: 'Sarah Williams', avatarUrl: 'https://i.pravatar.cc/150?img=4'), // New contact
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
          text: 'Hey, how are you doing? Let\'s catch up soon!',
          timestamp: now.subtract(const Duration(minutes: 10)),
          isMe: false,
        ),
      },
      {
        'contactId': '1',
        'message': ChatMessage(
          id: 'm2',
          senderId: '0',
          text: 'Sounds great! I am free tomorrow afternoon.',
          timestamp: now.subtract(const Duration(minutes: 5)),
          isMe: true,
        ),
      },
      {
        'contactId': '2',
        'message': ChatMessage(
          id: 'm3',
          senderId: '2',
          text: 'Just confirming our meeting for 3 PM today.',
          timestamp: now.subtract(const Duration(hours: 2)),
          isMe: false,
        ),
      },
      {
        'contactId': '3',
        'message': ChatMessage(
          id: 'm4',
          senderId: '3',
          text: 'Can you send over the project proposal?',
          timestamp: now.subtract(const Duration(days: 1, hours: 5)),
          isMe: false,
        ),
      },
      {
        'contactId': '4',
        'message': ChatMessage(
          id: 'm5',
          senderId: '4',
          text: 'Welcome to Elma! Happy to connect.',
          timestamp: now.subtract(const Duration(days: 2)),
          isMe: false,
        ),
      }
    ];
    for (var entry in messages) {
      widget.chatRepository.debugAddMessage(
        entry['contactId'] as String,
        entry['message'] as ChatMessage,
      );
    }
    // Ensure contacts are sorted after adding all messages
    // widget.chatRepository.contacts.sort((a, b) {
    //   if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
    //   if (a.lastMessageTime == null) return 1;
    //   if (b.lastMessageTime == null) return -1;
    //   return b.lastMessageTime!.compareTo(a.lastMessageTime!); 
    // });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (time.isAfter(today)) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year.toString().substring(2)}'; // DD/MM/YY
    }
  }

  void _onTabTapped(int idx) {
    if (idx == _currentIndex) return;
    final routes = ['/explore', '/wishlist', '/services', '/inbox', '/profile'];
    if (idx < routes.length && routes[idx] != '/inbox') {
      Navigator.pushReplacementNamed(context, routes[idx]);
    }
    setState(() { // Update current index for bottom nav even if not navigating away from inbox
      _currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access contacts via a getter that could potentially re-sort if data changes dynamically
    final List<ChatContact> contacts = List.from(widget.chatRepository.contacts);
    contacts.sort((a, b) { // Ensure sorting on each build if data can change
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: theme.colorScheme.surface, // Use surface color for a modern feel
        elevation: 1,
        centerTitle: true,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet.',
                    style: theme.textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Messages from providers will appear here.',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(0), // Remove default padding
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, endIndent: 16), // Indent divider
              itemBuilder: (context, i) {
                final c = contacts[i];
                final bool isUnread = (i % 2 == 0); // Placeholder for unread logic

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: c.avatarUrl != null && c.avatarUrl!.isNotEmpty
                        ? NetworkImage(c.avatarUrl!)
                        : null,
                    backgroundColor: c.avatarUrl == null || c.avatarUrl!.isEmpty 
                        ? theme.colorScheme.primaryContainer 
                        : null,
                    child: c.avatarUrl == null || c.avatarUrl!.isEmpty
                        ? Text(
                            c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                            style: TextStyle(fontSize: 22, color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  title: Text(
                    c.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                      color: isUnread ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.8)
                    ),
                  ),
                  subtitle: Text(
                    c.lastMessage ?? 'No messages yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUnread ? theme.colorScheme.onSurfaceVariant : Colors.grey[600],
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (c.lastMessageTime != null)
                        Text(
                          _formatTime(c.lastMessageTime!),
                          style: TextStyle(color: isUnread ? theme.colorScheme.primary : Colors.grey[500], fontSize: 12, fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
                        ),
                      if (isUnread) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ]
                    ],
                  ),
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
                    // Refresh list in case last message/time updated
                    // Also re-sorts based on new last message time
                    setState(() {
                       widget.chatRepository.updateLastMessage(c.id); // Ensure last message is updated
                    }); 
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor, // Match scaffold background
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        elevation: 8,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), activeIcon: Icon(Icons.room_service), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
