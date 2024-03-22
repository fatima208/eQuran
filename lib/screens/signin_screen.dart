import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/screens/reset_password.dart';
import 'package:equran/widgets/reusable_widget.dart';
import 'package:equran/screens/onBoarding_screen.dart';
import 'package:equran/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
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
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                   // Positioned(
                     // top: MediaQuery.of(context).size.height * 0.1,
                     // left: MediaQuery.of(context).size.width * 0.05,
                      //child:
                const Center(child:Image(image: AssetImage('assets/Koran.png' ),
                      ),),
                    //),
                      //Positioned(
                       //top: MediaQuery.of(context).size.height * 0.16,
                      // left: MediaQuery.of(context).size.width * 0.05,
                      // child:
                       const Text(
                      "E-Quran",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
            //  ),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Email", Icons.person_outlined, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Password", Icons.lock_outline, true,
                        _passwordTextController),

                    const SizedBox(
                      height: 3,
                    ),
                     forgetPassword(context),

                    FirebaseButton(
                      context,
                      "SignIn",
                          () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                            .then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
                        }).catchError((error) {
                          print("Error ${error.toString()}");
                          // Display error message on the screen
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Wrong credentials. Please try again."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                    ),


                    signUpOption()
                  ],
                )),
          )),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " SignUp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResetPassword())),
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

}

