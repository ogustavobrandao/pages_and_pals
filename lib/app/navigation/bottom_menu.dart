import 'package:flutter/material.dart';

import '../../core/design_system/app_semantic_colors.dart';

class BottomMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomMenu({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _buildItem(
                context: context,
                index: 0,
                icon: Icons.menu_book_outlined,
                label: 'Estantes',
              ),
              _buildItem(
                context: context,
                index: 1,
                icon: Icons.search,
                label: 'Buscar',
              ),
              _buildItem(
                context: context,
                index: 2,
                icon: Icons.document_scanner_outlined,
                label: 'Scanner',
              ),
              _buildItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    final semanticColors =
        theme.extension<AppSemanticColors>()!;

    final isSelected = selectedIndex == index;

    final itemColor = isSelected
        ? theme.colorScheme.primary
        : semanticColors.navigationInactive;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: itemColor,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: itemColor,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}