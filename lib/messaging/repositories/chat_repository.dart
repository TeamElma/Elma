import '../models/chat_contact.dart';
import '../models/chat_message.dart';

class ChatRepository {
  final List<ChatContact> _contacts = [];
  final Map<String, List<ChatMessage>> _messages = {};

  // For debugging / seeding
  void debugAddContact(ChatContact contact) {
    _contacts.add(contact);
    _messages[contact.id] = [];
  }

  void debugAddMessage(String contactId, ChatMessage message) {
    _messages.putIfAbsent(contactId, () => []).add(message);

    // update that contact’s lastMessage
    final idx = _contacts.indexWhere((c) => c.id == contactId);
    if (idx != -1) {
      _contacts[idx] = _contacts[idx].copyWith(
        lastMessage: message.text,
        lastMessageTime: message.timestamp,
      );
    }
  }

  /// Call this to resync a contact’s `lastMessage`/`lastMessageTime`
  void updateLastMessage(String contactId) {
    final messages = _messages[contactId];
    if (messages != null && messages.isNotEmpty) {
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final last = messages.first;
      final idx = _contacts.indexWhere((c) => c.id == contactId);
      if (idx != -1) {
        _contacts[idx] = _contacts[idx].copyWith(
          lastMessage: last.text,
          lastMessageTime: last.timestamp,
        );
      }
    }
  }

  // Expose as immutable lists
  List<ChatContact> get contacts => List.unmodifiable(_contacts);

  List<ChatMessage> getMessages(String contactId) {
    final msgs = List<ChatMessage>.from(_messages[contactId] ?? []);
    msgs.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // oldest first
    return msgs;
  }
}
