import 'package:brentwoodtechs/store_data/provider.dart';
import 'package:brentwoodtechs/store_data/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'landingpage/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserDataModel()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return  GetMaterialApp(

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:  MainScreen(),
    );
  }
}