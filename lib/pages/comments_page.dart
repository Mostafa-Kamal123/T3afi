import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/models/reaction.dart';
import 'package:t3afy/models/usermodel.dart';
import 'package:t3afy/widgets/customcardwidget.dart'; // مهم

class CommentsPage extends StatefulWidget {
  final PostModel post;
  final Map<String, UserModel> users;
  final String currentUserId;

  const CommentsPage({
    super.key,
    required this.post,
    required this.users,
    required this.currentUserId,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Reaction> comments = [];
  bool loading = true;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  // ===== تحميل الكومنتات =====
  Future<void> loadComments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.post.id)
        .collection('Reactions')
        .get();

    comments = snapshot.docs
        .map((doc) {
          final data = doc.data();
          return Reaction(
            userId: data['userId'],
            type: data['type'],
            commentText: data['commentText'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        })
        .where((r) => r.type == 'comment')
        .toList();

    setState(() {
      loading = false;
    });
  }

  // ===== إضافة كومنت =====
  Future<void> addComment() async {
    if (controller.text.trim().isEmpty) return;

    final newComment = Reaction(
      userId: widget.currentUserId,
      type: 'comment',
      commentText: controller.text,
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.post.id)
        .collection('Reactions')
        .add({
      'userId': widget.currentUserId,
      'type': 'comment',
      'commentText': controller.text,
      'createdAt': Timestamp.now(),
    });

    controller.clear();

    setState(() {
      comments.add(newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final author = widget.users[widget.post.userId];

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: KTextFieldColor,
      ),
      body: Column(
        children: [
          // ===== Post Card =====
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Customcardwidget(
              ontap: () {},
              width: double.infinity,
              height: null,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author?.displayName ?? "User",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy – HH:mm')
                          .format(widget.post.createdAt),
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(widget.post.text, style: TextStyle(fontSize: 15)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text("Like", style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 16),
                        Icon(Icons.reply, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text("Reply", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== Comments Title =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Comments",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Text(
                    "${comments.length}",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[300]),

          // ===== Comments List =====
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final user = widget.users[comment.userId];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Customcardwidget(
                          ontap: () {},
                          width: double.infinity,
                          height: null,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? "User",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(comment.commentText ?? ""),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.favorite_border,
                                        size: 18, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text("Like",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    SizedBox(width: 16),
                                    Icon(Icons.reply,
                                        size: 18, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text("Reply",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Spacer(),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(comment.createdAt),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
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

          // ===== Write Comment Field =====
          Divider(height: 1, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: addComment,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}