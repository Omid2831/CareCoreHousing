import 'package:dio/dio.dart';

import '../models/property.dart';
import 'dio_client_api.dart';
import 'endpoints.dart';

class PropertyApi {
  PropertyApi({Dio? dio}) : _dio = dio ?? DioClientApi().dio;

  final Dio _dio;

  Future<List<Property>> getProperties({
    String? type,
    String? search,
    int perPage = 30,
  }) async {
    final Map<String, dynamic> queryParams = <String, dynamic>{
      'per_page': perPage,
    };

    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }

    final String trimmedSearch = (search ?? '').trim();
    if (trimmedSearch.isNotEmpty) {
      queryParams['search'] = trimmedSearch;
    }

    final Response<dynamic> response = await _dio.get(
      Endpoints.properties,
      queryParameters: queryParams,
    );

    final List<dynamic> rawList = _extractPropertyList(response.data);
    return rawList
        .map(_toStringDynamicMap)
        .whereType<Map<String, dynamic>>()
        .map(Property.fromJson)
        .toList();
  }

  Future<Property> getPropertyById(int id) async {
    final Response<dynamic> response = await _dio.get(
      Endpoints.propertyById(id),
    );

    final Map<String, dynamic>? mapped = _toStringDynamicMap(response.data);
    if (mapped == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid property response format',
      );
    }

    return Property.fromJson(mapped);
  }

  List<dynamic> _extractPropertyList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final dynamic paginatedData = data['data'];
      if (paginatedData is List) {
        return paginatedData;
      }
    }

    return <dynamic>[];
  }

  Map<String, dynamic>? _toStringDynamicMap(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item;
    }
    if (item is Map) {
      return item.map(
        (dynamic key, dynamic value) => MapEntry(key.toString(), value),
      );
    }
    return null;
  }
}
