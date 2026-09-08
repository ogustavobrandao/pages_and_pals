class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publishedYear;
  final double? averageRating;
  final int? ratingsCount;

  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.description,
    this.thumbnailUrl,
    this.publishedYear,
    this.averageRating,
    this.ratingsCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = (json['volumeInfo'] as Map<String, dynamic>?) ?? const {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
    final publishedDate = volumeInfo['publishedDate'] as String?;
    final String? thumbnail =
        (imageLinks?['thumbnail'] as String?) ?? (imageLinks?['smallThumbnail'] as String?);

    return Book(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Sem título',
      authors: (volumeInfo['authors'] as List<dynamic>?)?.cast<String>() ?? const [],
      description: _stripHtml(volumeInfo['description'] as String?),
      thumbnailUrl: thumbnail?.replaceFirst('http://', 'https://'),
      publishedYear: (publishedDate != null && publishedDate.length >= 4)
          ? publishedDate.substring(0, 4)
          : null,
      averageRating: (volumeInfo['averageRating'] as num?)?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'] as int?,
    );
  }

  String get authorsLabel => authors.isEmpty ? 'Autor desconhecido' : authors.join(', ');
}

String? _stripHtml(String? html) {
  if (html == null) return null;

  var text = html
      .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<\s*/p\s*>', caseSensitive: false), '\n\n')
      .replaceAll(RegExp(r'<[^>]+>'), '');

  text = text
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ');

  return text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}
