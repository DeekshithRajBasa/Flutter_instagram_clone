import 'package:flutter/material.dart';



class singleimage extends StatelessWidget {
  final String link;

  const singleimage({super.key, required this.link});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
          body: Container(
        child: GestureDetector(
         onVerticalDragDown: (details){
           print(details);
           Navigator.pop(context);
         }
        ,
          child: Image.network(link ,  height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,)),
      ),
    );
  }
}