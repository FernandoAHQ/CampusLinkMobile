class Article {
  final int id;
  final String title;
  final String? content;
  final List<String>? tags;
  final String imageUrl;
  final DateTime createdAt;

  const Article({
    required this.id,
    required this.title,
    this.content,
    required this.tags,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final title = json['title'] as String;
    final content = json['content'] as String?;
    final tags =
        (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList();
    final imageUrl = json['image_url'] as String;
    final createdAt = DateTime.parse(json['created_at'] as String);

    return Article(
      id: id,
      title: title,
      content: content,
      tags: tags,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  // Static method to convert a list of articles from the response
  static List<Article> fromJsonList(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    return data
        .map((articleJson) =>
            Article.fromJson(articleJson as Map<String, dynamic>))
        .toList();
  }
}
