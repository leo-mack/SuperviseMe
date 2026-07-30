import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/post.dart';
import 'list_page.dart';
import 'messages_page.dart';
import 'private_message_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  final String username;
  final String role;

  const MainPage({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController postController = TextEditingController();

  final List<Post> posts = [
    const Post(
      id: 'post_1',
      username: 'Dr Sarah Smith',
      role: 'Teacher',
      text:
          'I am currently accepting final-year project students interested in artificial intelligence, data analysis, and mobile application development.',
      time: '10 minutes ago',
    ),
    const Post(
      id: 'post_2',
      username: 'James Wilson',
      role: 'Student',
      text:
          'I am looking for a supervisor for a Flutter project focused on helping university students manage their coursework deadlines.',
      time: '25 minutes ago',
    ),
    const Post(
      id: 'post_3',
      username: 'Dr Michael Brown',
      role: 'Teacher',
      text:
          'New project idea available: developing a visual tool for explaining graph theory algorithms such as Dijkstra, Prim, and Kruskal.',
      time: '1 hour ago',
    ),
    const Post(
      id: 'post_4',
      username: 'Emily Davis',
      role: 'Student',
      text:
          'Does anyone have experience using Firebase with Flutter? I am considering it for my final-year project.',
      time: '2 hours ago',
    ),
  ];

  final Set<String> savedPostIds = {};

  final Map<String, List<ChatMessage>> conversations = {
    'Dr Sarah Smith': [
      const ChatMessage(
        senderUsername: 'Dr Sarah Smith',
        senderRole: 'Teacher',
        text:
            'Hello. Feel free to ask me about the available artificial intelligence projects.',
        time: '15 minutes ago',
      ),
    ],
  };

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  void publishPost() {
    final String postText = postController.text.trim();

    if (postText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please write something before publishing.',
          ),
        ),
      );

      return;
    }

    setState(() {
      posts.insert(
        0,
        Post(
          id: 'user_post_${DateTime.now().millisecondsSinceEpoch}',
          username: widget.username,
          role: widget.role,
          text: postText,
          time: 'Just now',
        ),
      );
    });

    postController.clear();
  }

  Future<void> editPost(Post post) async {
    final TextEditingController editController =
        TextEditingController(text: post.text);

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: SizedBox(
            width: 450,
            child: TextField(
              controller: editController,
              minLines: 3,
              maxLines: 7,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Edit your post...',
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
                final String updatedText =
                    editController.text.trim();

                if (updatedText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'A post cannot be empty.',
                      ),
                    ),
                  );

                  return;
                }

                final int postIndex = posts.indexWhere(
                  (Post currentPost) {
                    return currentPost.id == post.id;
                  },
                );

                if (postIndex == -1) {
                  Navigator.pop(dialogContext);
                  return;
                }

                setState(() {
                  posts[postIndex] = Post(
                    id: post.id,
                    username: post.username,
                    role: post.role,
                    text: updatedText,
                    time: 'Edited just now',
                  );
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post updated.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    editController.dispose();
  }

  Future<void> deletePost(Post post) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text(
            'Are you sure you want to delete this post?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
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

    setState(() {
      posts.removeWhere(
        (Post currentPost) {
          return currentPost.id == post.id;
        },
      );

      savedPostIds.remove(post.id);
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post deleted.'),
      ),
    );
  }

  void toggleSavedPost(Post post) {
    final bool wasAlreadySaved =
        savedPostIds.contains(post.id);

    setState(() {
      if (wasAlreadySaved) {
        savedPostIds.remove(post.id);
      } else {
        savedPostIds.add(post.id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadySaved
              ? 'Removed from List'
              : 'Added to List',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> openPrivateMessage(Post post) async {
    final List<ChatMessage> messages =
        conversations.putIfAbsent(
      post.username,
      () => [],
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PrivateMessagePage(
            currentUsername: widget.username,
            currentRole: widget.role,
            otherUsername: post.username,
            otherRole: post.role,
            messages: messages,
          );
        },
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openListPage() async {
    Navigator.pop(context);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ListPage(
            posts: posts,
            savedPostIds: savedPostIds,
            onToggleSaved: toggleSavedPost,
            onOpenMessage: openPrivateMessage,
          );
        },
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openMessagesPage() async {
    Navigator.pop(context);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return MessagesPage(
            currentUsername: widget.username,
            currentRole: widget.role,
            contacts: posts,
            conversations: conversations,
          );
        },
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfilePage(
            username: widget.username,
            role: widget.role,
          );
        },
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  bool isCurrentUsersPost(Post post) {
    return post.username == widget.username &&
        post.role == widget.role;
  }

  void selectImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Image uploading will be added later.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1565C0),
              ),
              child: Center(
                child: Text(
                  'SuperviseMe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.bookmark_outline,
                color: Color(0xFF1565C0),
              ),
              title: const Text('List'),
              trailing: savedPostIds.isEmpty
                  ? null
                  : CircleAvatar(
                      radius: 13,
                      backgroundColor:
                          const Color(0xFF1565C0),
                      child: Text(
                        savedPostIds.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
              onTap: openListPage,
            ),
            ListTile(
              leading: const Icon(
                Icons.mail_outline,
                color: Color(0xFF1565C0),
              ),
              title: const Text('Messages'),
              onTap: openMessagesPage,
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 29,
              ),
              tooltip: 'Open menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'SuperviseMe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: openProfile,
              borderRadius: BorderRadius.circular(30),
              child: Row(
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF1565C0),
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 600,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      final Post post = posts[index];
                      final bool isOwnPost =
                          isCurrentUsersPost(post);

                      return PostCard(
                        post: post,
                        isSaved:
                            savedPostIds.contains(post.id),
                        isOwnPost: isOwnPost,
                        showOtherUserActions: !isOwnPost,
                        onToggleSaved: () {
                          toggleSavedPost(post);
                        },
                        onMessage: () {
                          openPrivateMessage(post);
                        },
                        onEdit: () {
                          editPost(post);
                        },
                        onDelete: () {
                          deletePost(post);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                  width: 600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: selectImage,
                        tooltip: 'Add image',
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF1565C0),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: postController,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction:
                              TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Write a post...',
                            filled: true,
                            fillColor:
                                const Color(0xFFF4F6F8),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: publishPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 17,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'Publish',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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

class PostCard extends StatelessWidget {
  final Post post;
  final bool isSaved;
  final bool isOwnPost;
  final bool showOtherUserActions;
  final VoidCallback onToggleSaved;
  final VoidCallback onMessage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.isSaved,
    required this.isOwnPost,
    required this.showOtherUserActions,
    required this.onToggleSaved,
    required this.onMessage,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0xFFE3F2FD),
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
                        '${post.username} - ${post.role}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                if (showOtherUserActions) ...[
                  IconButton(
                    tooltip: 'Message user',
                    onPressed: onMessage,
                    icon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  IconButton(
                    tooltip: isSaved
                        ? 'Remove from List'
                        : 'Add to List',
                    onPressed: onToggleSaved,
                    icon: Icon(
                      isSaved
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ],

                if (isOwnPost)
                  PopupMenuButton<String>(
                    tooltip: 'Post options',
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF1565C0),
                    ),
                    onSelected: (String option) {
                      if (option == 'edit') {
                        onEdit();
                      } else if (option == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (
                      BuildContext context,
                    ) {
                      return const [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
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
            const SizedBox(height: 16),
            Text(
              post.text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}