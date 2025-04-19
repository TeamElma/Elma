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
      widget.chatRepository.getMessages(widget.contact.id);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final align =
                m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final color = m.isMe ? AppColors.primary : Colors.grey.shade300;
                final textColor = m.isMe ? Colors.white : Colors.black87;
                return Column(
                  crossAxisAlignment: align,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        m.text,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    Text(
                      _formatTime(m.timestamp),
                      style:
                      const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
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
