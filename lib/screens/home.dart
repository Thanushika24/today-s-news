import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todaysnews/db_connection/db_helper.dart';
import 'package:todaysnews/screens/view.dart';
import 'package:todaysnews/services/news_api.dart';
import 'package:todaysnews/models/news.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/theme_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<News>> _futureArticles;
  late Future<List<News>> _everything;
  final ThemeController themeController = Get.find();
  bool _isSearchActive = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;

  String? _selectedCategory;


  @override
  void initState() {
    super.initState();

    _futureArticles = NewsApiService().fetchTopHeadlines(country: 'us');
    _everything = NewsApiService().fetchEverything();
    print("Fetching.....");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/sort');
      case 2:
        Navigator.pushNamed(context, '/saved');
    }
  }

  Future<void> _saveArticle(News article) async {
    try {
      final articleMap = article.toJson();

      await DatabaseHelper.instance.saveArticle(articleMap);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24), // Success icon
              SizedBox(width: 8), // Space between icon and text
              Expanded(
                child: Text(
                  'Article saved to device!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green, // Success color
          behavior: SnackBarBehavior.floating, // Floating snack bar
          margin: const EdgeInsets.all(10), // Margin around snack bar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          duration: const Duration(seconds: 3), // Duration of the snack bar
          action: SnackBarAction(
            label: 'Undo', // Option to undo action
            textColor: Colors.white,
            onPressed: () {
              // Implement undo action (e.g., delete the saved article)
              print('Undo action pressed');
            },
          ),
        ),
      );
    } catch (e) {
      print('Error saving article: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 24), // Error icon
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to save article.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // Error color
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.black, Color(0xFF333333)] // Dark theme gradient
                  : [Color(0xFFF5E8AA), Color(0xFFF5E8AA)], // Light theme gradient
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
              stops: [0.1, 0.0],
            ),
        ),
        child: FutureBuilder<List<News>>(
          future: _futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No articles found.'));
            } else {
              final articles = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row to display "TODAY'S" and "NEWS" on the same line
                          Row(
                            children: [
                              // "TODAY'S" with a blue background
                              Container(
                                color: isDarkMode
                                    ? Colors.black
                                    : Colors.deepOrangeAccent,  // Background color for "TODAY'S"
                                padding: EdgeInsets.only(left: 20,right: 2),  // Adjust padding if needed
                                child: const Text(
                                  "TODAY'S ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              // "NEWS" with a white background
                              Container(
                                color: Colors.white,  // Background color for "NEWS"
                                padding: EdgeInsets.only(left: 20,right: 2),  // Adjust padding if needed
                                child: const Text(
                                  "NEWS",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 0),

                          // Additional Row for "Welcome" text and Theme toggle button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Obx(() => Icon(
                                  themeController.isDarkMode.value
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                )),
                                onPressed: () {
                                  themeController.toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                _isSearchActive = true;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              hintText: "Search for news...",
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_searchQuery.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12.0),

                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Head ",
                                style: TextStyle(color: isDarkMode
                                    ? Colors.white
                                    : Colors.black, fontSize: 28.0,fontWeight:FontWeight.w700 ),
                              ),
                              TextSpan(
                                text: "Lines",
                                style: TextStyle(color: isDarkMode
                                    ? Colors.white
                                    : Colors.deepOrangeAccent, fontSize: 28.0,fontWeight:FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_searchQuery.isEmpty)
                      SizedBox(
                        height: 310,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              width: 260,
                              margin: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewNewsPage(article: article),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image section
                                      if (article.urlToImage != null)
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: Image.network(
                                            article.urlToImage!,
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      else
                                        Container(
                                          height: 160,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                                          ),
                                        ),
                                      // Content section
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Title
                                            Text(
                                              article.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Date and additional info
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      article.publishedAt != null
                                                          ? DateFormat('yMMMd').format(article.publishedAt!)
                                                          : '',
                                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.share, color: isDarkMode
                                                      ? Colors.deepOrangeAccent
                                                      : Colors.black),
                                                  onPressed: () {
                                                    final articleUrl = article.url ?? 'No URL available';
                                                    final articleTitle = article.title;
                                                    Share.share(
                                                      'Check out this article: $articleTitle\n\nRead more at: $articleUrl',
                                                      subject: 'Sharing an article',
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons
                                                        .cloud_download,
                                                    color: isDarkMode
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    _saveArticle(article);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),






                    Column(
                      children: [
                        FutureBuilder<List<News>>(
                          future: _everything,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No articles found.'));
                            } else {
                              final articles = snapshot.data!;
                              final filteredNews = articles
                                  .where((article) => article.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                                  .toList();

                              final displayList = _searchQuery.isEmpty ? articles : filteredNews;

                              return Column(
                                mainAxisSize: MainAxisSize.min,


                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5.0),
                                    child: Column(children: [
                                      Text("All News",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),)
                                    ],),
                                  ),

                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: displayList.length,
                                    itemBuilder: (context, index) {
                                      final article = displayList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewNewsPage(article: article),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(

                                                children: [
                                                  if (article.urlToImage != null)
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                                      child: Image.network(
                                                        article.urlToImage!,
                                                        height: 120,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      height: 120,
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image, size: 50),
                                                    ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    article.title,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            article.publishedAt != null
                                                                ? DateFormat('yMMMd').format(article.publishedAt!)
                                                                : '',
                                                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.share, color: isDarkMode
                                                            ? Colors.deepOrangeAccent
                                                            : Colors.black),
                                                        onPressed: () {
                                                          final articleUrl = article.url ?? 'No URL available';
                                                          final articleTitle = article.title;
                                                          Share.share(
                                                            'Check out this article: $articleTitle\n\nRead more at: $articleUrl',
                                                            subject: 'Sharing an article',
                                                          );
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .cloud_download,
                                                          color: isDarkMode
                                                              ? Colors.deepOrangeAccent
                                                              : Colors.black,
                                                          size: 30,
                                                        ),
                                                        onPressed: () {
                                                          _saveArticle(article);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        )

                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Color(0xFF333333)] // Dark theme gradient
                : [Color(0xFFF5E8AA), Color(0xFFF5E8AA)], // Light theme gradient
            begin: Alignment.bottomCenter,
            end: Alignment.topLeft,
            stops: [0.1, 0.0],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp),
              label: 'Find',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save_alt),
              label: 'Saved',
            ),
          ],
        ),
      ),

    );
  }
}