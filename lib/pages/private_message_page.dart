import 'package:flutter/material.dart';
import '../models/message.dart';

class PrivateMessagePage extends StatefulWidget {
  final String currentUsername;
  final String currentRole;

  final String otherUsername;
  final String otherRole;

  final List<ChatMessage> messages;

  const PrivateMessagePage({
    super.key,
    required this.currentUsername,
    required this.currentRole,
    required this.otherUsername,
    required this.otherRole,
    required this.messages,
  });

  @override
  State<PrivateMessagePage> createState() =>
      _PrivateMessagePageState();
}

class _PrivateMessagePageState extends State<PrivateMessagePage> {
  final TextEditingController messageController =
      TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final String messageText =
        messageController.text.trim();

    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a message before sending.',
          ),
        ),
      );

      return;
    }

    setState(() {
      widget.messages.add(
        ChatMessage(
          senderUsername: widget.currentUsername,
          senderRole: widget.currentRole,
          text: messageText,
          time: 'Just now',
        ),
      );
    });

    messageController.clear();
  }

  void selectImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Image messages will be added later.',
        ),
      ),
    );
  }

  bool messageWasSentByCurrentUser(
    ChatMessage message,
  ) {
    return message.senderUsername ==
        widget.currentUsername;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUsername,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.otherRole,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet.\nSend the first message.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          widget.messages.length,
                      itemBuilder: (context, index) {
                        final ChatMessage message =
                            widget.messages[index];

                        final bool isCurrentUser =
                            messageWasSentByCurrentUser(
                          message,
                        );

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints:
                                const BoxConstraints(
                              maxWidth: 420,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            padding:
                                const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? const Color(
                                      0xFF1565C0,
                                    )
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              border: isCurrentUser
                                  ? null
                                  : Border.all(
                                      color: const Color(
                                        0xFFDADADA,
                                      ),
                                    ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  message.time,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isCurrentUser
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD6D6D6),
                  ),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 700,
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: selectImage,
                        tooltip: 'Add image',
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF1565C0),
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller:
                              messageController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Send a message...',
                            filled: true,
                            fillColor: const Color(
                              0xFFF4F6F8,
                            ),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                22,
                              ),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: sendMessage,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF1565C0,
                          ),
                          foregroundColor:
                              Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 17,
                          ),
                        ),
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}