import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class AuthManager {
  final Dio _dio;

  AuthManager(this._dio);

  static const _loginRequestHeaders = {
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
    'Origin': 'https://lms.tuit.uz',
    'sec-ch-ua':
        '\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Google Chrome\";v=\"126\"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '\"Windows\"',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-User': '?1',
    'Upgrade-Insecure-Requests': '1',
    'Host': 'lms.tuit.uz',
  };

  Future<bool> loginAsync({
    required String login,
    required String password,
    required String token,
    required String grecaptcha,
  }) async {
    final String loginRequest =
        '_token=$token&login=$login&password=$password&g-recaptcha-response=$grecaptcha';

    var response = await _dio.request(
      '/auth/login',
      data: loginRequest,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: 'POST',
      ),
    );

    final redirectUrl = response.headers.value("location");
    final redirectedResponse = await _dio.get(redirectUrl!);

    return redirectedResponse.data.toString().contains('Dashboard');
  }

  Future<bool> isAuthorized() async{
    var cookieJar = (_dio.interceptors.firstWhere((i) => i is CookieManager) as CookieManager).cookieJar;

    var cookies = await cookieJar.loadForRequest(Uri.parse("https://lms.tuit.uz"));

    return cookies.isNotEmpty;
  }
}
