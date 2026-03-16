import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/models/usermodel.dart';
import 'package:t3afy/pages/admin_dashboard_page.dart';
import 'package:t3afy/pages/comments_page.dart'; // Only using full-screen CommentsPage now
import 'package:t3afy/widgets/customcardwidget.dart';

class CommunityScreen extends StatefulWidget {
  final String currentUserId;

  const CommunityScreen({super.key, required this.currentUserId});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  Map<String, UserModel> users = {};
  List<PostModel> posts = [];
  bool loading = true;

  final TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  // ================================================
  // Load users + posts with optimistic like data
  // ================================================
  Future<void> loadData() async {
    setState(() => loading = true);

    users = await fetchUsers(); // Assume this exists in your project
    posts = await fetchPosts(widget.currentUserId); // Assume this returns PostModel with reactions list

    // Calculate likes locally (optimistic + accurate)
    for (var post in posts) {
      post.likesCount = post.reactions.where((r) => r.type == 'like').length;
      post.isLikedByMe = post.reactions.any(
        (r) => r.userId == widget.currentUserId && r.type == 'like',
      );
    }

    setState(() => loading = false);
  }

  // ================================================
  // Total comments + replies count (new structure)
  // ================================================
  Future<int> getTotalCommentsAndReplies(String postId) async {
    try {
      final commentsSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .collection('Comments')
          .get();

      int total = commentsSnap.size;

      for (var doc in commentsSnap.docs) {
        final repliesSnap = await doc.reference.collection('Replies').get();
        total += repliesSnap.size;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // ================================================
  // Optimistic Like / Unlike for POST
  // ================================================
  void toggleLike(PostModel post) async {
    final reactionRef = FirebaseFirestore.instance
        .collection('Posts')
        .doc(post.id)
        .collection('Reactions');

    final userId = widget.currentUserId;

    if (post.isLikedByMe) {
      // Remove like
      final snapshot = await reactionRef
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'like')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        post.isLikedByMe = false;
        post.likesCount--;
      });
    } else {
      // Add like (optimistic first)
      setState(() {
        post.isLikedByMe = true;
        post.likesCount++;
      });

      await reactionRef.add({
        'userId': userId,
        'type': 'like',
        'createdAt': Timestamp.now(),
      });
    }
  }

  // ================================================
  // Share post (modern simple implementation)
  // ================================================
  void sharePost(PostModel post) {
    // You can replace with share_plus package later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post shared successfully!'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  // ================================================
  // Add new post
  // ================================================
  Future<void> addPost() async {
    if (postController.text.trim().isEmpty) return;

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUserId,
      text: postController.text.trim(),
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(newPost.id)
        .set({
      'userId': newPost.userId,
      'text': newPost.text,
      'createdAt': Timestamp.fromDate(newPost.createdAt),
    });

    setState(() {
      posts.insert(0, newPost);
      postController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: KTextFieldColor,
  elevation: 2,
  title: const Text(
    "Community",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      // لو فيه صفحة قبلها نرجع ليها
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } 
    },
  ),
),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Add post box (modern)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Customcardwidget(
                     ontap: () {
    print("card tapped");
  },
 
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: postController,
                            minLines: 1,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "What's on your mind?",
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(height: 1),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: addPost,
                              style: TextButton.styleFrom(
                                backgroundColor: KButtonsColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              ),
                              child: const Text("Post", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Posts feed
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final user = users[post.userId];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Customcardwidget(
                           ontap: () {
    print("card tapped");
  },

                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey[300],
                                      child: Text(
                                        user?.displayName?.isNotEmpty == true
                                            ? user!.displayName![0].toUpperCase()
                                            : 'U',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.displayName ?? "User",
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy • HH:mm').format(post.createdAt),
                                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(post.text, style: const TextStyle(fontSize: 15.5)),

                                const SizedBox(height: 16),

                                // Interaction bar (Like • Comment • Share)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Like
                                    InkWell(
                                      onTap: () => toggleLike(post),
                                      child: Row(
                                        children: [
                                          Icon(
                                            post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                                            color: post.isLikedByMe ? Colors.red : Colors.grey[600],
                                            size: 22,
                                          ),
                                          const SizedBox(width: 6),
                                          Text("${post.likesCount}", style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),

                                    // Comment
                                    FutureBuilder<int>(
                                      future: getTotalCommentsAndReplies(post.id),
                                      builder: (context, snapshot) {
                                        final count = snapshot.data ?? 0;
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CommentsPage(
                                                  post: post,
                                                  users: users,
                                                  currentUserId: widget.currentUserId,
                                                ),
                                              ),
                                            ).then((_) => loadData()); // Refresh counts on return
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.chat_bubble_outline, size: 22),
                                              const SizedBox(width: 6),
                                              Text("$count", style: const TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    // Share
                                    InkWell(
                                      onTap: () => sharePost(post),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.share_outlined, size: 22),
                                          SizedBox(width: 6),
                                          Text("Share", style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}