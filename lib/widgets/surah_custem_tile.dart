import 'package:equran/constants/constants.dart';
import 'package:flutter/material.dart';
import '../models/surah.dart';

Widget SurahCustomListTile({
     required Surah surah ,
     required BuildContext context ,
     required VoidCallback ontap})
{
  return GestureDetector(
     onTap: ontap,
     child: Container(
       width: MediaQuery.of(context).size.width,

      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 60,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: themebackground.br,
                ),
                child: Center(child:Text((surah.number).toString(),
                  style: const TextStyle(color:Colors.white ,fontSize: 16,fontWeight: FontWeight.bold),),
              ),),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.englishName!,style: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                  Text(surah.englishNameTranslation!,style:const TextStyle(color:Colors.black54)),
                ],
              ),
              const Spacer(),
              Text(surah.name!,style: const TextStyle(color: Colors.black87,
                  fontWeight: FontWeight.bold,fontSize: 13),),
            ],
          ),
        ],
      ),
    ),
  );
}


