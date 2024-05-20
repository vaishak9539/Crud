// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print, library_private_types_in_public_api, sort_child_properties_last

import 'package:crud_ref/screence/store_forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'sigin_up.dart';

class SiginIn extends StatefulWidget {
  const SiginIn({super.key});

  @override
  _SiginInState createState() => _SiginInState();
}

class _SiginInState extends State<SiginIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool secureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        String userEmail = emailController.text.trim();
        String userPassword = passwordController.text.trim();

        UserCredential userData =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        if (userData.user != null) {
          // Save user data if necessary
          await _saveData(userData.user!.uid);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(10),
              backgroundColor: Colors.black,
              content: Text('Failed to sign in'),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with email and password: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.black,
          content: Text('${e.message}'),
        ),
      );
    }
  }

  Future<void> _saveData(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: Color(0xff0E1D3E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: height / 3.3,
                    width: width / 1,
                  ),
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: height / 14,
                      width: width / 1.1,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white
                        ),
                        controller: emailController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Your Email",
                          hintStyle: TextStyle(
                            color: Colors.white70
                          ),
                          prefixIcon: const Icon(Icons.email,color: Colors.white70,),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)),
                              enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value1) {
                          if (value1 == null || value1.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value1)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: height/14,
                      width: width / 1.1,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white
                        ),
                        controller: passwordController,
                         cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Your password",
                          hintStyle: TextStyle(
                            color: Colors.white70
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                secureText = !secureText;
                              });
                            },
                            icon: Icon(secureText
                                ? (Icons.visibility_off)
                                : (Icons.visibility),
                                color: Colors.white70,
                                ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)),
                        ),
                        obscureText: secureText,
                        validator: (value2) {
                          if (value2 == null || value2.isEmpty) {
                            return "please enter your password";
                          }
                          if (!RegExp((r'[A-Z]')).hasMatch(value2)) {
                            return 'Uppercase letter is missing';
                          }
                          if (!RegExp((r'[a-z]')).hasMatch(value2)) {
                            return 'Lowercase letter is missing';
                          }
                          if (!RegExp((r'[0-9]')).hasMatch(value2)) {
                            return 'Digit is missing';
                          }
                          if (value2.length < 5) {
                            return "Password must have 8 characters";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password1",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreForgotPassword(),
                                    ));
                              },
                              child: Text(
                                "Forgot Password 2",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await _signInWithEmailAndPassword(context);
                          },
                          child: Container(
                            height: height / 16,
                            width: width / 1.5,
                            child: Center(
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an Account?",
                      style: TextStyle(
                        color: Colors.white70
                      ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => SignUp1()),
                          );
                        },
                        child: Text("Sign up",style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
