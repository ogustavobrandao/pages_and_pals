import 'package:flutter/material.dart';

import 'package:pages_and_pals/features/shelves/shelf_book.dart';

class ShelfFilter extends StatelessWidget {
  final ShelfStatus selectedStatus;
  final ValueChanged<ShelfStatus> onChanged;

  const ShelfFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            label: 'Quero ler',
            selected: selectedStatus == ShelfStatus.wantToRead,
            onTap: () => onChanged(
              ShelfStatus.wantToRead,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _FilterButton(
            label: 'Lendo',
            selected: selectedStatus == ShelfStatus.reading,
            onTap: () => onChanged(
              ShelfStatus.reading,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _FilterButton(
            label: 'Lido',
            selected: selectedStatus == ShelfStatus.read,
            onTap: () => onChanged(
              ShelfStatus.read,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.primary
                : colors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: selected
                  ? colors.onPrimary
                  : colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}