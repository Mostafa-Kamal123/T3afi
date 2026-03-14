import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/admin_dashboard_page.dart';
import 'package:t3afy/models/usermodel.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/pages/comments_page.dart';
import 'package:t3afy/widgets/comments_sheet.dart';
import 'package:t3afy/widgets/customcardwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  final String currentUserId;

  const CommunityScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  Map<String, UserModel> users = {};
  List<PostModel> posts = [];
  bool loading = true;

  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }
  void openComments(PostModel post) {

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {

      return CommentsSheet(
        post: post,
        users: users,
        currentUserId: widget.currentUserId,
      );

    },
  );

}

  // ===== Like / Unlike =====
  void toggleLike(PostModel post) async {

    final userId = widget.currentUserId;

    final reactionRef = FirebaseFirestore.instance
        .collection('Posts')
        .doc(post.id)
        .collection('Reactions');

    if (post.isLikedByMe) {

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

      await reactionRef.add({
        'userId': userId,
        'type': 'like',
        'createdAt': Timestamp.now(),
      });

      setState(() {
        post.isLikedByMe = true;
        post.likesCount++;
      });
    }
  }

  // ===== Load Users + Posts =====
  Future<void> loadData() async {

    setState(() => loading = true);

    users = await fetchUsers();

    posts = await fetchPosts(widget.currentUserId);

    for (var post in posts) {

      post.likesCount =
          post.reactions.where((r) => r.type == 'like').length;

      post.isLikedByMe = post.reactions.any(
        (r) => r.userId == widget.currentUserId && r.type == 'like',
      );
    }

    setState(() => loading = false);
    
  }
Future<int> getCommentsCount(String postId) async {

  final snapshot = await FirebaseFirestore.instance
      .collection('Posts')
      .doc(postId)
      .collection('Reactions')
      .where('type', isEqualTo: 'comment')
      .get();

  return snapshot.docs.length;
}
  // ===== Add Post =====
  Future<void> addPost() async {

    if (postController.text.isEmpty) return;

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUserId,
      text: postController.text,
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
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(
          "Community",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())

          : Column(
              children: [

                // ===== Add Post Box =====
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Customcardwidget(
                    width: double.infinity,
                    height: null,
                    ontap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextField(
                            controller: postController,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              border: InputBorder.none,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              TextButton(
                                onPressed: addPost,
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: KButtonsColor,
                                ),
                                child: const Text("Post"),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== Posts List =====
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,

                    itemBuilder: (context, index) {

                      final post = posts[index];
                      final user = users[post.userId];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: Customcardwidget(
                          ontap: () {},

                          child: Padding(
                            padding: const EdgeInsets.all(12.0),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${user?.displayName ?? 'Unknown'} • ${DateFormat('dd/MM/yyyy – HH:mm').format(post.createdAt)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(post.text),

                                SizedBox(height: 10),

                                // ===== Like Button =====
                                Row(
                                  children: [

                                    IconButton(
                                      icon: Icon(
                                        post.isLikedByMe
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: post.isLikedByMe
                                            ? Colors.red
                                            : Colors.grey,
                                      ),

                                      onPressed: () => toggleLike(post),
                                    ),

                                    Text("${post.likesCount}"),
                                    

                                     SizedBox(width: 10),

    // 💬 Comment
 FutureBuilder<int>(
  future: getCommentsCount(post.id),
  builder: (context, snapshot) {

    int count = snapshot.data ?? 0;

    return Row(
      children: [

        IconButton(
          icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
          onPressed: () {
           Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CommentsPage(
      post: post,
      users: users,
      currentUserId: widget.currentUserId,
    ),
  ),
).then((_) {
  loadData(); // يحدث العداد
});
          },
        ),

        Text("$count"),

      ],
    );
  },
)

  ],
)

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