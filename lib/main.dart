import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'src/customer/Map/mapmain.dart';
import 'src/Material/splash_screen.dart';
import 'src/customer/search/search.dart';
import 'src/drawer_controller/drawer_controller.dart';

void main() async {
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      onInit: () async {
        Get.put(CustomDrawerController());
      },

      initialRoute: '/',
      routes: {
        '/': (context) => splashscreen(),
        '/main': (context) => mapmain(),
        '/search': (context) => Search(),
      },
    );
  }
}
