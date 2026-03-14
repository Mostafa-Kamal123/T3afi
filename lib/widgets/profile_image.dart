import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
File? profileImageFile;
Future pickImage() async {

  final picker = ImagePicker();

  final image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      profileImageFile = File(image.path);
    });
  }
}
Future uploadImage() async {

  var uid = FirebaseAuth.instance.currentUser!.uid;

  final ref = FirebaseStorage.instance
      .ref()
      .child("profileImages")
      .child("$uid.jpg");

  await ref.putFile(profileImageFile!);

  String url = await ref.getDownloadURL();

  await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .update({
        "profileImage": url,
      });
}
  @override
  Widget build(BuildContext context) {{
  return Stack(
    children: [

      CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        child:CircleAvatar(
  radius: 55,
  backgroundImage: profileImageFile != null
      ? FileImage(profileImageFile!)
      : NetworkImage("https://i.pravatar.cc/300") as ImageProvider,
)
      ),

      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: pickImage,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    ],
  );
}
  }
}
