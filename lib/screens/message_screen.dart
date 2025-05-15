// lib/messaging/screens/message_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../messaging/models/chat_contact.dart';
import '../messaging/models/chat_message.dart';
import '../messaging/repositories/chat_repository.dart';

class MessageScreen extends StatefulWidget {
  final ChatContact contact;
  final ChatRepository chatRepository;

  const MessageScreen({
    Key? key,
    required this.contact,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> get _messages =>
      widget.chatRepository.getMessages(widget.contact.id).reversed.toList();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: '0', // assuming '0' is yourself
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );

    widget.chatRepository.debugAddMessage(widget.contact.id, msg);
    setState(() {});
    _controller.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (time.isAfter(today)) {
      return '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}';
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return '${time.month}/${time.day}/${time.year}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1.0,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final bool isMe = m.isMe;
                final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                // Use theme colors for bubbles
                final bubbleColor = isMe ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
                final textColor = isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;
                
                // Determine border radius for chat bubble effect
                final BorderRadius bubbleRadius = BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
                );

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: align,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), // Max width for bubbles
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14), // Adjusted padding
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: bubbleRadius, // Apply dynamic border radius
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(color: textColor, fontSize: 16), // Slightly larger text
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(m.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]), // Theme-based timestamp
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Modern Input Area
          Container(
            decoration: BoxDecoration(
              color: theme.canvasColor, // Or theme.colorScheme.surface for a slightly different shade
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                // Add other icons here if needed, like an attachment icon
                // IconButton(icon: Icon(Icons.add), onPressed: () { /* ... */ }),
                Expanded(
                  child: Container(
                     decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none, // Remove default border
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjust padding
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      minLines: 1,
                      maxLines: 5, // Allow multi-line input
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: theme.colorScheme.primary,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
