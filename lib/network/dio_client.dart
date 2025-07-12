import 'package:dio/dio.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routing/app_router.dart';
import '../main.dart';

class ExponentialBackoffInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;
  final double backoffMultiplier;
  final double jitterFactor;

  ExponentialBackoffInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.backoffMultiplier = 2.0,
    this.jitterFactor = 0.1,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final shouldRetry = _shouldRetry(statusCode);
    final retryCount = _getRetryCount(err.requestOptions);

    if (shouldRetry && retryCount < maxRetries) {
      final delay = _calculateDelay(retryCount);
      print('Retrying request after ${delay.inMilliseconds}ms (attempt ${retryCount + 1}/$maxRetries)');
      
      await Future.delayed(delay);
      
      // Update retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      
      // Retry the request
      try {
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(int? statusCode) {
    if (statusCode == null) return false;
    return [500, 502, 503, 504, 408, 429].contains(statusCode);
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] ?? 0;
  }

  Duration _calculateDelay(int retryCount) {
    final exponentialDelay = baseDelay.inMilliseconds * pow(backoffMultiplier, retryCount);
    final jitter = exponentialDelay * jitterFactor * (Random().nextDouble() * 2 - 1);
    final finalDelay = exponentialDelay + jitter;
    
    return Duration(milliseconds: finalDelay.round());
  }
}

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

    // Add exponential backoff interceptor first
    dio.interceptors.add(ExponentialBackoffInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Initialize retry count
          options.extra['retryCount'] = 0;
          
          // Добавляем Bearer Token
          options.headers['Authorization'] = 'Bearer 1lrlKpjKgdAQ7FZsIDbhopm5';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final context = rootNavigatorKey.currentContext;
          if (context != null) {
            final provider = Provider.of<ConnectivityProvider>(context, listen: false);
            provider.setServerOffline(false);
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // обработка ошибок (опционально)
          print('Dio error:  [31m${e.response?.statusCode} [0m ${e.message}');
          final statusCode = e.response?.statusCode;
          if ([500, 502, 503, 504].contains(statusCode)) {
            final context = rootNavigatorKey.currentContext;
            if (context != null) {
              final provider = Provider.of<ConnectivityProvider>(context, listen: false);
              provider.setServerOffline(true);
            }
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
