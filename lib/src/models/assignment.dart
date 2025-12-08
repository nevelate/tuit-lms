import 'package:tuit_lms/src/enums.dart';

import 'attachment.dart';

class Assignment{
  String? taskType;
  String? teacher;

  String? taskName;
  Attachment? taskFile;

  DateTime? deadline;

  double? currentGrade;
  late double maxGrade;

  int? uploadId;
  Attachment? uploadedFile;

  late bool isFailed;
}