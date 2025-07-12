import 'package:dio/dio.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl:
            'https://shmr-finance.ru/api/v1/', // 👈 укажи свой реальный baseUrl
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Добавляем Bearer Token
          options.headers['Authorization'] = 'Bearer 1lrlKpjKgdAQ7FZsIDbhopm5';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // обработка ошибок (опционально)
          print('Dio error: ${e.response?.statusCode} ${e.message}');
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
