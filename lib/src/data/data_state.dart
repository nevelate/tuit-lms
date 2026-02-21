import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

enum DataSource { network, cache }

class DataState<T> {
  final T data;
  final bool isFromCache;

  const DataState({required this.data, required this.isFromCache});

  static Future<DataState<T>> mapResponse<T>(
    Response response,
    CacheStore? store,
    T data,
  ) async {
    if (store == null) {
      return DataState(data: data, isFromCache: false);
    }

    final key = response.extra[extraCacheKey];
    final cache = await store.get(key);

    bool isCached =
        cache != null &&
        DateTime.now().difference(cache.responseDate).inMinutes > 1;
    return DataState(data: data, isFromCache: isCached);
  }
}
