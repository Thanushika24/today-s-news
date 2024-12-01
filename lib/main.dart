import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todaysnews/routing/pages.dart';
import 'package:todaysnews/routing/routes.dart';
import 'package:todaysnews/widgets/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return GetMaterialApp(
        title: 'Todays News  ',
        debugShowCheckedModeBanner: false,
        theme: themeController.isDarkMode.value
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.black,
                scaffoldBackgroundColor: Colors.black,
              )
            : ThemeData.light().copyWith(
                primaryColor: Colors.white,
                scaffoldBackgroundColor: Colors.white,
              ),
        initialRoute: AppRoute.HOME,
        getPages: getRoutes,
      );
    });
  }
}
