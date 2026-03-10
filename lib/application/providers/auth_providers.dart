import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:todo_app_herody/infrastructure/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateProvider<User?>((ref) {
  return null;
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(null);

  Future<void> signUp(String email, String password) async {
    final user = await authService.signUp(email, password);
    state = user;
  }

  Future<void> login(String email, String password) async {
    final user = await authService.login(email, password);
    state = user;
  }

  Future<void> logout() async {
    await authService.logout();
    state = null;
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});