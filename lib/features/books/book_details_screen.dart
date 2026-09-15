import 'package:flutter/material.dart';

import 'book.dart';
import '../../core/services/google_books_service.dart';
import '../../core/design_system/widgets/error_state.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder<Book>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return ErrorState(
                      message: snapshot.error
                          .toString()
                          .replaceFirst('Exception: ', ''),
                      onRetry: _retry,
                    );
                  }

                  return _BookDetailsBody(
                    book: snapshot.data!,
                  );
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
  const _BookDetailsBody({
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
                          errorBuilder: (_, _, _) {
                            return _coverPlaceholder(context);
                          },
                        )
                      : _coverPlaceholder(context),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: theme.textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      book.authorsLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    if (book.averageRating != null) ...[
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: colors.primary,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            book.averageRating!.toStringAsFixed(1),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),

                          if (book.ratingsCount != null) ...[
                            const SizedBox(width: 6),

                            Text(
                              '(${book.ratingsCount} avaliações)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
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

          Text(
            'Sinopse',
            style: theme.textTheme.titleLarge,
          ),

          const SizedBox(height: 8),

          Text(
            (book.description == null ||
                    book.description!.trim().isEmpty)
                ? 'Sem sinopse disponível para este livro.'
                : book.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverPlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}