import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/services/message.dart';
import 'package:t3afy/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget { 
  static String id='chat_screen';
  const ChatScreen({
    super.key,
    this.patientCustomId,     // يُرسل فقط لو اللي فاتح الصفحة دكتور
    this.patientName,         // اختياري - اسم المريض عشان الـ AppBar
  });

  final int? patientCustomId;
  final String? patientName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? myRole;
  int? myCustomId;
  int? doctorCustomId;
  String? chatRoomId;
  String? otherName;

  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  final _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadMyData();
  }

  Future<void> _loadMyData() async {
    if (currentUid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    setState(() {
      myRole = data['role'] as String?;
      myCustomId = data['customId'] as int?;

      if (myRole == 'patient') {
        doctorCustomId = data['doctorCustomId'] as int?;
        if (doctorCustomId != null) {
          chatRoomId = 'd$doctorCustomId';
          _loadDoctorName(doctorCustomId!);
        }
      } else if (myRole == 'doctor') {
        // الدكتور لازم يبعت patientCustomId من الصفحة السابقة
        if (widget.patientCustomId != null) {
          doctorCustomId = myCustomId;
          chatRoomId = 'd$doctorCustomId';
          otherName = widget.patientName ?? 'patient ${widget.patientCustomId}';
        }
      }
    });
  }

  Future<void> _loadDoctorName(int docId) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'doctor')
        .where('customId', isEqualTo: docId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        otherName = query.docs.first.data()['name'] as String?;
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (chatRoomId == null || text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text.trim(),
      'senderRole': myRole,
      'senderCustomId': myCustomId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myRole == null || chatRoomId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (myRole == 'patient' && doctorCustomId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "There is no doctor for you yet",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (myRole == 'doctor' && widget.patientCustomId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "choose patient first",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    final isDoctor = myRole == 'doctor';

    return Scaffold(
      backgroundColor: KPrimaryColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        title: Text(otherName ?? (isDoctor ? 'patient' : 'doctor')),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msgData = messages[index].data() as Map<String, dynamic>;
                    final senderCustomId = msgData['senderCustomId'] as int?;
                    final senderRole = msgData['senderRole'] as String?;

                    final isMe = senderCustomId == myCustomId && senderRole == myRole;

                    final msg = Message(
                      message: msgData['text'] ?? '',
                      createdAt: (msgData['createdAt'] as Timestamp?)?.toDate(),
                    );

                    return isMe
                        ? ChatbubbleForDoctor(message: msg)   // اليمين - لون الدكتور
                        : Chatbubble(message: msg);           // اليسار - لون المريض
                  },
                );
              },
            ),
          ),

          // حقل الإدخال
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (v) {
                      _sendMessage(v);
                      _messageController.clear();
                      // يفضل تضيف controller و clear بعد الإرسال
                    },
                    decoration: InputDecoration(
                      hintText: "Write message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: KButtonsColor),
                  onPressed: () {
                    // إذا كنت تستخدم controller → _sendMessage(controller.text),

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}