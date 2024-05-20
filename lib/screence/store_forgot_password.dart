// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_ref/screence/store_reset_password.dart';
import 'package:flutter/material.dart';

class StoreForgotPassword extends StatefulWidget {
  const StoreForgotPassword({super.key});

  @override
  State<StoreForgotPassword> createState() => _StoreForgotPasswordState();
}

class _StoreForgotPasswordState extends State<StoreForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController forgotemail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E1D3E),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: forgotemail,
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1)
                      ) 
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                },
                
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool emailExists = await checkEmailExists(forgotemail.text);
                      if (emailExists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                StoreResetPassword(email: forgotemail.text),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email does not exist',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Next",
                  style: TextStyle(
                    color: Color(0xff0E1D3E),
                  ),
                  ),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      // Query Firestore collection "storekeeper" for the provided email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      // Check if any documents match the provided email
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }
}