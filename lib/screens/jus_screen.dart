import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';

import '../models/juz.dart';
import '../services/api_services.dart';
import '../widgets/juz_custom_tile.dart';

class JuzScreen extends StatelessWidget {
  static const String id = 'juz_screen';

  ApiServices apiServices = ApiServices();

  JuzScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown,
            elevation: 0,
            title: const Text('Juz',style: TextStyle(color: Colors.white,
                fontSize: 20,fontWeight: FontWeight.bold),),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios , color: Colors.white,),)),
        backgroundColor: Constants.kPrimary,
        body:Container(
          decoration: BoxDecoration(
            color: Constants.kPrimary,
          ),
          child:FutureBuilder<JuzModel>(
          future: apiServices.getJuzz(Constants.juzIndex!),
          builder: (context, AsyncSnapshot<JuzModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if(snapshot.hasData){
              print('${snapshot.data!.juzAyahs.length} length');
              return ListView.builder(
                itemCount: snapshot.data!.juzAyahs.length,
                itemBuilder: (context, index) {
                  return JuzCustomTile(list: snapshot.data!.juzAyahs,index: index,);
                },
              );
            }
            else{
              return const Center(child: Text('Data not found'),);
            }
          },
        ),) ,
      ),
    );
  }

}