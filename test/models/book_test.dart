import 'package:flutter_test/flutter_test.dart';
import 'package:pages_and_pals/models/book.dart';

void main() {
  group('Book.fromJson', () {
    test('strips HTML tags and entities from the description', () {
      final book = Book.fromJson({
        'id': 'abc123',
        'volumeInfo': {
          'title': 'O Senhor dos Anéis',
          'authors': ['J.R.R. Tolkien'],
          'description': '<p><b>Primeira</b> parte.</p><p>Segunda &amp; última parte.</p>',
        },
      });

      expect(book.description, 'Primeira parte.\n\nSegunda & última parte.');
    });

    test('falls back to sensible defaults when fields are missing', () {
      final book = Book.fromJson({'id': 'xyz'});

      expect(book.title, 'Sem título');
      expect(book.authorsLabel, 'Autor desconhecido');
      expect(book.description, isNull);
    });
  });
}
