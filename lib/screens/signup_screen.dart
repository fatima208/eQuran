import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/screens/onBoarding_screen.dart';
import 'package:equran/widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  String _message = ""; // Variable to store the success/error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const Center(
                  child: Image(
                    image: AssetImage('assets/Koran.png'),
                  ),
                ),
                const Text(
                  "E-Quran",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
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
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                FirebaseButton(context, "SignUp", () async {
                  if (_userNameTextController.text.isEmpty ||
                      _emailTextController.text.isEmpty ||
                      _passwordTextController.text.isEmpty) {
                    setState(() {
                      _message = "Please fill in all fields.";
                    });
                    return; // Exit function if any field is empty
                  }

                  // Check if the username or email already exists in Firestore
                  QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
                      .collection('Quran')
                      .where('name', isEqualTo: _userNameTextController.text)
                      .get();

                  QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
                      .collection('Quran')
                      .where('Email', isEqualTo: _emailTextController.text)
                      .get();

                  // If any document exists with the same username or email, display a message
                  if (usernameSnapshot.docs.isNotEmpty || emailSnapshot.docs.isNotEmpty) {
                    setState(() {
                      _message = "Username or Email already exists.";
                    });
                    return; // Exit function if username or email already exists
                  }

                  // If no document exists with the same username or email, create the account
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    // Save username to Firestore
                    saveUsernameToFirestore(value.user!.uid);

                    setState(() {
                      _message = "Account created successfully!";
                    });
                    print("Created The New Account Successfully");
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const OnBoardingScreen()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      if (error.toString().contains("email-already-in-use")) {
                        _message = "Email is already in use. Try another.";
                      } else {
                        _message = "Error: ${error.toString()}";
                      }
                    });
                    print("Error${error.toString()}");
                  });
                }),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains("successfully") ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUsernameToFirestore(String uid) async {
    try {
      // Check if the username already exists in Firestore
      QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
          .collection('Quran')
          .where('name', isEqualTo: _userNameTextController.text)
          .get();

      // Check if the email already exists in Firestore
      QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
          .collection('Quran')
          .where('Email', isEqualTo: _emailTextController.text)
          .get();

      // If any document exists with the same username or email, display a message
      if (usernameSnapshot.docs.isNotEmpty || emailSnapshot.docs.isNotEmpty) {
        setState(() {
          _message = "Username or email already exists.";
        });
        return;
      }

      // If no document exists with the same username or email, save the new data
      await FirebaseFirestore.instance.collection('Quran').doc(uid).set({
        'name': _userNameTextController.text,
        'Email': _emailTextController.text,
      });
      print("Username saved successfully");
    } catch (e) {
      print("Error saving username: $e");
    }
  }

}
