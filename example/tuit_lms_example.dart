import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:tuit_lms/tuit_lms.dart';

import 'secrets.dart';

Future<void> main() async {
  final cookieJar = PersistCookieJar();

  final baseOptions = BaseOptions(
    baseUrl: 'https://lms.tuit.uz',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 5),
    followRedirects: false,
    validateStatus: (status) => status != null && status < 400,
  );

  final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorCodes: const [500],
    hitCacheOnNetworkFailure: true,
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  final dio = Dio(baseOptions);

  dio.httpClientAdapter = NativeAdapter();
  dio.interceptors.add(CookieManager(cookieJar));
  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  var tuitLmsClient = TuitLmsClient(dio, cacheOptions);

  if (!(await tuitLmsClient.isAuthorized())) {
    print(
      await tuitLmsClient.loginAsync(
        login: Secrets.login,
        password: Secrets.password,
        token: Secrets.token,
        grecaptcha: Secrets.grecaptcha,
      ),
    );
  }

  var news = await tuitLmsClient.getNews();

  print('yay!');
}
