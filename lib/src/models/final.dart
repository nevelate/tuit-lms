import 'package:json_annotation/json_annotation.dart';

import 'test_point.dart';

part 'final.g.dart';

@JsonSerializable()
class Final {
  final String? subject;

  @JsonKey(name: 'subject_id')
  final int subjectId;

  @JsonKey(name: 'f_grade')
  final int? grade;

  final String? stream;
  final String? room;

  @JsonKey(name: 'date', fromJson: DateTime.parse)
  final DateTime examDate;

  @JsonKey(name: 'from')
  final String startTime;

  @JsonKey(name: 'to')
  final String endTime;

  @JsonKey(name: 'final_limit')
  final int timeLimit;

  @JsonKey(name: 'final_info')
  final List<TestPoint> testPoints;

  Final(
    this.subject,
    this.subjectId,
    this.grade,
    this.stream,
    this.room,
    this.examDate,
    this.startTime,
    this.endTime,
    this.timeLimit,
    this.testPoints,
  );

  factory Final.fromJson(Map<String, dynamic> json) => _$FinalFromJson(json);
}
