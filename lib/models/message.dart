class ChatMessage {
  final String senderUsername;
  final String senderRole;
  final String text;
  final String time;

  const ChatMessage({
    required this.senderUsername,
    required this.senderRole,
    required this.text,
    required this.time,
  });
}