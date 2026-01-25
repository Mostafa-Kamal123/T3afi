// news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
      ),

      backgroundColor: KPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: KPrimaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Main image
              if (article["urlToImage"] != null)
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(article["urlToImage"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: KPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            article['source']['name'] ?? 'Unknown Source',
                            style: TextStyle(
                              color: KPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (article['publishedAt'] != null)
                          Text(
                            formatDate(article['publishedAt']),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Title
                    Text(
                      article['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Author
                    if (article['author'] != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'By: ${article['author']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                    // Full content
                    Text(
                      article['content'] ??
                          article['description'] ??
                          'No content available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 30),

                    // Visit source button
                    // if (article['url'] != null)
                    //   SizedBox(
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: KButtonsColor,
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 30, vertical: 15),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //       ),
                    //       onPressed: () => _launchURL(article['url']),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(Icons.open_in_new, color: Colors.white),
                    //           SizedBox(width: 10),
                    //           Text(
                    //             'Read Full Article',
                    //             style: TextStyle(
                    //               fontSize: 18,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to open article URL
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open the link: $url';
    }
  }

  // Function to format date
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(date);
    } catch (e) {
      return '';
    }
  }
}