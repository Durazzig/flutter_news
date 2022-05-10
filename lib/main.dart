import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/src/models/article_category.dart';
import 'package:news_app/src/models/news_page.dart';
import 'package:news_app/src/widgets/news_list.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await dotenv.load(fileName: '.env');

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('News Application');
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setSize(const Size(1280, 720));
    await windowManager.setMinimumSize(const Size(755, 545));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'News App',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.orange,
      ),
      home: const MyHomePage(
        title: 'News App',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  final viewKey = GlobalKey();
  int index = 0;
  final List<NewsPage> pages = const [
    NewsPage(
        title: 'Top Headlines',
        icon: FluentIcons.news,
        category: ArticleCategory.general),
    NewsPage(
        title: 'Business',
        icon: FluentIcons.business_center_logo,
        category: ArticleCategory.business),
    NewsPage(
        title: 'Technology',
        icon: FluentIcons.laptop_secure,
        category: ArticleCategory.technology),
    NewsPage(
        title: 'Entertainment',
        icon: FluentIcons.my_movies_t_v,
        category: ArticleCategory.entertainment),
    NewsPage(
        title: 'Sports',
        icon: FluentIcons.more_sports,
        category: ArticleCategory.sports),
    NewsPage(
        title: 'Science',
        icon: FluentIcons.communications,
        category: ArticleCategory.science),
    NewsPage(
        title: 'Health',
        icon: FluentIcons.health,
        category: ArticleCategory.health)
  ];

  @override
  void initState() {
    // TODO: implement initState
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() {
          index = i;
        }),
        displayMode: PaneDisplayMode.compact,
        items: pages
            .map<NavigationPaneItem>(
                (e) => PaneItem(icon: Icon(e.icon), title: Text(e.title)))
            .toList(),
      ),
      content: NavigationBody.builder(
        index: index,
        itemBuilder: (ctx, index) {
          return NewsListPage(newPage: pages[index]);
        },
      ),
    );
  }

  @override
  void onWindowClose() async {
    // TODO: implement onWindowClose
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm Close'),
            content: const Text('Are you sure you want to close the window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              FilledButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
    super.onWindowClose();
  }
}
