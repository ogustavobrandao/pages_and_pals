import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/book.dart';
import '../services/google_books_service.dart';
import '../widgets/error_state.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final _service = GoogleBooksService();

  late Future<Book> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getBookById(widget.bookId);
  }

  void _retry() {
    setState(() {
      _future = _service.getBookById(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.chip, borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.chevron_left, color: AppColors.accent),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<Book>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                  }
                  if (snapshot.hasError) {
                    return ErrorState(
                      message: snapshot.error.toString().replaceFirst('Exception: ', ''),
                      onRetry: _retry,
                    );
                  }
                  return _BookDetailsBody(book: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookDetailsBody extends StatelessWidget {
  const _BookDetailsBody({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 116,
                  height: 172,
                  child: book.thumbnailUrl != null
                      ? Image.network(
                          book.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(color: AppColors.borderMuted),
                        )
                      : Container(color: AppColors.borderMuted),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: appSerif(fontSize: 22, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Text(book.authorsLabel, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
                    if (book.averageRating != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 18, color: AppColors.accentStrong),
                          const SizedBox(width: 4),
                          Text(
                            book.averageRating!.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                          if (book.ratingsCount != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(${book.ratingsCount} avaliações)',
                              style: const TextStyle(fontSize: 12, color: AppColors.textFaint),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text('Sinopse', style: appSerif(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            (book.description == null || book.description!.trim().isEmpty)
                ? 'Sem sinopse disponível para este livro.'
                : book.description!,
            style: const TextStyle(fontSize: 14.5, height: 1.55, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }
}
