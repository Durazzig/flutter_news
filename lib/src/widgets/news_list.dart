import 'package:fluent_ui/fluent_ui.dart';
import 'package:news_app/src/models/article.dart';
import 'package:news_app/src/models/news_page.dart';
import 'package:news_app/src/services/news_api.dart';
import 'package:news_app/src/widgets/news_item.dart';
import 'package:flutter/material.dart' as material;

class NewsListPage extends StatefulWidget {
  final NewsPage newPage;
  final NewsAPI newsAPI = const NewsAPI();
  const NewsListPage({Key? key, required this.newPage}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = widget.newsAPI.fetchArticles(widget.newPage.category);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text(widget.newPage.title),
      ),
      content: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 270,
                  mainAxisExtent: 290,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                return NewsItem(
                  article: snapshot.data![index],
                );
              },
            );
          } else if (snapshot.hasError) {
            Typography typography = FluentTheme.of(context).typography;
            return Column(
              children: [
                const Spacer(),
                Center(
                  child: Text(
                    '${snapshot.error}',
                    style: typography.bodyStrong,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FilledButton(
                  child: const Text('Refresh'),
                  onPressed: () {
                    setState(() {
                      futureArticles =
                          widget.newsAPI.fetchArticles(widget.newPage.category);
                    });
                  },
                ),
                const Spacer()
              ],
            );
          }
          return const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: material.CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
