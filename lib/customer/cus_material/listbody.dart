import 'package:flutter/material.dart';

class listbody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: ListView(
          children: [
            Container(
              height: 700,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color(0xfffaf4d9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),),

            ),
          ],
        ),
      );
  }
}