import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../data/articles_data.dart';
import '../models/article.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/news_card.dart';
import '../widgets/widget_with_seo.dart';

class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = articlesData.firstWhere(
      (a) => a.id == articleId,
      orElse: () => Article.empty(),
    );

    // If article not found
    if (article.id.isEmpty) {
      return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppHeader(),
        ),
        body: const Center(child: Text('Article non trouvé')),
      );
    }

    // Get related articles (same category)
    final relatedArticles =
        articlesData
            .where((a) => a.category == article.category && a.id != articleId)
            .take(3)
            .toList();

    // Format date
    final publishedDate = DateTime.parse(article.publishedAt);
    final formattedDate = timeago.format(publishedDate, locale: 'fr');

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
              title: "${article.title} | InfoFlash",
              description: article.excerpt,
              keywords:
                  "actualités, ${article.category.toLowerCase()}, ${article.title.split(' ').take(5).join(', ')}",
              author: article.author,
              image: article.image,
              child: Container(),
            ),

            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Semantics(
                          header: true,
                          child: Text(
                            article.title,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Excerpt
                        Text(
                          article.excerpt,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Author and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[300],
                                  child: Text(
                                    article.author.substring(0, 1),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  article.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        const Divider(height: 32),
                      ],
                    ),
                  ),

                  // Featured Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.image,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Article Content
                  Html(
                    data: article.content,
                    style: {
                      "p": Style(
                        margin: Margins.only(bottom: 16),
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.6),
                      ),
                      "h3": Style(
                        margin: Margins.only(top: 32, bottom: 16),
                        fontSize: FontSize(22),
                        fontWeight: FontWeight.bold,
                      ),
                      "ul": Style(margin: Margins.only(bottom: 16, left: 16)),
                      "li": Style(
                        margin: Margins.only(bottom: 8),
                        lineHeight: LineHeight(1.6),
                      ),
                    },
                  ),

                  // Related Articles
                  if (relatedArticles.isNotEmpty) ...[
                    const Divider(height: 64),

                    Semantics(
                      header: true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Articles connexes',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive grid layout
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 600) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 400) {
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
                          itemCount: relatedArticles.length,
                          itemBuilder: (context, index) {
                            return NewsCard(article: relatedArticles[index]);
                          },
                        );
                      },
                    ),
                  ],
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
