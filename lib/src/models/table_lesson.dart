import 'package:tuit_lms/src/enums.dart';

class TableLesson {
  final DateTime startTime;
  final String? subject;
  final String? stream;
  final String? room;
  final int lessonDay; // store as weekday number (1=Mon ... 7=Sun)
  final TableLessonType tableLessonType;
  final LessonType lessonType;

  TableLesson(
    this.startTime,
    this.subject,
    this.stream,
    this.room,
    this.lessonDay,
    this.tableLessonType,
    this.lessonType,
  );

  static final _isLectureRegex = RegExp(r'\d\d\d$');
  static final _isLaboratoryRegex = RegExp(r'-\w\d$');
  static final _subjectRegex = RegExp(r'\)[^-]+\-');
  static final _streamRegex = RegExp(r'\D\D\D\d+-*\w*$');
  static final _roomRegex = RegExp(r'\D-\d+');

  factory TableLesson.fromJson(Map<String, dynamic> json) {
    String title = (json['title'] as String? ?? '')
        .replaceAll('/', '')
        .replaceAll('\n', '');
    int typeValue = json['type'] as int? ?? 1;
    DateTime start = DateTime.parse(json['start'] as String);

    LessonType lessonType;
    if (_isLectureRegex.hasMatch(title)) {
      lessonType = LessonType.lecture;
    } else if (_isLaboratoryRegex.hasMatch(title)) {
      lessonType = LessonType.laboratory;
    } else {
      lessonType = LessonType.practice;
    }

    String? subject = _subjectRegex.firstMatch(title)?.group(0)
        ?.replaceAll(')', '')
        .replaceAll('-', '')
        .trim();

    String? stream = _streamRegex.firstMatch(title)?.group(0);
    String? room = _roomRegex.firstMatch(title)?.group(0);

    return TableLesson(
      start,
      subject?.isNotEmpty == true ? subject : null,
      stream?.isNotEmpty == true ? stream : null,
      room?.isNotEmpty == true ? room : null,
      start.weekday,
      TableLessonType.fromValue(typeValue),
      lessonType,
    );
  }
}