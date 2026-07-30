import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tüm backend isteklerinin geçtiği merkezi HTTP istemcisi.
/// - JWT access token'ı otomatik header'a ekler.
/// - 401 alındığında refresh token ile otomatik yenileme yapar (basitleştirilmiş).
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final clonedRequest = await _retry(error.requestOptions);
              return handler.resolve(clonedRequest);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  // NOT: Gerçek backend adresinle değiştir (Railway/Render vb. deploy sonrası).
  static const String baseUrl = 'https://YOUR_BACKEND_URL/api';

  Dio get client => _dio;

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;
      final response = await Dio(BaseOptions(baseUrl: baseUrl)).post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      await _storage.write(key: 'access_token', value: response.data['access_token']);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _storage.read(key: 'access_token');
    final options = Options(method: requestOptions.method, headers: {'Authorization': 'Bearer $token'});
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
