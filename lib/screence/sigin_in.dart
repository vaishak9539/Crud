// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print, prefer_typing_uninitialized_variables

import 'package:crud_ref/screence/Home.dart';
import 'package:crud_ref/screence/sigin_up.dart';
import 'package:flutter/material.dart';


class SiginIn extends StatefulWidget {
  const SiginIn({super.key});

  @override
  State<SiginIn> createState() => _SiginInState();
}

class _SiginInState extends State<SiginIn> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void checking1() {
    final email = emailcontroller.text;
    final password = passwordcontroller.text;
    if (email == password) {
      print("Right");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => Home()));
    } else {
      print("Wrong");
    }
  }
  var size, width, height;
  final formkey = GlobalKey<FormState>();
  var secureText = true;
  bool? check = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: SafeArea(
            child: Column(
              children: [
                //*Image
                SizedBox(
                  height: height/2.5,
                  width: width/1,
                  child: Image.asset(
                    "assets/images/sign-in.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            
                //*Textformfield
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: width/1.1,
                    child: TextFormField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                          hintText: "Your Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2))),
                      validator: (value1) {
                        if (value1 == null || value1.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: width/1.1,
                    child: TextFormField(
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                          hintText: "Your password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  secureText = !secureText;
                                });
                              },
                              icon: Icon(secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2))),
                      validator: (value1) {
                        if (value1 == null || value1.isEmpty) {
                          return "please enter your password";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      obscureText: secureText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Row(
                    children: [
                      Checkbox(
                          value: check,
                          onChanged: (val) {
                            setState(() {
                              check = val;
                            });
                          }),
                      Text(
                        "Remember me",
                        style: TextStyle(fontSize: 10),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: TextButton(
                              onPressed: () {}, child: Text("Forgot Password?",style: TextStyle(fontSize: 12),)))
                    ],
                  ),
                ),
            
                //* Button
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            checking1();
                          }
                        },
                        child: Container(
                          height: height/15,
                          width: width/1.6,
                          child: Center(
                              child: Text(
                            "Sigin in",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New here?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return SiginUp();
                          }));
                        },
                        child: Text("Sign up"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
