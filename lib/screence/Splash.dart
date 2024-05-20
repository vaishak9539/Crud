// ignore_for_file: prefer_const_constructors, annotate_overrides, use_build_context_synchronously

import 'package:crud_ref/screence/sigin_in.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
 
  void initState() {
    goSignIn();
    super.initState();
  }

  Future<void>goSignIn()async{
    await Future.delayed(Duration(seconds: 4));
    Navigator.push(context, MaterialPageRoute(builder: (context) => SiginIn(),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E1D3E),
      body: Center(child: Text("Todo-App",
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
      )),
    );
  }
}