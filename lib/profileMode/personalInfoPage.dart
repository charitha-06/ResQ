import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirebaseAuth.instance.currentUser == null
            ? Center(
          child: Text(
            'Please log in to view personal information',
            style: TextStyle(fontSize: 18),
          ),
        )
            : FutureBuilder<UserProfile>(
          future: getUserProfile(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return PersonalInfoPageUi(userProfile: snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget PersonalInfoPageUi({required UserProfile userProfile}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final XFile? pickImage = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: 50,
              );
              if (pickImage != null) {
                setState(() {
                  profilePic = pickImage.path;
                });
              }
            },
            child: Container(
              child: profilePic == null
                  ? Center(
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 80,
                  child: Center(
                    child: Image.asset(
                      'assets/profile.jpeg',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  : profilePic!.contains('http')
                  ? Center(
                child: ClipOval(
                  child: Container(
                    width: 160.0, // 2 times the radius
                    height: 160.0, // 2 times the radius
                    color: Colors.deepPurple,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(profilePic!),
                    ),
                  ),
                ),
              )
                  : Center(
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 80,
                  backgroundImage: FileImage(File(profilePic!)),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              '${userProfile.name}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Text(
            'Child Email: ${userProfile.childemail}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Parent Email: ${userProfile.guardiantEmail}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Phone: ${userProfile.phone}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<UserProfile> getUserProfile(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return UserProfile(
      uid: uid,
      name: snapshot.data()!['name'],
      childemail: snapshot.data()!['childEmail'],
      guardiantEmail: snapshot.data()!['guardiantEmail'],
      phone: snapshot.data()!['phone'],
      profilePicture: snapshot.data()!['profilePic'] ?? "",
    );
  }

}

class UserProfile {
  final String uid;
  final String name;
  final String phone;
  final String childemail;
  final String guardiantEmail;
  final String profilePicture;

  UserProfile({
    required this.uid,
    required this.name,
    required this.phone,
    required this.childemail,
    required this.guardiantEmail,
    required this.profilePicture,
  });
}
