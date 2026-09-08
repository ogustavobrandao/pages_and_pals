import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class GoogleBooksService {
  GoogleBooksService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  static const _timeout = Duration(seconds: 12);

  /// Passe a chave em tempo de build: `flutter run --dart-define=GOOGLE_BOOKS_API_KEY=...`.
  /// Sem a chave, a API funciona com uma cota compartilhada bem baixa (erro 429 é comum).
  static const _apiKey = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  Uri _withKey(Uri uri) {
    if (_apiKey.isEmpty) return uri;
    return uri.replace(queryParameters: {...uri.queryParameters, 'key': _apiKey});
  }

  Future<List<Book>> searchBooks(String query) async {
    final uri = _withKey(Uri.parse(_baseUrl).replace(queryParameters: {'q': query, 'maxResults': '20'}));
    final json = await _get(uri);
    final items = (json['items'] as List<dynamic>?) ?? const [];
    return items.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Book> getBookById(String id) async {
    final uri = _withKey(Uri.parse('$_baseUrl/$id'));
    final json = await _get(uri);
    return Book.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } on SocketException {
      throw Exception('Falha de conexão. Verifique sua internet.');
    } on HttpException {
      throw Exception('Falha de conexão. Verifique sua internet.');
    } catch (_) {
      throw Exception('A busca demorou demais para responder. Tente novamente.');
    }

    if (response.statusCode == 429) {
      throw Exception('Muitas buscas em pouco tempo. Espere um instante e tente de novo.');
    }
    if (response.statusCode != 200) {
      throw Exception('Não foi possível buscar os livros agora (erro ${response.statusCode}).');
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Resposta inesperada do servidor. Tente novamente.');
    }
  }
}
