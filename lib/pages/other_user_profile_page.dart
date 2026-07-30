import 'package:flutter/material.dart';

class OtherUserProfilePage extends StatelessWidget {
  final String username;
  final String role;

  const OtherUserProfilePage({
    super.key,
    required this.username,
    required this.role,
  });

  UserProfileData getProfileData() {
    if (username == 'Dr Sarah Smith') {
      return const UserProfileData(
        subjectArea: 'Artificial Intelligence and Data Science',
        bio:
            'I am a lecturer specialising in artificial intelligence, data analysis, and mobile application development. I am interested in supervising practical projects that solve real problems.',
        interests: [
          'Artificial Intelligence',
          'Data Analysis',
          'Machine Learning',
          'Mobile Applications',
        ],
        isAvailableForSupervision: true,
        posts: [
          UserProfilePost(
            text:
                'I am currently accepting final-year students interested in artificial intelligence and data-analysis projects.',
            time: '10 minutes ago',
          ),
          UserProfilePost(
            text:
                'New project idea: create a mobile application that uses machine learning to recommend personalised study plans.',
            time: 'Yesterday',
          ),
          UserProfilePost(
            text:
                'Students interested in Flutter, Firebase, or Python are welcome to contact me to discuss possible project ideas.',
            time: '3 days ago',
          ),
        ],
      );
    }

    if (username == 'James Wilson') {
      return const UserProfileData(
        subjectArea: 'Software Development',
        bio:
            'I am a final-year student interested in Flutter development and creating applications that improve university life.',
        interests: [
          'Flutter',
          'Mobile Development',
          'Firebase',
          'User Experience',
        ],
        isAvailableForSupervision: false,
        posts: [
          UserProfilePost(
            text:
                'I am looking for a supervisor for a Flutter project that helps students manage coursework deadlines.',
            time: '25 minutes ago',
          ),
          UserProfilePost(
            text:
                'My current project idea includes deadline reminders, module organisation, and a weekly study planner.',
            time: '2 days ago',
          ),
        ],
      );
    }

    return const UserProfileData(
      subjectArea: 'Not provided',
      bio: 'This prototype profile has not been completed yet.',
      interests: [],
      isAvailableForSupervision: false,
      posts: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileData profile = getProfileData();
    final bool isTeacher = role.toLowerCase() == 'teacher';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          username,
          style: const TextStyle(
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.person,
                          size: 65,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        role,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Return to Feed'),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD6D6D6),
                          ),
                        ),
                        child: Text(profile.subjectArea),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD6D6D6),
                          ),
                        ),
                        child: Text(
                          profile.bio,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      if (isTeacher) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              profile.isAvailableForSupervision
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: profile.isAvailableForSupervision
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              profile.isAvailableForSupervision
                                  ? 'Available for supervision'
                                  : 'Not currently available for supervision',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interests',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (profile.interests.isEmpty)
                        const Text(
                          'No interests have been added.',
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: profile.interests.map((interest) {
                            return Chip(
                              label: Text(interest),
                              backgroundColor: const Color(0xFFE3F2FD),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '$username\'s Posts',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (profile.posts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'This user has not published any posts.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                for (final UserProfilePost post in profile.posts)
                  OtherUserPostCard(
                    username: username,
                    role: role,
                    post: post,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileData {
  final String subjectArea;
  final String bio;
  final List<String> interests;
  final bool isAvailableForSupervision;
  final List<UserProfilePost> posts;

  const UserProfileData({
    required this.subjectArea,
    required this.bio,
    required this.interests,
    required this.isAvailableForSupervision,
    required this.posts,
  });
}

class UserProfilePost {
  final String text;
  final String time;

  const UserProfilePost({
    required this.text,
    required this.time,
  });
}

class OtherUserPostCard extends StatelessWidget {
  final String username;
  final String role;
  final UserProfilePost post;

  const OtherUserPostCard({
    super.key,
    required this.username,
    required this.role,
    required this.post,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$username - $role',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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