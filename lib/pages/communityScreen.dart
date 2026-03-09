import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/admin_dashboard_page.dart';
import 'package:t3afy/pages/models.dart';
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

  Future<void> loadData() async {
    setState(() => loading = true);

    // جلب المستخدمين والبوستات
    users = await fetchUsers();
    posts = await fetchPosts();

    setState(() => loading = false);
  }

  Future<void> addPost() async {
    if (postController.text.isEmpty) return;

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUserId,
      text: postController.text,
      createdAt: DateTime.now(),
    );

    // 🔹 حفظ البوست في Firebase
    await FirebaseFirestore.instance.collection('Posts').doc(newPost.id).set({
      'userId': newPost.userId,
      'text': newPost.text,
      'createdAt': Timestamp.fromDate(newPost.createdAt), // نخزن كـ Timestamp
    });

    // 🔹 إضافة البوست محليًا عشان يظهر فورًا
    setState(() {
      posts.insert(0, newPost);
      postController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTextFieldColor2,
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // === حقل Add Post مباشر ===
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

                // === قائمة البوستات ===
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