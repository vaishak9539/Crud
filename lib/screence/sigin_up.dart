// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_typing_uninitialized_variables, unused_element, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_ref/screence/Home.dart';
import 'package:crud_ref/screence/sigin_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  
  var errorMessage;
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future<void> adding() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      String authenticationUid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(authenticationUid).set({
        'name': namecontroller.text,
        'email': emailcontroller.text,
        'password': passwordcontroller.text,
        'Created at' : DateTime.now(),
        'userId': authenticationUid,
      });

      print('User registered successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to register user: $e');
      String errorMessage = "Registration failed. ${e.message}";

      if (e.code == 'email-already-in-use') {
        errorMessage = "Email is already in use. Please use a different email.";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Unexpected error during registration: $e');
      Fluttertoast.showToast(
        msg: "Unexpected error during registration.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  var size, width, height;
  bool checking = true;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color(0xff0E1D3E),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(
                height: height/3.3,
                width: double.infinity,
              ),
              Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: height / 14,
                  width: width / 1.1,
                  child: TextFormField(
                    controller: namecontroller,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        hintText: "Your name",
                        hintStyle: TextStyle(
                          color: Colors.white70
                        ),
                        prefixIcon: const Icon(Icons.account_circle,color: Colors.white70),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)
                            ),
                            enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)),
                            ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your name";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //*Textformfield
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
               height: height / 14,
                  width: width / 1.1,
                  child: TextFormField(
                    controller: emailcontroller,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        hintText: "Your Email",
                        hintStyle: TextStyle(
                          color: Colors.white70
                        ),
                        prefixIcon: const Icon(Icons.email,color: Colors.white70,),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)
                            ),
                            enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)),
                                ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value1) {
                      if (value1 == null || value1.isEmpty) {
                        return "please enter your email";
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
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                 height: height / 14,
                  width: width / 1.1,
                  child: TextFormField(
                    controller: passwordcontroller,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        hintText: "Enter your Password",
                        hintStyle: TextStyle(
                          color: Colors.white70
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                checking = !checking;
                              });
                            },
                            icon: Icon(checking
                                ? (Icons.visibility_off)
                                : (Icons.visibility),
                                color: Colors.white70,
                                )
                                ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)
                            ),
                            enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white,width: 1)),
                            ),
                    obscureText: checking,
                    obscuringCharacter: "*",
                    validator: (value2) {
                      if (value2 == null || value2.isEmpty) {
                        return "please enter your Password";
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
                        return "Password must has 8 characters";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              //*Button
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                         
                          adding();
                        }
                      },
                      child: Container(
                        height: height/16,
                        width: width/1.5,
                        child: Center(
                            child: Text(
                          "Sigin up",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account ?",
                      style: TextStyle(fontWeight: FontWeight.w500,
                      color: Colors.white70
                      ),
                    ),
                     TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => SiginIn()),
                        );
                      },
                      child: Text("Login",style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ],
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
