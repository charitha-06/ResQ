import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:res_q/widgets/LoginScreen.dart';

import '../utils/constants.dart';
import '../widgets/child/BottomPage.dart';
import '../widgets/child/bottomScreens/profilePage.dart';
import '../widgets/child/childLoginScreen.dart';

class ProfileItem {
  final String? item;
  final String? title;

  ProfileItem({this.item, this.title});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static String? displayName;

  @override
  void initState() {
    super.initState();
    // Load user display name
    getName();
  }

  // Function to get user display name
  Future<void> getName() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get();
      setState(() {
        displayName = snapshot['name'];
      });
    } catch (e) {
      print('Error getting display name: $e');
    }
  }

  // Function to handle login button tap
  void login() {
    goTo(context, loginScreen());
  }

  // Function to handle logout button tap
  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      setState(() {
        displayName = null;
      });
      goTo(context, BottomPage());
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              CircleAvatar(radius: 60),
              SizedBox(height: 30),
              // Display user display name
              Text(displayName ?? "User"),
              SizedBox(height: 30),
              Flexible(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final ProfileItem item = _infoItems(context)[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle button tap based on item
                        if (item.item == 'login') {
                          login();
                        } else if (item.item == 'logout') {
                          logout();
                        } else {
                          // Handle other buttons
                          // For example, navigate to ProfilePage
                          goTo(context, ProfilePage());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kColorDarkRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.title!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10.0);
                  },
                  itemCount: _infoItems(context).length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List of ProfileItems
  List<ProfileItem> _infoItems(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final String loginTitle = isLoggedIn ? 'Logout' : 'Login';
    final String loginItem = isLoggedIn ? 'logout' : 'login';
    return [
      ProfileItem(item: 'personal', title: 'Personal information'),
     // ProfileItem(item: 'admin', title: 'Admin Login'),
      ProfileItem(item: loginItem, title: loginTitle),
    ];
  }
}
