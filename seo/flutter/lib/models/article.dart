class Article {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String image;
  final String author;
  final String publishedAt;
  final String category;

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.image,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  // Empty article factory for when an article is not found
  factory Article.empty() {
    return Article(
      id: '',
      title: 'Article non trouvé',
      excerpt: '',
      content: '',
      image: '',
      author: '',
      publishedAt: DateTime.now().toIso8601String(),
      category: '',
    );
  }
}
