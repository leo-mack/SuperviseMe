import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String role;

  const ProfilePage({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController subjectAreaController =
      TextEditingController();

  final TextEditingController bioController =
      TextEditingController();

  final TextEditingController interestController =
      TextEditingController();

  final TextEditingController profilePostController =
      TextEditingController();

  final List<String> interests = [
    'Software Development',
    'Mobile Applications',
  ];

  final List<ProfilePost> profilePosts = [];

  bool isEditingProfile = false;
  bool isAvailableForSupervision = true;

  @override
  void initState() {
    super.initState();

    final bool isTeacher =
        widget.role.toLowerCase() == 'teacher';

    subjectAreaController.text = isTeacher
        ? 'Computer Science'
        : 'Software Development';

    bioController.text = isTeacher
        ? 'I supervise final-year projects relating to software development and mobile applications.'
        : 'Final-year student interested in developing useful software applications.';
  }

  @override
  void dispose() {
    subjectAreaController.dispose();
    bioController.dispose();
    interestController.dispose();
    profilePostController.dispose();
    super.dispose();
  }

  void toggleEditing() {
    setState(() {
      isEditingProfile = !isEditingProfile;
    });
  }

  void saveProfile() {
    if (subjectAreaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Subject area cannot be empty.',
          ),
        ),
      );

      return;
    }

    if (bioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bio cannot be empty.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isEditingProfile = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated.'),
      ),
    );
  }

  void addInterest() {
    final String newInterest =
        interestController.text.trim();

    if (newInterest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter an interest.',
          ),
        ),
      );

      return;
    }

    final bool alreadyExists = interests.any(
      (String interest) {
        return interest.toLowerCase() ==
            newInterest.toLowerCase();
      },
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'That interest has already been added.',
          ),
        ),
      );

      return;
    }

    setState(() {
      interests.add(newInterest);
    });

    interestController.clear();
  }

  void removeInterest(String interest) {
    setState(() {
      interests.remove(interest);
    });
  }

  void publishProfilePost() {
    final String postText =
        profilePostController.text.trim();

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
      profilePosts.insert(
        0,
        ProfilePost(
          id:
              'profile_post_${DateTime.now().millisecondsSinceEpoch}',
          text: postText,
          time: 'Just now',
        ),
      );
    });

    profilePostController.clear();
  }

  Future<void> editProfilePost(
    ProfilePost post,
  ) async {
    final TextEditingController editController =
        TextEditingController(text: post.text);

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile Post'),
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

                final int postIndex =
                    profilePosts.indexWhere(
                  (ProfilePost currentPost) {
                    return currentPost.id == post.id;
                  },
                );

                if (postIndex == -1) {
                  Navigator.pop(dialogContext);
                  return;
                }

                setState(() {
                  profilePosts[postIndex] = ProfilePost(
                    id: post.id,
                    text: updatedText,
                    time: 'Edited just now',
                  );
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profile post updated.',
                    ),
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

  Future<void> deleteProfilePost(
    ProfilePost post,
  ) async {
    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Profile Post'),
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
      profilePosts.removeWhere(
        (ProfilePost currentPost) {
          return currentPost.id == post.id;
        },
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile post deleted.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTeacher =
        widget.role.toLowerCase() == 'teacher';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 750,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 52,
                        backgroundColor:
                            Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.person,
                          size: 62,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.role,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: toggleEditing,
                        icon: Icon(
                          isEditingProfile
                              ? Icons.close
                              : Icons.edit,
                        ),
                        label: Text(
                          isEditingProfile
                              ? 'Cancel Editing'
                              : 'Edit Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Subject Area',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller:
                            subjectAreaController,
                        readOnly: !isEditingProfile,
                        decoration: InputDecoration(
                          hintText:
                              'Enter your subject area',
                          filled: true,
                          fillColor: isEditingProfile
                              ? Colors.white
                              : const Color(
                                  0xFFF4F6F8,
                                ),
                          border:
                              const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: bioController,
                        readOnly: !isEditingProfile,
                        minLines: 4,
                        maxLines: 7,
                        decoration: InputDecoration(
                          hintText:
                              'Write something about yourself',
                          filled: true,
                          fillColor: isEditingProfile
                              ? Colors.white
                              : const Color(
                                  0xFFF4F6F8,
                                ),
                          border:
                              const OutlineInputBorder(),
                        ),
                      ),

                      if (isTeacher) ...[
                        const SizedBox(height: 20),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Available for supervision',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            isAvailableForSupervision
                                ? 'You are currently accepting students.'
                                : 'You are not currently accepting students.',
                          ),
                          value:
                              isAvailableForSupervision,
                          activeThumbColor:
                              const Color(0xFF1565C0),
                          onChanged: isEditingProfile
                              ? (bool newValue) {
                                  setState(() {
                                    isAvailableForSupervision =
                                        newValue;
                                  });
                                }
                              : null,
                        ),
                      ],

                      if (isEditingProfile) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: saveProfile,
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
                                vertical: 15,
                              ),
                            ),
                            child: const Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interests',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (interests.isEmpty)
                        const Text(
                          'No interests have been added.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: interests.map(
                            (String interest) {
                              return Chip(
                                label: Text(interest),
                                backgroundColor:
                                    const Color(
                                  0xFFE3F2FD,
                                ),
                                deleteIcon:
                                    isEditingProfile
                                        ? const Icon(
                                            Icons.close,
                                            size: 18,
                                          )
                                        : null,
                                onDeleted:
                                    isEditingProfile
                                        ? () {
                                            removeInterest(
                                              interest,
                                            );
                                          }
                                        : null,
                              );
                            },
                          ).toList(),
                        ),

                      if (isEditingProfile) ...[
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    interestController,
                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      'Add an interest',
                                  border:
                                      OutlineInputBorder(),
                                ),
                                onSubmitted:
                                    (String value) {
                                  addInterest();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: addInterest,
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
                                  vertical: 18,
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTeacher
                            ? 'Project and Supervision Posts'
                            : 'Project Posts',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller:
                            profilePostController,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: isTeacher
                              ? 'Write about a project idea or supervisor availability...'
                              : 'Write about your project interests or ideas...',
                          border:
                              const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed:
                              publishProfilePost,
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
                              horizontal: 22,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            'Publish',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              if (profilePosts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Center(
                    child: Text(
                      'No profile posts have been published yet.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                for (final ProfilePost post
                    in profilePosts)
                  ProfilePostCard(
                    username: widget.username,
                    role: widget.role,
                    post: post,
                    onEdit: () {
                      editProfilePost(post);
                    },
                    onDelete: () {
                      deleteProfilePost(post);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePost {
  final String id;
  final String text;
  final String time;

  const ProfilePost({
    required this.id,
    required this.text,
    required this.time,
  });
}

class ProfilePostCard extends StatelessWidget {
  final String username;
  final String role;
  final ProfilePost post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfilePostCard({
    super.key,
    required this.username,
    required this.role,
    required this.post,
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundColor:
                      Color(0xFFE3F2FD),
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
                        '$username - $role',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
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