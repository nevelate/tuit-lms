import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:tuit_lms/tuit_lms.dart';

class TuitLmsClient {
  static const String _myCoursesUrl =
      'https://lms.tuit.uz/student/my-courses/data?semester_id=';
  static const String _finalsUrl =
      'https://lms.tuit.uz/student/finals/data?semester_id=';
  static const String _scheduleUrl =
      'https://lms.tuit.uz/student/schedule/load/';
  static const String _sbsencesUrl =
      'https://lms.tuit.uz/student/attendance/data?semester_id=';

  static const String _changeLanguageRequestFormat = '_token={0}&language={1}';
  static const String _changePasswordRequestFormat =
      '_token={0}&old_password={1}&password={2}&password_confirmation={3}';

  static const _uploadRequestHeaders = {
    'Accept': '*/*',
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
    'X-Requested-With': 'XMLHttpRequest',
  };

  final Dio _dio;
  final CacheOptions _cacheOptions;

  TuitLmsClient(this._dio, this._cacheOptions);

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

  Future<bool> isAuthorized() async {
    var cookieJar =
        (_dio.interceptors.firstWhere((i) => i is CookieManager)
                as CookieManager)
            .cookieJar;

    var cookies = await cookieJar.loadForRequest(
      Uri.parse("https://lms.tuit.uz"),
    );

    return cookies.isNotEmpty;
  }

  void logOut() {
    deleteCookies();
    _cacheOptions.store?.clean();
  }

  void deleteCookies() {
    (_dio.interceptors.whereType<CookieManager>().firstOrNull)?.cookieJar
        .deleteAll();
  }

  Future<Information> getInformation({bool refresh = false}) async {
    final document = refresh
        ? await _dio.getHtml(
            '/student/info',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/student/info');

    final information = Information(
      fullName: document
          .querySelectorAll('div.card.relative p.m-b-xs')[0]
          .text
          .removeUpToColonAndTrim(),
      birthDate: DateFormat('dd-MM-yyyy').parse(
        document
            .querySelectorAll('div.card.relative p.m-b-xs')[1]
            .text
            .removeUpToColonAndTrim(),
      ),
      gender: document
          .querySelectorAll('div.card.relative p.m-b-xs')[2]
          .text
          .removeUpToColonAndTrim(),
      studentNumber: document
          .querySelectorAll('div.card.relative p.m-b-xs')[3]
          .text
          .removeUpToColonAndTrim(),

      address: document
          .querySelectorAll('div.card.relative p.m-b-xs')[4]
          .text
          .removeUpToColonAndTrim(),
      temporaryAddress: document
          .querySelectorAll('div.card.relative p')[6]
          .text
          .removeUpToColonAndTrim(),

      base64Photo: document
          .querySelector('div.card.relative p.text-center.m-b-md img')
          ?.attributes['src'],

      specialization: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[0]
          .text
          .removeUpToColonAndTrim(),
      studyLanguage: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[1]
          .text
          .removeUpToColonAndTrim(),
      degree: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[2]
          .text
          .removeUpToColonAndTrim(),
      typeOfStudy: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[3]
          .text
          .removeUpToColonAndTrim(),
      year: int.parse(
        document
            .querySelectorAll('div.card:not(.relative) p.m-b-xs')[4]
            .text
            .removeUpToColonAndTrim(),
      ),
      group: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[5]
          .text
          .removeUpToColonAndTrim(),
      tutor: document
          .querySelectorAll('div.card:not(.relative) p.m-b-xs')[6]
          .text
          .removeUpToColonAndTrim(),
      stipend: document
          .querySelectorAll('div.card:not(.relative) p')[7]
          .text
          .removeUpToColonAndTrim(),
    );

    return information;
  }

  Future<List<News>> getNews({int page = 1, bool refresh = false}) async {
    var newsUrl = page == 1 ? '/dashboard/news' : '/dashboard/news?page=$page';

    final document = refresh
        ? await _dio.getHtml(
            newsUrl,
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml(newsUrl);

    var news = List<News>.empty(growable: true);
    var tasks = List<Future<Document>>.empty(growable: true);

    for (var column in document.querySelectorAll(
      'div.row div.col-md-4 div.card.p',
    )) {
      var url = column.querySelector('div.d-flex a')?.attributes['href'];
      tasks.add(_dio.getHtml(url!));
    }

    var documents = await Future.wait(tasks);

    for (var newsPage in documents) {
      news.add(
        News(
          title: newsPage.querySelector('h4.panel__title')?.text,
          description: newsPage
              .querySelector('div.panel-body blockquote div')
              ?.text,
          newsDate: DateFormat('dd-MM-yyyy').parse(
            newsPage
                .querySelector('div.panel-body blockquote footer cite')!
                .text,
          ),
        ),
      );
    }

    return news;
  }

  Future<List<Discipline>> getDIsciplines({bool refresh = false}) async {
    final document = refresh
        ? await _dio.getHtml(
            '/student/study-plan',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/student/study-plan');

    final disciplines = List<Discipline>.empty(growable: true);

    for (var row in document.querySelectorAll('div.page-inner > div.row')) {
      for (var card in row.querySelectorAll('div.col-lg-6 > div.card')) {
        for (var tr in card.querySelectorAll('table > tbody > tr')) {
          disciplines.add(
            Discipline(
              title: tr.querySelector('td')?.text,
              semester: card.querySelector('div.card-body > p')?.text,
              creditCount: int.parse(tr.querySelector('td.text-center')!.text),
              grade:
                  tr.querySelector('td.text-right')!.text.isNullOrWhiteSpace()
                  ? null
                  : int.parse(tr.querySelector('td.text-right')!.text),
            ),
          );
        }
      }
    }

    return disciplines;
  }

  Future<List<Lesson>> getLessons(
    int courseId,
    LessonType lessonType, {
    bool refresh = false,
  }) async {
    final dateRegex = RegExp(r"\(.*\)");

    final document = refresh
        ? await _dio.getHtml(
            '/student/calendar/$courseId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/student/calendar/$courseId');

    final lessons = List<Lesson>.empty(growable: true);

    String lessonTypeQuery;

    switch (lessonType) {
      case LessonType.lecture:
        lessonTypeQuery = 'div#lecture tbody > tr';
      case LessonType.practice:
        lessonTypeQuery = 'div#practice tbody > tr';
      case LessonType.laboratory:
        lessonTypeQuery = 'div#lab tbody > tr';
    }

    for (var tr in document.querySelectorAll(lessonTypeQuery)) {
      var lesson = Lesson()
        ..themeTitle = tr.querySelector('td p')?.text
        ..themeNumber = int.parse(tr.querySelectorAll('td')[0].text)
        ..lessonDate = DateFormat('dd-MM-yyyy').parse(
          tr.querySelectorAll("td")[2].text.replaceAll(dateRegex, '').trim(),
        )
        ..lessonType = lessonType;

      var attachments = List<Attachment>.empty(growable: true);

      for (var a in tr.querySelectorAll('td a')) {
        attachments.add(
          Attachment()
            ..name = a.text.trim()
            ..url = a.attributes['href'],
        );
      }

      lesson.attachments = attachments;

      lessons.add(lesson);
    }

    return lessons;
  }

  Future<AssignmentsPage?> getAssignmentsPage(
    int courseId, {
    bool refresh = false,
  }) async {
    final document = refresh
        ? await _dio.getHtml(
            '/student/my-courses/show/$courseId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/student/my-courses/show/$courseId');

    if (document.querySelector('div.page-inner > div.panel') == null) {
      return null;
    }

    var assignmentsPage = AssignmentsPage()
      ..achievedPoints = double.parse(
        document.querySelectorAll('tbody tr td h4')[0].text,
      )
      ..maxPoints = double.parse(
        document.querySelectorAll('tbody tr td h4')[1].text,
      )
      ..rating = double.parse(
        document.querySelectorAll('tbody tr td h4')[2].text.replaceAll("%", ""),
      )
      ..grade = int.parse(document.querySelectorAll('tbody tr td h4')[3].text);

    var assignments = List<Assignment>.empty(growable: true);

    for (var tr in document.querySelectorAll('table#simple-table1 tbody tr')) {
      var assignment = Assignment()
        ..taskType = tr.querySelectorAll('td')[0].text
        ..teacher = tr.querySelectorAll('td')[1].text
        ..taskName = tr.querySelector('td div p')?.text
        ..deadline = DateFormat(
          'dd-MM-yyyy H:m:s',
        ).parse(tr.querySelectorAll('td')[3].text)
        ..currentGrade = double.tryParse(
          tr.querySelectorAll('td.text-center div button')[0].text,
        )
        ..maxGrade = double.parse(
          tr.querySelectorAll('td.text-center div button')[1].text,
        );

      if (!tr.querySelector('td div a')!.text.isNullOrWhiteSpace()) {
        assignment.taskFile = Attachment()
          ..name = tr.querySelector('td div a')?.text.trim()
          ..url = tr.querySelector('td div a')?.attributes['href'];
      }

      if (tr.querySelector('td > a') != null) {
        if (tr.querySelector('td > a')?.attributes['href'] == '#') {
          assignment.uploadId = int.parse(
            tr.querySelector('td > a')!.attributes['data-id']!,
          );
        } else {
          assignment.uploadId = tr
              .querySelector('td div button.js-btn-upload')
              ?.attributes['data-id']
              ?.parseOrReturnNull()
              ?.toInt();

          assignment.uploadedFile = Attachment()
            ..name = tr.querySelector('td > a')!.text.trim()
            ..url = tr.querySelector('td > a')!.attributes['href'];
        }
      }

      assignment.isFailed = tr.querySelector('td > span') != null;

      assignments.add(assignment);
    }
    assignmentsPage.assignments = assignments;

    return assignmentsPage;
  }

  Future<List<Semester>> getSemesters({bool refresh = false}) async {
    final document = refresh
        ? await _dio.getHtml(
            '/student/my-courses',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/student/my-courses');

    var semesters = List<Semester>.empty(growable: true);

    for (var option in document.querySelectorAll('select.js-semester option')) {
      semesters.add(
        Semester(
          int.parse(option.attributes['value']!),
          option.text.trim().replaceAll(RegExp(r'\s\s+'), ' '),
        ),
      );
    }

    return semesters;
  }

  Future<List<Course>> getCourses(
    int semesterId, {
    bool refresh = false,
  }) async {
    final response = refresh
        ? await _dio.get('/student/my-courses/data?semester_id=$semesterId')
        : await _dio.get(
            '/student/my-courses/data?semester_id=$semesterId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          );

    var list = List<Course>.empty(growable: true);

    for (var item in response.data['data']) {
      list.add(Course.fromJson(item));
    }

    return list;
  }

  Future<List<Absence>> getAbsences(
    int semesterId, {
    bool refresh = false,
  }) async {
    final response = refresh
        ? await _dio.get('/student/attendance/data?semester_id=$semesterId')
        : await _dio.get(
            '/student/attendance/data?semester_id=$semesterId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          );

    var list = List<Absence>.empty(growable: true);

    for (var item in response.data['data']) {
      list.add(Absence.fromJson(item));
    }

    return list;
  }

  Future<List<TableLesson>> getSchedule(
    int semesterId, {
    bool refresh = false,
  }) async {
    final response = refresh
        ? await _dio.get('/student/schedule/load/$semesterId')
        : await _dio.get(
            '/student/schedule/load/$semesterId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          );

    var list = List<TableLesson>.empty(growable: true);

    for (var item in response.data['json']) {
      list.add(TableLesson.fromJson(item));
    }

    return list;
  }

  Future<List<Final>> getFinals(int semesterId, {bool refresh = false}) async {
    final response = refresh
        ? await _dio.get('/student/finals/data?semester_id=$semesterId')
        : await _dio.get(
            '/student/finals/data?semester_id=$semesterId',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          );

    var list = List<Final>.empty(growable: true);

    for (var item in response.data['data']) {
      list.add(Final.fromJson(item));
    }

    return list;
  }

  // Upload

  Future<String> getAccountFullName({bool refresh = false}) async {
    final document = refresh
        ? await _dio.getHtml(
            '/dashboard/news',
            options: _cacheOptions
                .copyWith(policy: CachePolicy.refresh)
                .toOptions(),
          )
        : await _dio.getHtml('/dashboard/news');

    return document.querySelector('ul.dropdown-menu > li > div')!.text.trim();
  }

  Future<TableLessonType> getLessonSide(
    int semesterId, {
    TableLessonType firstWeekTableLessonSide = TableLessonType.left,
    bool refresh = false,
  }) async {
    final courses = await getCourses(semesterId, refresh: refresh);
    var index = 0;
    var lessons = List<Lesson>.empty(growable: true);

    do {
      lessons = await getLessons(
        courses[index].id,
        LessonType.lecture,
        refresh: refresh,
      );
    } while (++index < courses.length && lessons.isEmpty);

    DateTime firstLessonDate;

    try {
      firstLessonDate = lessons
          .map((l) => l.lessonDate)
          .reduce((a, b) => a.isBefore(b) ? a : b);
    } catch (e) {
      return firstWeekTableLessonSide;
    }

    int lessonWeek = firstLessonDate.weekNumber();
    int todayWeek = DateTime.now().weekNumber();

    bool sameParity = (lessonWeek % 2) == (todayWeek % 2);

    if (sameParity) {
      return firstWeekTableLessonSide;
    } else {
      return firstWeekTableLessonSide == TableLessonType.left
          ? TableLessonType.right
          : TableLessonType.left;
    }
  }

  Future<bool> changeLanguage(String language) async {
    final document = await _dio.getHtml('/profile/language');
    var token = document
        .querySelector('input[name=_token]')
        ?.attributes['value'];

    final changeLanguageRequest = '_token=$token&language=$language';

    var response = await _dio.request(
      '/profile/language',
      data: changeLanguageRequest,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: 'POST',
      ),
    );

    return response.statusMessage == 'Found';
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final document = await _dio.getHtml('/profile/password');
    var token = document
        .querySelector('input[name=_token]')
        ?.attributes['value'];

    final changeLanguageRequest =
        '_token=$token&old_password=$oldPassword&password=$newPassword&password_confirmation=$newPassword';

    var response = await _dio.request(
      '/profile/password',
      data: changeLanguageRequest,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: 'POST',
      ),
    );

    return response.statusMessage == 'Found';
  }
}
