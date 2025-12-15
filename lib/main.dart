import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_a/ui/ui_helper/theme_switcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.blue,
                      title: Text("ExChange Currencies",style: TextStyle(color: Colors.white),),
                      actions: [
                          ThemeSwitcher()
                      ],
                    ),
                    body: Container(),
                  ),
          )),
    );
  }
}
