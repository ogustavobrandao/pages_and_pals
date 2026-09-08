import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/book.dart';
import '../services/google_books_service.dart';
import '../widgets/error_state.dart';
import 'book_details_screen.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

enum _SearchStatus { idle, loading, error, results }

class _BookSearchScreenState extends State<BookSearchScreen> {
  final _controller = TextEditingController();
  final _service = GoogleBooksService();

  _SearchStatus _status = _SearchStatus.idle;
  String _errorMessage = '';
  List<Book> _results = const [];
  String _lastQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _status = _SearchStatus.loading;
      _lastQuery = query;
    });

    try {
      final results = await _service.searchBooks(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _status = _SearchStatus.results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = _SearchStatus.error;
      });
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration:
                              BoxDecoration(color: AppColors.chip, borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.chevron_left, color: AppColors.accent),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text('Buscar livros', style: appSerif(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border, width: 1.5),
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.surface,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.search, size: 20, color: AppColors.accent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (_) => _search(),
                                  style: const TextStyle(fontSize: 15, color: AppColors.textDark),
                                  decoration: const InputDecoration(
                                    hintText: 'Buscar por título ou autor',
                                    hintStyle: TextStyle(color: AppColors.placeholder),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _search,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.chip,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Icon(Icons.search, color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _SearchStatus.idle:
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Digite um título ou autor para buscar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
        );
      case _SearchStatus.loading:
        return const Center(child: CircularProgressIndicator(color: AppColors.accent));
      case _SearchStatus.error:
        return ErrorState(message: _errorMessage, onRetry: _search);
      case _SearchStatus.results:
        if (_results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Nenhum resultado para "$_lastQuery".',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: _results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _BookResultCard(book: _results[index]),
        );
    }
  }
}

class _BookResultCard extends StatelessWidget {
  const _BookResultCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookDetailsScreen(bookId: book.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderMuted),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: SizedBox(
                width: 54,
                height: 80,
                child: book.thumbnailUrl != null
                    ? Image.network(
                        book.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _coverPlaceholder(),
                      )
                    : _coverPlaceholder(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: appSerif(fontSize: 16, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.authorsLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  if (book.publishedYear != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.publishedYear!,
                      style: const TextStyle(fontSize: 11, color: AppColors.placeholder),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(color: AppColors.borderMuted);
  }
}
