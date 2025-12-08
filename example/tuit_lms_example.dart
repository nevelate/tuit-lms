import 'package:tuit_lms/tuit_lms.dart';

import 'secrets.dart';

Future<void> main() async {
  var dio = TuitLmsDio.create();
  var authManager = AuthManager(dio);
  var tuitLmsClient = TuitLmsClient(dio, authManager);

  if(!(await authManager.isAuthorized())){
    print(
    await authManager.loginAsync(
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
