import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:res_q/components/customTextField.dart';
import 'package:res_q/widgets/LoginScreen.dart';
import 'package:res_q/widgets/child/childLoginScreen.dart';

import '../../Utils/constants.dart';
import '../../components/primaryButton.dart';
import '../../components/secondaryButton.dart';
import '../../db/model/userModel.dart';


class RegisterChildScreen extends StatefulWidget {
  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, 'password and retype password should be equal');
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _formData['cemail'].toString(),
            password: _formData['password'].toString());
        if (userCredential.user != null) {
          setState(() {
            isLoading = false;
          });
          final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
          FirebaseFirestore.instance.collection('users').doc(v);

          final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['cemail'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            id: v,
            type: 'child',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, loginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogueBox(context, 'The account already exists for that email.');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogueBox(context, e.toString());
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                child : Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "SIGNUP AS CHILD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: kColorRed),
                          ),
                          Image.asset(
                            'assets/login.jpeg',
                            height: 150,

                          ),
                         // SizedBox(height: 20),

                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            customTextField(
                              hintText: 'enter name',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.name,
                              prefix: Icon(Icons.person),
                              onsave: (name) {
                                _formData['name'] = name ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty || email.length < 3) {
                                  return 'enter correct name';
                                }
                                return null;
                              },
                            ),
                            customTextField(
                              hintText: 'enter phone',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.phone,
                              prefix: Icon(Icons.phone),
                              onsave: (phone) {
                                _formData['phone'] = phone ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty || email.length < 10) {
                                  return 'enter correct phone';
                                }
                                return null;
                              },
                            ),
                            customTextField(
                              hintText: 'enter email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.person),
                              onsave: (email) {
                                _formData['cemail'] = email ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty ||
                                    email.length < 3 ||
                                    !email.contains("@")) {
                                  return 'enter correct email';
                                }
                              },
                            ),

                            customTextField(
                              hintText: 'enter password',
                              isPassword: isPasswordShown,
                              prefix: Icon(Icons.vpn_key_rounded),
                              validate: (password) {
                                if (password!.isEmpty ||
                                    password.length < 7) {
                                  return 'enter correct password';
                                }
                                return null;
                              },
                              onsave: (password) {
                                _formData['password'] = password ?? "";
                              },
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordShown = !isPasswordShown;
                                    });
                                  },
                                  icon: isPasswordShown
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            customTextField(
                              hintText: 'retype password',
                              isPassword: isRetypePasswordShown,
                              prefix: Icon(Icons.vpn_key_rounded),
                              validate: (password) {
                                if (password!.isEmpty ||
                                    password.length < 7) {
                                  return 'enter correct password';
                                }
                                return null;
                              },
                              onsave: (password) {
                                _formData['rpassword'] = password ?? "";
                              },
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isRetypePasswordShown =
                                      !isRetypePasswordShown;
                                    });
                                  },
                                  icon: isRetypePasswordShown
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            PrimaryButton(
                                title: 'REGISTER',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                  goTo(context, LoginScreen());
                                }),
                          ],
                        ),
                      ),
                    ),
                    SecondaryButton(
                        title: 'Login with your account',
                        onPressed: () {
                          goTo(context, loginScreen());
                        }),
                  ],
                ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}