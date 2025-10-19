import '../enums.dart';
import 'attachment.dart';

class Lesson {
  String? themeTitle;
  late int themeNumber;
  late DateTime lessonDate;
  late LessonType lessonType;

  late List<Attachment> attachments;
}