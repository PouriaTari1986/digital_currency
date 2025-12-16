

import 'package:flutter/material.dart';

class ButtomNav extends StatelessWidget {
  PageController controller;
   ButtomNav({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      color: Colors.blue,

      child: SizedBox(

        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width/2-20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    controller.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }, icon: Icon(Icons.home,size: 30,)),
                  IconButton(onPressed: (){
                    controller.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }, icon: Icon(Icons.bar_chart,size: 30)),

                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width/2-20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    controller.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }, icon: Icon(Icons.person_2_sharp,size: 30)),
                  IconButton(onPressed: (){
                    controller.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }, icon: Icon(Icons.bookmark_sharp,size: 30)),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
