import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
import 'package:intl/date_symbol_data_local.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'data/articles_data.dart';
import 'models/article.dart';
import 'providers/theme_provider.dart';
import 'screens/article_page.dart';
import 'screens/category_page.dart';
import 'screens/home_page.dart';

void main() {
  // Use path URL strategy for better SEO (removes # from URLs)
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();

  // Initialize date formatting
  initializeDateFormatting('fr_FR', null);

  // Add French locale for timeago
  timeago.setLocaleMessages('fr', timeago.FrMessages());

  if (kIsWeb) {
    MetaSEO().config();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'InfoFlash - L\'actualité qui fait réfléchir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF97316),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF97316),
          primary: const Color(0xFFF97316),
          secondary: const Color(0xFF334155),
          background: const Color(0xFFF6F8FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFFF97316),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF97316),
          primary: const Color(0xFFF97316),
          secondary: const Color(0xFF94A3B8),
          background: const Color(0xFF0A0A0A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Parse the route
        final uri = Uri.parse(settings.name!);
        final pathSegments = uri.pathSegments;

        // Add SEO metadata based on the route
        if (uri.path == '/') {
          MetaSEO meta = MetaSEO();

          meta.ogTitle(ogTitle: "InfoFlash - L'actualité qui fait réfléchir");
          meta.ogDescription(
            ogDescription:
                "Découvrez les dernières actualités et tendances avec InfoFlash, votre portail d'information de référence.",
          );
          meta.keywords(
            keywords:
                "actualités, news, information, politique, économie, science, culture, sport",
          );
          meta.author(author: "InfoFlash");
          meta.ogImage(ogImage: "https://example.com/og-image.jpg");
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const HomePage(),
          );
        }
        // Article route: /article/[id]
        else if (pathSegments.length == 2 && pathSegments[0] == 'article') {
          final articleId = pathSegments[1];
          final article = articlesData.firstWhere(
            (a) => a.id == articleId,
            orElse: () => Article.empty(),
          );

          if (article.id.isNotEmpty) {
            MetaSEO meta = MetaSEO();

            meta.ogTitle(ogTitle: "${article.title} | InfoFlash");
            meta.ogDescription(ogDescription: article.excerpt);
            meta.keywords(
              keywords:
                  "actualités, ${article.category.toLowerCase()}, ${article.title.split(' ').take(5).join(', ')}",
            );
            meta.author(author: article.author);
            meta.ogImage(ogImage: article.image);
          }

          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ArticlePage(articleId: articleId),
          );
        }
        // Category route: /category/[category]
        else if (pathSegments.length == 2 && pathSegments[0] == 'category') {
          final category = pathSegments[1];
          final categoryTitle =
              category.substring(0, 1).toUpperCase() + category.substring(1);

          MetaSEO meta = MetaSEO();

          meta.ogTitle(ogTitle: "$categoryTitle | InfoFlash");
          meta.ogDescription(
            ogDescription:
                "Découvrez toutes les actualités de la catégorie $categoryTitle sur InfoFlash",
          );
          meta.keywords(keywords: "actualités, $category, news, information");
          meta.author(author: "InfoFlash");
          meta.ogImage(ogImage: "https://example.com/og-image.jpg");

          return MaterialPageRoute(
            settings: settings,
            builder: (context) => CategoryPage(category: category),
          );
        }

        // Default route
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomePage(),
        );
      },
    );
  }
}
