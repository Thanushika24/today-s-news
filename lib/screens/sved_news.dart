import 'package:flutter/material.dart';
import 'package:todaysnews/db_connection/db_helper.dart';
import 'package:todaysnews/screens/update.dart';

class SavedArticlesPage extends StatefulWidget {
  @override
  _SavedArticlesPageState createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  final _databaseHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> _getSavedArticles() async {
    return await _databaseHelper.getSavedNews();
  }

  // This method deletes the article and shows a Snackbar confirmation
  Future<void> _deleteArticle(int id) async {
    await _databaseHelper.deleteNews(id);
    setState(() {});

    // Show the success message after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Article deleted successfully!'),
        backgroundColor: Colors.green, // You can change the color if needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFFF5E8AA)],  // Darker and modern gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0, bottom: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SAVED NEWS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(  // Display saved articles
                future: _getSavedArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No saved articles.'));
                  } else {
                    final savedArticles = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: savedArticles.length,
                      itemBuilder: (context, index) {
                        final article = savedArticles[index];

                        return GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateNews(
                                  id: article['id'],
                                  initialTitle: article['title'] ?? '',
                                  initialDescription: article['description'] ?? '',
                                ),
                              ),
                            );

                            if (updated == true) {
                              // Show update success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Article updated successfully!'),
                                  backgroundColor: Colors.blue, // You can change the color if needed
                                ),
                              );
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 148,
                            width: 160,
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article['urlToImage'] != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          article['urlToImage'],
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 110,
                                        width: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrangeAccent,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  article['source_name'] ?? 'No Source',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  _deleteArticle(article['id']);
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
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
