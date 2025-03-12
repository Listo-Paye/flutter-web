import 'package:flutter/material.dart';

import '../data/articles_data.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/news_card.dart';
import '../widgets/widget_with_seo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final featuredArticle = articlesData[0];
    final recentArticles = articlesData.sublist(1);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppHeader(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SEO Metadata
            WidgetWithSeo(
              title: "InfoFlash - L'actualité qui fait réfléchir",
              description:
                  "Découvrez les dernières actualités et tendances avec InfoFlash, votre portail d'information de référence.",
              keywords:
                  "actualités, news, information, politique, économie, science, culture, sport",
              author: "InfoFlash",
              image: "https://example.com/og-image.jpg",
              child: Container(),
            ),

            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Article Section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'À la une',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        NewsCard(article: featuredArticle, featured: true),
                      ],
                    ),
                  ),

                  // Recent Articles Section
                  Semantics(
                    header: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Actualités récentes',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive grid layout
                      int crossAxisCount = 1;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: recentArticles.length,
                        itemBuilder: (context, index) {
                          return NewsCard(article: recentArticles[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
