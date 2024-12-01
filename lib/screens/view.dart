import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todaysnews/models/news.dart';

class ViewNewsPage extends StatelessWidget {
  final News article;

  const ViewNewsPage({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          article.source.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141F), Color(0xFF243B55)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 110.0, left: 16.0,right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News Image
                  if (article.urlToImage != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          article.urlToImage!,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.white38,
                        size: 50,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Author and Date
                  Row(
                    children: [
                      if (article.author != null)
                        Text(
                          'By ${article.author}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        '${article.publishedAt.toLocal()}'.split(' ')[0],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Content
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        article.content ?? 'No content available.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.share),
        onPressed: () {
          final articleUrl = article.url ?? 'No URL available';
          final articleTitle = article.title;
          Share.share(
            'Check out this article: $articleTitle\n\nRead more at: $articleUrl',
            subject: 'Sharing an article',
          );
        },
      ),
    );
  }
}
