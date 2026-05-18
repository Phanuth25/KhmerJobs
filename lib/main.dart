import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/page/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KhmerJobs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
        fontFamily: 'Inter',
      ),
      // initialRoute: '/',
      // getPages: [
      //   // what goes here?
      // ],
      home: WelcomeScreen(),
    );
  }
}
