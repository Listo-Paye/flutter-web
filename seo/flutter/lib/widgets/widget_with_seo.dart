import 'package:flutter/widgets.dart';
import 'package:meta_seo/meta_seo.dart';

class WidgetWithSeo extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final String keywords;
  final String author;
  final String image;

  const WidgetWithSeo({
    super.key,
    required this.child,
    required this.title,
    required this.description,
    required this.keywords,
    required this.author,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    MetaSEO meta = MetaSEO();
    meta.ogTitle(ogTitle: title);
    meta.ogDescription(ogDescription: description);
    meta.keywords(keywords: keywords);
    meta.author(author: author);
    meta.ogImage(ogImage: image);
    return child;
  }
}
