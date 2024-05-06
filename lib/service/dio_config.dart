import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio _dio;

  factory DioSingleton() {
    return _instance;
  }

  DioSingleton._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://217.25.95.113:8000/api/v1/';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _getFirebaseToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<String?> _getFirebaseToken() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String? token = await user.getIdToken();
        return token;
      }
    } catch (e) {
      print("Ошибка получения токена Firebase: $e");
    }
    return null;
  }

  Dio get dio => _dio;
}
