import 'package:flutter/material.dart';
import 'package:pages_and_pals/features/books/book_search_screen.dart';
import 'package:pages_and_pals/features/users/profile_screen.dart';

import '../../../features/shelves/shelves_view.dart';
import 'bottom_menu.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    ShelvesView(),

    BookSearchScreen(),

    Center(
      child: Text('Scanner'),
    ),

    ProfileScreen(),
  ];

  void _onMenuTap(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onTap: _onMenuTap,
      ),
    );
  }
}