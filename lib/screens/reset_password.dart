import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/widgets/reusable_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Constants.kPrimary,
                  themebackground.white,
                  themebackground.grayish,
                  themebackground.greenish,
                  themebackground.green,
                ],
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.15,
            child:Opacity(
              opacity: 0.10,
              child:Center(
    child:Container(
                width: 379,
                height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Koran.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),),),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Column(
                    children: [
                      Text(
                        'Forgot your\nPassword?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Text(
                        'Enter the Email associated with\nyour account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Text(
                        'We will send you a code to reset\nyour password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "Enter Email ID",
                    Icons.email_outlined,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FirebaseButton(context, "Reset Password", () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailTextController.text);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
