import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/models/reaction.dart';
import 'package:t3afy/models/usermodel.dart';

class CommentsSheet extends StatefulWidget {

  final PostModel post;
  final Map<String, UserModel> users;
  final String currentUserId;

  const CommentsSheet({
    super.key,
    required this.post,
    required this.users,
    required this.currentUserId,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {

  List<Reaction> comments = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {

    final snapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.post.id)
        .collection('Reactions')
        .where('type', isEqualTo: 'comment')
        .orderBy('createdAt')
        .get();

    setState(() {
      comments = snapshot.docs.map((doc) {

        final data = doc.data();

        return Reaction(
          userId: data['userId'],
          type: data['type'],
          commentText: data['commentText'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );

      }).toList();
    });

  }

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

  setState(() {
    comments.insert(0, newComment); // 👈 يظهر فورًا
  });

  controller.clear();
}
@override
Widget build(BuildContext context) {

  return SafeArea(
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,

      child: Column(
        children: [

          // عنوان
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // قائمة الكومنتات
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {

                final comment = comments[index];
                final user = widget.users[comment.userId];

                return ListTile(
                  title: Text(user?.displayName ?? "User"),
                  subtitle: Text(comment.commentText ?? ""),
                );
              },
            ),
          ),

          Divider(),

          // حقل كتابة الكومنت
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: addComment,
                )

              ],
            ),
          ),

        ],
      ),
    ),
  );
}
}