import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/post.dart';
import 'private_message_page.dart';

class MessagesPage extends StatefulWidget {
  final String currentUsername;
  final String currentRole;

  final List<Post> contacts;

  final Map<String, List<ChatMessage>>
      conversations;

  const MessagesPage({
    super.key,
    required this.currentUsername,
    required this.currentRole,
    required this.contacts,
    required this.conversations,
  });

  @override
  State<MessagesPage> createState() =>
      _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Post? findContact(String username) {
    for (final Post post in widget.contacts) {
      if (post.username == username) {
        return post;
      }
    }

    return null;
  }

  Future<void> openConversation(
    String username,
  ) async {
    final Post? contact = findContact(username);

    if (contact == null) {
      return;
    }

    final List<ChatMessage> messages =
        widget.conversations.putIfAbsent(
      username,
      () => [],
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PrivateMessagePage(
          currentUsername:
              widget.currentUsername,
          currentRole: widget.currentRole,
          otherUsername: contact.username,
          otherRole: contact.role,
          messages: messages,
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> conversationUsers =
        widget.conversations.entries
            .where(
              (entry) => entry.value.isNotEmpty,
            )
            .map((entry) => entry.key)
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: conversationUsers.isEmpty
          ? const Center(
              child: Text(
                'You do not have any messages yet.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
            )
          : Center(
              child: SizedBox(
                width: 650,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount:
                      conversationUsers.length,
                  itemBuilder: (context, index) {
                    final String username =
                        conversationUsers[index];

                    final Post? contact =
                        findContact(username);

                    final List<ChatMessage>
                        messages = widget
                            .conversations[username]!;

                    final ChatMessage lastMessage =
                        messages.last;

                    if (contact == null) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(
                          14,
                        ),
                        leading:
                            const CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.person,
                            color:
                                Color(0xFF1565C0),
                          ),
                        ),
                        title: Text(
                          '${contact.username} - ${contact.role}',
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(
                            top: 6,
                          ),
                          child: Text(
                            lastMessage.text,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          openConversation(
                            username,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}