import 'package:flutter/material.dart';

class listappbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfffaf4d9),
      padding: EdgeInsets.all(20),
      child: Row(children: [
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Color(0xff99ccff),
          ),
        ),
      ],),
    );
  }
}