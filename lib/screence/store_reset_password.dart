// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_ref/screence/Home.dart';
import 'package:flutter/material.dart';


class StoreResetPassword extends StatefulWidget {
  String email;
  StoreResetPassword({Key? key, required this.email});

  @override
  State<StoreResetPassword> createState() => _StoreResetPasswordState();
}

class _StoreResetPasswordState extends State<StoreResetPassword> {
  var password = TextEditingController();
  var cpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color(0xff0E1D3E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reset Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 20),
            child: TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white70),
                focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 1)
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,width: 1)
                            )
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter new password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 45, right: 20),
            child: TextFormField(
              controller: cpassword,
              cursorColor: Colors.white70,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.white70),
                focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 1)
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,width: 1)
                            )
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter password';
                }
                return null;
              },
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () async {
                if (cpassword.text == password.text) {
                  print('equal');
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: widget.email)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    DocumentReference userDocRef =
                        querySnapshot.docs.first.reference;
                    await userDocRef.update({
                      'password': password.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          // color: Colors.green,
                          "Password updated",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.green
                          ),
                         
                        ),
                      ),
                    );

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } else {
                    // Handle case where no documents match the query
                    print('No user found with the provided email.');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                      "Passwords don't match",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black
                      ),
                       
                        
                      ),
                    ),
                  );
                  print('not equal');
                }
              },
              child: Text("done",
              style: TextStyle(
              color:  Color(0xFF67B0DA),
              ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}