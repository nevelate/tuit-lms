import 'package:json_annotation/json_annotation.dart';

part 'code_gen/absence.g.dart';

@JsonSerializable()
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

  /// Factory for JSON deserialization
  factory Absence.fromJson(Map<String, dynamic> json) =>
      _$AbsenceFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$AbsenceToJson(this);
}
