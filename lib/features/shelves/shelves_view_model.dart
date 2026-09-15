import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pages_and_pals/features/shelves/shelf_book.dart';

class ShelvesViewModel extends ChangeNotifier {
  final FirebaseAuth _auth;

  ShelvesViewModel({
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  ShelfStatus _selectedStatus = ShelfStatus.reading;

  ShelfStatus get selectedStatus => _selectedStatus;

  String get userName {
    final user = _auth.currentUser;
    final fullName = user?.displayName?.trim();

    if (fullName == null || fullName.isEmpty) {
      return 'Leitor';
    }

    return fullName.split(' ').first;
  }

  final List<ShelfBook> _books = const [
    ShelfBook(
      id: '1',
      title: 'O Senhor dos Anéis',
      author: 'J.R.R. Tolkien',
      currentPage: 320,
      totalPages: 1216,
      status: ShelfStatus.reading,
    ),
    ShelfBook(
      id: '2',
      title: 'Vidas Secas',
      author: 'Graciliano Ramos',
      currentPage: 42,
      totalPages: 176,
      status: ShelfStatus.reading,
    ),
    ShelfBook(
      id: '3',
      title: 'Kafka à Beira-Mar',
      author: 'Haruki Murakami',
      currentPage: 210,
      totalPages: 592,
      status: ShelfStatus.reading,
    ),
    ShelfBook(
      id: '4',
      title: '1984',
      author: 'George Orwell',
      currentPage: 0,
      totalPages: 328,
      status: ShelfStatus.wantToRead,
    ),
    ShelfBook(
      id: '5',
      title: 'Dom Casmurro',
      author: 'Machado de Assis',
      currentPage: 256,
      totalPages: 256,
      status: ShelfStatus.read,
    ),
  ];

  List<ShelfBook> get books {
    return _books
        .where(
          (book) => book.status == _selectedStatus,
        )
        .toList();
  }

  int get bookCount => books.length;

  void selectStatus(ShelfStatus status) {
    if (_selectedStatus == status) {
      return;
    }

    _selectedStatus = status;
    notifyListeners();
  }
}