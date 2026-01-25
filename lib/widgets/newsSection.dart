import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/newsdetails.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

Future<List> getNewsData() async {
  try {
    var response = await get(Uri.parse(
        "https://newsapi.org/v2/everything?q=addiction&apiKey=06d0fc79ff2247a6a703f07583ec08d1"));
    Map responseBody = jsonDecode(response.body);
    return responseBody['articles'] ?? [];
  } catch (e) {
    print("Error fetching news: $e");
    return [];
  }
}

class _NewsSectionState extends State<NewsSection> {
  late Future<List> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Container(
      height: h * 0.25,
      child: FutureBuilder<List>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: KPrimaryColor,
              ),
            );
          }
    
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Error Occurs',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
    
          List articles = snapshot.data!;
          if (articles.isEmpty) {
            return Center(
              child: Text(
                'ُThere is no news',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
    
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: articles.length > 10 ? 10 : articles.length, // حد أقصى 10 أخبار
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>NewsDetailScreen(article: article)));
                },
                child: Container(
                  width: w * 0.75,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: KPrimaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                      Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>NewsDetailScreen(article: article)));
                },
                      child: Row(
                        children: [
                          // صورة الخبر
                          Container(
                            width: w * 0.28,
                            decoration: BoxDecoration(
                              
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              image: article["urlToImage"] != null &&
                                      article["urlToImage"].toString().isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        article["urlToImage"],
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: KTextFieldColor.withOpacity(0.3),
                            ),
                            child: article["urlToImage"] == null ||
                                    article["urlToImage"].toString().isEmpty
                                ? Center(
                                    child: Icon(
                                      Icons.article,
                                      size: 40,
                                      color: KPrimaryColor,
                                    ),
                                  )
                                : null,
                          ),
                          
                          // تفاصيل الخبر
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // العنوان
                                  Text(
                                    article['title']?.toString() ?? 'There is no title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  SizedBox(height: 8),
                                  
                                  // الوصف
                                  Expanded(
                                    child: Text(
                                      article['description']?.toString() ?? 'No descritption',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  
                                  SizedBox(height: 8),
                                  
                                  // المصدر والتاريخ
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          article['source']['name']?.toString() ?? 'Unknown',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: KPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (article['publishedAt'] != null)
                                        Text(
                                          formatDate(article['publishedAt']),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }
  
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}