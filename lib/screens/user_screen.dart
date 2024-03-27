import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin_screen.dart';
class UserScreen extends StatefulWidget {
  const UserScreen({Key? key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late String _userName = "";
  late String _userEmail = "";
  String? _profilePicPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Quran')
          .where('Email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        setState(() {
          _userName = userData['name'];
          _userEmail = userData['Email'];

        });
      }
    }
  }


  Future<void> _changeProfilePic() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicPath = image.path;
      });

    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _changeProfilePic,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _profilePicPath != null && _profilePicPath!.isNotEmpty
                      ? FileImage(File(_profilePicPath!))
                      : AssetImage('assets/default_avatar.jpg') as ImageProvider,

                ),
              ),
              SizedBox(height: 20),
              Text(
                '$_userName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('$_userEmail'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _userEmail)
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Password reset email sent to $_userEmail'),
                    ));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Error sending password reset email: $error'),
                    ));
                  });
                },
                child: Text('Change Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}