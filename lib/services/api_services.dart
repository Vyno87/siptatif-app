import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  // Ganti URL ini dengan alamat server backend Anda nantinya
  // Contoh: 'https://api.siptatif.com/v1' atau 'http://10.0.2.2:8000/api'
  static const String baseUrl = 'https://mock-api.siptatif.local/api';

  late Dio _dio;

  ApiServices() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Interceptor untuk menyisipkan token secara otomatis di setiap request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Tangani error global jika diperlukan (contoh: token expired -> paksa logout)
          return handler.next(e);
        },
      ),
    );
  }

  // Getter untuk mengakses instance Dio
  Dio get client => _dio;
}
