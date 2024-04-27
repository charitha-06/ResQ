import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../Utils/constants.dart';
import '../../../components/PrimaryButton.dart';
import '../../../components/customTextField.dart';
import '../BottomPage.dart';

class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
  const CheckUserStatusBeforeChatOnProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return ProfilePage();
          } else {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('User Not Authenticated'),
                  content: Text('Please sign in to view your profile.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            });
            return Container();
          }
        }
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController guardianEmailC = TextEditingController();
  TextEditingController childEmailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameC.text = value.docs.first['name'];
        childEmailC.text = value.docs.first['childEmail'];
        guardianEmailC.text = value.docs.first['guardiantEmail'];
        phoneC.text = value.docs.first['phone'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isSaving == true
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: kColorRed,
        ),
      )
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "UPDATE YOUR PROFILE",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickImage = await ImagePicker()
                          .pickImage(
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
                          ? CircleAvatar(
                        backgroundColor: kColorLightBlue,
                        radius: 70,
                        child: Center(
                          child: ClipOval(
                            child: Image.asset(
                              'assets/profile.jpeg',
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          ),
                        ),
                      )
                          : profilePic!.contains('http')
                          ? CircleAvatar(
                        backgroundColor: kColorLightBlue,
                        radius: 80,
                        backgroundImage:
                        NetworkImage(profilePic!),
                      )
                          : CircleAvatar(
                        backgroundColor: kColorLightBlue,
                        radius: 80,
                        backgroundImage:
                        FileImage(File(profilePic!)),
                      ),
                    ),
                  ),
                  customTextField(
                    controller: nameC,
                    hintText: nameC.text,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return 'please enter your updated name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: childEmailC,
                    hintText: "child email",
                    readOnly: true,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return 'please enter your updated name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: guardianEmailC,
                    hintText: "parent email",
                    readOnly: true,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return 'please enter your updated name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: phoneC,
                    hintText: "Phone number",
                    readOnly: true,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return 'please enter your updated name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  PrimaryButton(
                    title: "UPDATE",
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        SystemChannels.textInput
                            .invokeMethod('TextInput.hide');
                        profilePic == null
                            ? Fluttertoast.showToast(
                            msg: 'please select profile picture')
                            : update();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(String? filePath) async {
    try {
      if (filePath == null || filePath.isEmpty) {
        throw ArgumentError('File path is empty or null');
      }

      final fileName = Uuid().v4();
      final Reference fbStorage = FirebaseStorage.instance
          .ref('profile')
          .child(fileName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  update() async {
    setState(() {
      isSaving = true;
    });

    // Perform null check on profilePic before calling uploadImage
    if (profilePic != null) {
      uploadImage(profilePic!).then((value) {
        Map<String, dynamic> data = {
          'name': nameC.text,
          'profilePic': downloadUrl,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data);
        setState(() {
          isSaving = false;
          goTo(context, BottomPage());
        });
      });
    } else {
      // Handle case when profilePic is null
      Fluttertoast.showToast(msg: 'Please select a profile picture');
      setState(() {
        isSaving = false;
      });
    }
  }
}
