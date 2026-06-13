class NewsItem {
  final String title;
  final String category;
  final String date;
  final String description;
  final String imageUrl;
  final String link;

  NewsItem({
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      category: json['category'] ?? 'Trending News',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'date': date,
      'description': description,
      'imageUrl': imageUrl,
      'link': link,
    };
  }
}
