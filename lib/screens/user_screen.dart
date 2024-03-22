import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget{
  const UserScreen({super.key});

  @override
  _UserScreenState createState()=> _UserScreenState();
}
class _UserScreenState extends State<UserScreen>{
  @override
  Widget build(BuildContext context){
    return SafeArea(child: Container(
      child: const Scaffold(
        body: Center(child: Text("user screen")),
      ),
    ),
    );
  }
}