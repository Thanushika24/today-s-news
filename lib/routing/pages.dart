import 'package:get/get.dart';
import 'package:todaysnews/screens/home.dart';
import 'package:todaysnews/screens/sort.dart';
import 'package:todaysnews/screens/sved_news.dart';
import 'routes.dart';

var getRoutes = [
  GetPage(name: AppRoute.HOME, page: () => HomePage()),
  GetPage(name: AppRoute.CATEGORY_NOTE, page: () => const CategoryArticle()),
  GetPage(name: AppRoute.SAV_NEWS, page: () => SavedArticlesPage()),
];
