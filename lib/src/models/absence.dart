import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class Absence {
  final String? subject;

  @JsonKey(name: 'subject_id')
  final int subjectId;

  @JsonKey(fromJson: DateTime.parse)
  final DateTime date;

  @JsonKey(name: 'type')
  final String? lessonType;

  @JsonKey(name: 'calendar')
  final String? themeTitle;

  @JsonKey(name: 'theme_number')
  final int themeNumber;

  Absence(
    this.subject,
    this.subjectId,
    this.date,
    this.lessonType,
    this.themeTitle,
    this.themeNumber,
  );

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    (json['subject'] as String?)?.replaceAll("&#039;", "'"),
    (json['subject_id'] as num).toInt(),
    DateFormat('dd-MM-yyyy').parse(json['date'] as String),
    json['type'] as String?,
    json['calendar'] as String?,
    (json['theme_number'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'subject': subject,
    'subject_id': subjectId,
    'date': date.toIso8601String(),
    'type': lessonType,
    'calendar': themeTitle,
    'theme_number': themeNumber,
  };
}
