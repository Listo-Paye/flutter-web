import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/article.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final bool featured;

  const NewsCard({Key? key, required this.article, this.featured = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publishedDate = DateTime.parse(article.publishedAt);
    final formattedDate = timeago.format(publishedDate, locale: 'fr');

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: featured ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/article/${article.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Image.network(
              article.image,
              height: featured ? 240 : 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: featured ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    article.excerpt,
                    style: TextStyle(
                      fontSize: featured ? 16 : 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: featured ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Author and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
