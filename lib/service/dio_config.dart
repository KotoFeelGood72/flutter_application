import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late Dio _dio;

  factory DioSingleton() {
    return _instance;
  }

  DioSingleton._internal() {
    _dio = Dio();
    final baseUrl = bool.fromEnvironment('dart.vm.product')
        ? dotenv.env['BASE_URL_PROD']!
        : dotenv.env['BASE_URL_DEV']!;
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? firebaseToken = await _getFirebaseToken();
        String? deviceToken = await _getDeviceToken();
        if (firebaseToken != null) {
          options.headers['Authorization'] = 'Bearer $firebaseToken';
        }
        if (deviceToken != null) {
          options.headers['device-token'] = deviceToken;
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

  Future<String?> _getDeviceToken() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      print("Ошибка получения токена устройства: $e");
    }
    return null;
  }

  Dio get dio => _dio;
}
