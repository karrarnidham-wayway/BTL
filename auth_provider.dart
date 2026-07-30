import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../shared/models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated({String? error}) : this(status: AuthStatus.unauthenticated, errorMessage: error);
  const AuthState.authenticated(UserModel user) : this(status: AuthStatus.authenticated, user: user);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unknown()) {
    _tryAutoLogin();
  }

  final _storage = const FlutterSecureStorage();
  final _dio = ApiClient.instance.client;

  Future<void> _tryAutoLogin() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final response = await _dio.get('/auth/me');
      final user = UserModel.fromJson(response.data);
      state = AuthState.authenticated(user);
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      await _storage.write(key: 'access_token', value: response.data['access_token']);
      await _storage.write(key: 'refresh_token', value: response.data['refresh_token']);
      final user = UserModel.fromJson(response.data['user']);
      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Giriş başarısız. Bilgilerinizi kontrol edin.';
      state = AuthState.unauthenticated(error: message.toString());
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState.unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
