import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/models/usermodel.dart';
import 'package:t3afy/widgets/customcardwidget.dart';

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
  final commentController = TextEditingController();
  final replyController = TextEditingController();

  String? replyingToId; // comment or reply ID we're replying to

  // References
  CollectionReference get postReactionsRef => FirebaseFirestore.instance
      .collection('Posts')
      .doc(widget.post.id)
      .collection('Reactions');

  CollectionReference get commentsRef => FirebaseFirestore.instance
      .collection('Posts')
      .doc(widget.post.id)
      .collection('Comments');

  @override
  void dispose() {
    commentController.dispose();
    replyController.dispose();
    super.dispose();
  }

  // Add comment (new structure)
  Future<void> addComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    await commentsRef.add({
      'text': text,
      'userId': widget.currentUserId,
      'createdAt': Timestamp.now(),
    });

    commentController.clear();
  }

  // Optimistic-ready toggle like for comment or reply
  Future<void> toggleLike(DocumentReference ref, bool alreadyLiked) async {
    final likesRef = ref.collection('Likes');

    if (alreadyLiked) {
      final myLike = await likesRef
          .where('userId', isEqualTo: widget.currentUserId)
          .limit(1)
          .get();
      if (myLike.docs.isNotEmpty) await myLike.docs.first.reference.delete();
    } else {
      await likesRef.add({
        'userId': widget.currentUserId,
        'createdAt': Timestamp.now(),
      });
    }
  }

  // Add inline reply
  Future<void> addReply(String parentId) async {
    final text = replyController.text.trim();
    if (text.isEmpty) return;

    await commentsRef.doc(parentId).collection('Replies').add({
      'text': text,
      'userId': widget.currentUserId,
      'createdAt': Timestamp.now(),
    });

    replyController.clear();
    setState(() => replyingToId = null);
  }

  @override
  Widget build(BuildContext context) {
    final postAuthor = widget.users[widget.post.userId];
    final currentUser = widget.users[widget.currentUserId];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: KTextFieldColor ?? Colors.blueGrey[800],
        elevation: 1,
      ),
      body: Column(
        children: [
          // Post preview card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postAuthor?.displayName ?? "User",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy – HH:mm').format(widget.post.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Text(widget.post.text, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 16),

                    // Post likes + total comments (live)
                    Row(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: postReactionsRef.where('type', isEqualTo: 'like').snapshots(),
                          builder: (_, snap) {
                            final count = snap.hasData ? snap.data!.size : 0;
                            return Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.red, size: 22),
                                const SizedBox(width: 6),
                                Text("$count Likes"),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 32),
                        StreamBuilder<QuerySnapshot>(
                          stream: commentsRef.snapshots(),
                          builder: (context, snap) {
                            if (!snap.hasData) return const Text("0 Comments");
                            final totalComments = snap.data!.size;

                            return FutureBuilder<int>(
                              future: _getTotalReplies(snap.data!.docs),
                              builder: (_, replySnap) {
                                final total = totalComments + (replySnap.data ?? 0);
                                return Row(
                                  children: [
                                    const Icon(Icons.comment, size: 22),
                                    const SizedBox(width: 6),
                                    Text("$total Comments"),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Comments list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: commentsRef.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No comments yet. Be the first!"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final commentDoc = snapshot.data!.docs[index];
                    final data = commentDoc.data() as Map<String, dynamic>;
                    final user = widget.users[data['userId']];

                    return _buildCommentOrReply(commentDoc, data, user, isReply: false);
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Modern Facebook-style comment input
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    currentUser?.displayName?.isNotEmpty == true
                        ? currentUser!.displayName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Recursive widget for comment + replies (with divider)
  Widget _buildCommentOrReply(
    QueryDocumentSnapshot doc,
    Map<String, dynamic> data,
    UserModel? user, {
    required bool isReply,
  }) {
    final id = doc.id;
    final likesRef = doc.reference.collection('Likes');

    return Padding(
      padding: EdgeInsets.only(left: isReply ? 36 : 12, right: 12, top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user?.displayName ?? "User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isReply ? 13.5 : 15,
                ),
              ),
              Text(
                DateFormat('HH:mm').format((data['createdAt'] as Timestamp).toDate()),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(data['text'] ?? '', style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 10),

          // Like + Reply buttons
          Row(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: likesRef.snapshots(),
                builder: (_, likeSnap) {
                  final count = likeSnap.hasData ? likeSnap.data!.size : 0;
                  final liked = likeSnap.hasData &&
                      likeSnap.data!.docs.any((d) => d['userId'] == widget.currentUserId);

                  return InkWell(
                    onTap: () => toggleLike(doc.reference, liked),
                    child: Row(
                      children: [
                        Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : null,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text("$count"),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 32),
              InkWell(
                onTap: () {
                  setState(() {
                    replyingToId = (replyingToId == id) ? null : id;
                    replyController.clear();
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.reply, size: 19),
                    SizedBox(width: 5),
                    Text("Reply"),
                  ],
                ),
              ),
            ],
          ),

          // Inline reply field
          if (replyingToId == id) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Write a reply...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => addReply(id),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => replyingToId = null),
                ),
              ],
            ),
          ],

          // Replies with divider
          StreamBuilder<QuerySnapshot>(
            stream: doc.reference.collection('Replies').orderBy('createdAt').snapshots(),
            builder: (context, repliesSnap) {
              if (!repliesSnap.hasData || repliesSnap.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, thickness: 0.5, indent: 20, endIndent: 20),
                  ),
                  ...repliesSnap.data!.docs.map((replyDoc) {
                    final rData = replyDoc.data() as Map<String, dynamic>;
                    final replyUser = widget.users[rData['userId']];
                    return _buildCommentOrReply(replyDoc, rData, replyUser, isReply: true);
                  }).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper for total replies count
  Future<int> _getTotalReplies(List<QueryDocumentSnapshot> comments) async {
    int total = 0;
    for (final c in comments) {
      final snap = await c.reference.collection('Replies').get();
      total += snap.size;
    }
    return total;
  }
}