import 'package:dio/dio.dart';
import 'endpoints.dart';

// ignore: slash_for_doc_comments
/**
 * Create a Dio client instance with the base url of the API server.
 * This client will be used to make API requests to the server.
 * Make sure to replace the base url with the actual url of your API server.
 */

class DioClientApi {
  static final DioClientApi _instance = DioClientApi._internal();

  factory DioClientApi() {
    return _instance;
  }

  DioClientApi._internal();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,  // Just the base URL, endpoints will be appended in the API calls
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}