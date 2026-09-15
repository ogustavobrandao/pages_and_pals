import 'package:flutter/material.dart';

import 'package:pages_and_pals/features/shelves/shelf_book.dart';
import 'package:pages_and_pals/features/shelves/shelf_book_card.dart';
import 'package:pages_and_pals/features/shelves/shelves_view_model.dart';

class ShelvesView extends StatefulWidget {
  const ShelvesView({
    super.key,
  });

  @override
  State<ShelvesView> createState() => _ShelvesViewState();
}

class _ShelvesViewState extends State<ShelvesView> {
  late final ShelvesViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ShelvesViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    _Header(
                      userName: viewModel.userName,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Minhas estantes',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface,
                          ),
                    ),

                    const SizedBox(height: 20),

                    _ShelfSelector(
                      selectedStatus: viewModel.selectedStatus,
                      onChanged: viewModel.selectStatus,
                    ),

                    const SizedBox(height: 18),

                    _ShelfToolbar(
                      bookCount: viewModel.bookCount,
                      onOrderPressed: () {
                        // futuramente:
                        // abrir opções de ordenação
                      },
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: _BooksList(
                        books: viewModel.books,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 20,
                bottom: 18,
                child: _AddBookButton(
                  onPressed: () {
                    // futuramente:
                    // Navigator...
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;

  const _Header({
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Boa leitura,',
          style: textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          userName,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ShelfSelector extends StatelessWidget {
  final ShelfStatus selectedStatus;
  final ValueChanged<ShelfStatus> onChanged;

  const _ShelfSelector({
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ShelfSelectorItem(
              title: 'Quero ler',
              selected: selectedStatus == ShelfStatus.wantToRead,
              onTap: () {
                onChanged(
                  ShelfStatus.wantToRead,
                );
              },
            ),
          ),

          Expanded(
            child: _ShelfSelectorItem(
              title: 'Lendo',
              selected: selectedStatus == ShelfStatus.reading,
              onTap: () {
                onChanged(
                  ShelfStatus.reading,
                );
              },
            ),
          ),

          Expanded(
            child: _ShelfSelectorItem(
              title: 'Lido',
              selected: selectedStatus == ShelfStatus.read,
              onTap: () {
                onChanged(
                  ShelfStatus.read,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelfSelectorItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ShelfSelectorItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            title,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: selected
                  ? colors.onPrimary
                  : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShelfToolbar extends StatelessWidget {
  final int bookCount;
  final VoidCallback onOrderPressed;

  const _ShelfToolbar({
    required this.bookCount,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            '$bookCount ${bookCount == 1 ? 'livro' : 'livros'}',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),

        InkWell(
          onTap: onOrderPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swap_vert_rounded,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),

                const SizedBox(width: 4),

                Text(
                  'Ordenar',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BooksList extends StatelessWidget {
  final List<ShelfBook> books;

  const _BooksList({
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const _EmptyShelf();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 100,
      ),
      itemCount: books.length,
      separatorBuilder: (
        context,
        index,
      ) {
        return const SizedBox(
          height: 8,
        );
      },
      itemBuilder: (
        context,
        index,
      ) {
        final book = books[index];

        return ShelfBookCard(
          book: book,
          onTap: () {
            // futuramente:
            // abrir detalhes do livro
          },
        );
      },
    );
  }
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 80,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 36,
              color: colors.onSurfaceVariant,
            ),

            const SizedBox(height: 12),

            Text(
              'Nenhum livro nesta estante',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Adicione um livro para começar.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddBookButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                color: colors.onPrimary,
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                'Adicionar livro',
                style: textTheme.labelMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}