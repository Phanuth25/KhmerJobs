import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:khmerjobs/public/controller/auth_controller.dart';
import 'package:khmerjobs/public/controller/jobs_controller.dart';
import 'package:khmerjobs/public/page/welcome.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();

  // 2. Put the storage into GetX memory
  Get.put(const FlutterSecureStorage());
  // Initialize your controller here
  Get.put(AuthController());
  Get.put(JobsController());
  runApp(const MyApp());
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
