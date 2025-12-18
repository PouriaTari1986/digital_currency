import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:training_a/providers/crypto_data_provider.dart';
import 'package:training_a/providers/market_view_provider.dart';
import 'package:training_a/providers/register_provider.dart';
import 'package:training_a/providers/theme_provider.dart';
import 'package:training_a/ui/ui_helper/main_wrapper.dart';
import 'components/const/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) =>CryptoDataProvider()),
      ChangeNotifierProvider(create: (context) => MarketViewProvider(),),
      ChangeNotifierProvider(create: (context) => RegisterProvider(),)

    ],
      child: MyApp(),
    )

     );
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
    return
      Consumer<ThemeProvider>(builder: (context, value, child) =>
      MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("en", "US"),
          Locale("fa", "IR"),
        ],
        themeMode: value.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,

      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.ltr,
          child:MainWrapper()),
      // home: FutureBuilder<SharedPreferences>(
      //     future: SharedPreferences.getInstance(),
      //     builder: (context, snapshot) {
      //     if(snapshot.hasData){
      //       SharedPreferences sharedPreferences = snapshot.data!;
      //       var loggedInState = sharedPreferences.getBool("loggedIn")??false;
      //       if(loggedInState){
      //         return MainWrapper();
      //       }else{
      //         return SignUpScreen();
      //       }
      //     }return Center(child: CircularProgressIndicator(),);
      //     },)
      ),
    );
  }
}
