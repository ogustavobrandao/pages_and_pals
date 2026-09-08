import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pages_and_pals/services/auth_service.dart';

void main() {
  group('authErrorMessage', () {
    test('maps email-already-in-use to a friendly message', () {
      final error = FirebaseAuthException(code: 'email-already-in-use');
      expect(authErrorMessage(error), 'Esse e-mail já está cadastrado.');
    });

    test('maps wrong-password and invalid-credential to the same message', () {
      expect(
        authErrorMessage(FirebaseAuthException(code: 'wrong-password')),
        'E-mail ou senha incorretos.',
      );
      expect(
        authErrorMessage(FirebaseAuthException(code: 'invalid-credential')),
        'E-mail ou senha incorretos.',
      );
      expect(
        authErrorMessage(FirebaseAuthException(code: 'user-not-found')),
        'E-mail ou senha incorretos.',
      );
    });

    test('maps network-request-failed to a connectivity message', () {
      final error = FirebaseAuthException(code: 'network-request-failed');
      expect(authErrorMessage(error), 'Falha de conexão. Verifique sua internet.');
    });

    test('falls back to a generic message including the code for unmapped FirebaseAuthException codes', () {
      final error = FirebaseAuthException(code: 'some-unmapped-code');
      expect(authErrorMessage(error), 'Ocorreu um erro (some-unmapped-code). Tente novamente.');
    });

    test('falls back to a generic message for non-Firebase errors', () {
      expect(authErrorMessage(Exception('boom')), 'Ocorreu um erro inesperado. Tente novamente.');
    });
  });
}
