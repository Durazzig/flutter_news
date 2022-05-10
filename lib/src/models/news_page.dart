import 'package:flutter/cupertino.dart';
import 'package:news_app/src/models/article_category.dart';

class NewsPage {
  final String title;
  final IconData icon;
  final ArticleCategory category;

  const NewsPage(
      {required this.title, required this.icon, required this.category});
}
