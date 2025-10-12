import 'package:tuit_lms/src/enums.dart';
import 'package:tuit_lms/src/models/attachment.dart';

class Lesson {
  String? themeTitle;
  late int themeNumber;
  late DateTime lessonDate;
  late LessonType lessonType;

  late List<Attachment> attachments;
}