import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:inspector_flutter_demo/post.dart';
import 'package:requests_inspector/requests_inspector.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/', // Fake API endpoint
    ));

    // Create and configure interceptors
    final requestsInspectorInterceptor = RequestsInspectorInterceptor();
    final logInterceptor = LogInterceptor(
      responseBody: true,
      requestBody: true,
      error: true,
      logPrint: (object) => log(object.toString()),
    );

    // Add interceptors to Dio
    _dio.interceptors.add(requestsInspectorInterceptor);
    _dio.interceptors.add(logInterceptor);
  }

  Future<Post> getSampleData() async {
    try {
      final response =  await _dio.get('/posts/1'); // Sample GET request
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      log('Error: ${e.message}');
      rethrow;
    }
  }
}
