import 'package:flutter/material.dart';

import '../data/articles_data.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/news_card.dart';
import '../widgets/widget_with_seo.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryTitle =
        category.substring(0, 1).toUpperCase() + category.substring(1);

    final categoryArticles =
        articlesData
            .where(
              (article) =>
                  article.category.toLowerCase() == category.toLowerCase(),
            )
            .toList();

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
              title: "$categoryTitle | InfoFlash",
              description:
                  "Découvrez toutes les actualités de la catégorie $categoryTitle sur InfoFlash",
              keywords: "actualités, $category, news, information",
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
                  // Category Title
                  Semantics(
                    header: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catégorie : $categoryTitle',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Articles Grid
                  if (categoryArticles.isNotEmpty)
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: categoryArticles.length,
                          itemBuilder: (context, index) {
                            return NewsCard(article: categoryArticles[index]);
                          },
                        );
                      },
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'Aucun article trouvé dans cette catégorie',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
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
