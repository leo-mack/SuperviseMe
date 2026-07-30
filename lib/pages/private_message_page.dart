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

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool messageWasSentByCurrentUser(
    ChatMessage message,
  ) {
    return message.senderUsername ==
            widget.currentUsername &&
        message.senderRole == widget.currentRole;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
    scrollToBottom();
  }

  Future<void> editMessage(
    int messageIndex,
  ) async {
    final ChatMessage originalMessage =
        widget.messages[messageIndex];

    if (!messageWasSentByCurrentUser(
      originalMessage,
    )) {
      return;
    }

    final TextEditingController editController =
        TextEditingController(
      text: originalMessage.text,
    );

    final String? updatedText =
        await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: SizedBox(
            width: 430,
            child: TextField(
              controller: editController,
              autofocus: true,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Edit your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String text =
                    editController.text.trim();

                if (text.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'A message cannot be empty.',
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(
                  dialogContext,
                  text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    editController.dispose();

    if (updatedText == null ||
        updatedText.isEmpty) {
      return;
    }

    if (messageIndex >=
        widget.messages.length) {
      return;
    }

    setState(() {
      widget.messages[messageIndex] =
          ChatMessage(
        senderUsername:
            originalMessage.senderUsername,
        senderRole: originalMessage.senderRole,
        text: updatedText,
        time: 'Edited just now',
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message updated.'),
      ),
    );
  }

  Future<void> deleteMessage(
    int messageIndex,
  ) async {
    if (messageIndex >=
        widget.messages.length) {
      return;
    }

    final ChatMessage message =
        widget.messages[messageIndex];

    if (!messageWasSentByCurrentUser(message)) {
      return;
    }

    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text(
            'Are you sure you want to delete this message?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    if (messageIndex >=
        widget.messages.length) {
      return;
    }

    setState(() {
      widget.messages.removeAt(messageIndex);
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message deleted.'),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1565C0),
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
                    overflow:
                        TextOverflow.ellipsis,
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
                      controller: scrollController,
                      padding:
                          const EdgeInsets.all(16),
                      itemCount:
                          widget.messages.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        final ChatMessage message =
                            widget.messages[index];

                        final bool isCurrentUser =
                            messageWasSentByCurrentUser(
                          message,
                        );

                        return MessageBubble(
                          message: message,
                          isCurrentUser:
                              isCurrentUser,
                          onEdit: () {
                            editMessage(index);
                          },
                          onDelete: () {
                            deleteMessage(index);
                          },
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
                          color:
                              Color(0xFF1565C0),
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
                          textInputAction:
                              TextInputAction.newline,
                          decoration:
                              InputDecoration(
                            hintText:
                                'Send a message...',
                            filled: true,
                            fillColor: const Color(
                              0xFFF4F6F8,
                            ),
                            contentPadding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                              vertical: 14,
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
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 20,
                            vertical: 17,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
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

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            const CircleAvatar(
              radius: 17,
              backgroundColor:
                  Color(0xFFE3F2FD),
              child: Icon(
                Icons.person,
                size: 20,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              margin:
                  const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                8,
                10,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? const Color(0xFF1565C0)
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                border: isCurrentUser
                    ? null
                    : Border.all(
                        color:
                            const Color(0xFFDADADA),
                      ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 15,
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),

                      if (isCurrentUser)
                        PopupMenuButton<String>(
                          tooltip:
                              'Message options',
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected:
                              (String option) {
                            if (option == 'edit') {
                              onEdit();
                            } else if (option ==
                                'delete') {
                              onDelete();
                            }
                          },
                          itemBuilder:
                              (BuildContext context) {
                            return const [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .edit_outlined,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .delete_outline,
                                      color:
                                          Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color:
                                            Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 5),

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
          ),

          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 17,
              backgroundColor:
                  Color(0xFFE3F2FD),
              child: Icon(
                Icons.person,
                size: 20,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ],
      ),
    );
  }
}