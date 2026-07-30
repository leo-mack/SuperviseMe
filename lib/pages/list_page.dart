import 'package:flutter/material.dart';
import '../models/post.dart';

class ListPage extends StatefulWidget {
  final List<Post> posts;
  final Set<String> savedPostIds;

  final void Function(Post post)
      onToggleSaved;

  final void Function(Post post)
      onOpenMessage;

  const ListPage({
    super.key,
    required this.posts,
    required this.savedPostIds,
    required this.onToggleSaved,
    required this.onOpenMessage,
  });

  @override
  State<ListPage> createState() =>
      _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void removeFromList(Post post) {
    widget.onToggleSaved(post);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> savedPosts = widget.posts
        .where(
          (post) =>
              widget.savedPostIds.contains(post.id),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: savedPosts.isEmpty
          ? const Center(
              child: Text(
                'You have not added any posts yet.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
            )
          : Center(
              child: SizedBox(
                width: 600,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: savedPosts.length,
                  itemBuilder: (context, index) {
                    final Post post =
                        savedPosts[index];

                    return Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          18,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 23,
                                  backgroundColor:
                                      Color(
                                    0xFFE3F2FD,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Color(
                                      0xFF1565C0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        '${post.username} - ${post.role}',
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        post.time,
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  tooltip:
                                      'Message user',
                                  onPressed: () {
                                    widget
                                        .onOpenMessage(
                                      post,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons
                                        .mail_outline,
                                    color: Color(
                                      0xFF1565C0,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  tooltip:
                                      'Remove from List',
                                  onPressed: () {
                                    removeFromList(
                                      post,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons
                                        .check_circle,
                                    color: Color(
                                      0xFF1565C0,
                                    ),
                                  ),
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
                  },
                ),
              ),
            ),
    );
  }
}