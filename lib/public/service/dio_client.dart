import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://10.0.2.2:3000/api"),
  );

  static final _storage = const FlutterSecureStorage();

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Runs before every request — attaches token
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // Runs when response comes back successfully
        onResponse: (response, handler) {
          return handler.next(response);
        },

        // Runs when an error occurs
        onError: (error, handler) async {
          // If token expired (401) — try refresh
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refreshtoken');

            if (refreshToken != null) {
              try {
                // Call refresh endpoint
                final response = await Dio().post(
                  "http://10.0.2.2:3000/api/refresh",
                  data: {'refreshtoken': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newToken = response.data['token'];

                  // Save new token
                  await _storage.write(key: 'token', value: newToken);

                  // Retry the original failed request with new token
                  error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

                  final retryResponse = await _dio.fetch(error.requestOptions);
                  return handler.resolve(retryResponse);
                }
              } catch (e) {
                // Refresh failed — force user to login again
                await _storage.deleteAll();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
    return _dio;
  }
}