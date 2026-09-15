enum ShelfStatus {
  wantToRead,
  reading,
  read,
}

class ShelfBook {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final int currentPage;
  final int totalPages;
  final ShelfStatus status;

  const ShelfBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    required this.currentPage,
    required this.totalPages,
    required this.status,
  });
}