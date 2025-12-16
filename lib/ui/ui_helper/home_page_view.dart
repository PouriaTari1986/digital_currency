

import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class HomePageView extends StatefulWidget {
   dynamic controller;
   HomePageView({super.key,required this.controller});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var images = [
 Assets.images.a1.path,
 Assets.images.a2.path,
 Assets.images.a3.path,
 Assets.images.a4.path
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      controller: widget.controller,
      children: [
        myPages(images[0]),
        myPages(images[1]),
        myPages(images[2]),
        myPages(images[3]),
      ],
    );
  }
  Widget myPages(String image){
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image(image: AssetImage(image),fit: BoxFit.fill,),
    );
  }
}
