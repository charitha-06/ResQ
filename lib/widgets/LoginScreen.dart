import 'package:flutter/material.dart';
import 'package:res_q/Utils/constants.dart';
import 'package:res_q/components/customTextField.dart';
import 'package:res_q/components/primaryButton.dart';
import 'package:res_q/components/secondaryButton.dart';
import 'package:res_q/parent/parentRegisteration.dart';
import '../home_screen.dart';
import 'child/childRegisteration.dart';

class loginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}
class _LoginScreen extends State<loginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final formData = Map<String, Object> ();

  _onSubmit(){
    _formKey.currentState!.save();
    print(formData['email']);
    print(formData['password']);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:Form(
              key : _formKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                // Add space between the text and the image
                Text(
                  "USER LOGIN",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF002C46),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Add space between the text and the image
                Image.asset(
                  'assets/login.jpeg',
                  height: 200,
                ),
                SizedBox(height: 20),
                // Add space between the image and the text fields
                customTextField(
                  hintText: 'Enter Email',
                  textInputAction: TextInputAction.next,
                  keyboardtype: TextInputType.emailAddress,
                  prefix: Icon(Icons.person),
                  onsave: (email){
                    formData['email']=email??"";
                  },
                  validate:(email) {
                    if(email!.isEmpty || email.length<3 || !email.contains("@")){
                      return 'Email entered is incorrect';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Add space between the text fields and the buttons
                customTextField(
                  hintText: 'Enter Password',
                  onsave: (password){
                    formData['password']=password??"";
                  },
                  isPassword: isPasswordShown,
                  prefix: Icon(Icons.vpn_key_rounded),
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordShown = !isPasswordShown;
                      });
                    },
                    icon: isPasswordShown
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility)),
                  validate:(password) {
                    if(password!.isEmpty || password.length<7){
                      return 'Password entered is incorrect';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Add space between the text fields and the buttons
                PrimaryButton(title: 'Login', onPressed: () {
                  if(_formKey.currentState!.validate()){
                  }
                  _onSubmit();
                  goTo(context, HomeScreen());
                }),
                SizedBox(height: 20),
                // Add space between the buttons

                SecondaryButton(title: 'New user? Signup ', onPressed: () {
                  goTo(context, RegisterChildScreen());
                }),
              ],
            ),)
          ),
        ),
      ),
    );
  }
}


