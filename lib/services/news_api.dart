import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsApiService {
  static const String _apiKey = '847dbbb5248c4d1b93d5aa20ae3109d2';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Fetch Top Headlines
  Future<List<News>> fetchTopHeadlines({String? country}) async {
    final url =
        Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Headlines response: $jsonData");
      final List articles = jsonData['articles'];
      return articles.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  // Search News by Date
  Future<List<News>> searchNews(String from) async {
    final url = Uri.parse(
        '$_baseUrl/everything?q=Apple&from=$from&sortBy=popularity&apiKey=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List articles = jsonData['articles'];
      return articles.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }

  // All News Articles
  Future<List<News>> fetchEverything() async {
    final url = Uri.parse('$_baseUrl/everything?q=bitcoin&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("everything: $jsonData");
      final List articles = jsonData['articles'];
      return articles.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search articles');
    }
  }
}
