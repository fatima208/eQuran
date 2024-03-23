import 'dart:async';
import 'package:equran/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'package:equran/constants/constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    user= FirebaseAuth.instance.currentUser;
    Timer(
      const Duration(seconds: 3), // Reduced the duration for testing
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>user!=null? const MainScreen(): const SignInScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [
                themebackground.white,
                themebackground.grayish,
                themebackground.greenish,
                themebackground.green,
              ],
            ),
          ),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "E-Quran",
                    style: TextStyle(
                      color: Color(0xFF030005),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.23,
                right: MediaQuery.of(context).size.width * 0.08,
                child: Center(
                child: Container(
                  width: 388.19,
                  height: 360,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Bismillah.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              ), ],
          ),
        ),
      ),
    );
  }
}
