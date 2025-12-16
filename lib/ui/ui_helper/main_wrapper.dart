import 'package:flutter/material.dart';
import 'package:training_a/ui/home_page.dart';
import 'package:training_a/ui/market_view_page.dart';
import 'package:training_a/ui/watch_list_page.dart';

import '../profile_page.dart';
import 'buttom_nav.dart' show ButtomNav;

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
      child:  Icon(Icons.compare_arrows_outlined),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ButtomNav(controller: _myPage),
      body: PageView(
        controller: _myPage,
        children: [
          HomePage(),
          MarketViewPage(),
          ProfilePage(),
          WatchListPage(),
        ],
      ),
    );
  }
}
