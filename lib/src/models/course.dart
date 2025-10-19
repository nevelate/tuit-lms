import 'package:json_annotation/json_annotation.dart';
import 'dart:core';

import '../enums.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  final int id;
  final String? subject;

  @JsonKey(name: 'subject_id')
  final int subjectId;

  @JsonKey(name: 'attendance')
  final int absenceCount;

  @JsonKey(fromJson: _getListFromString)
  final List<String> streams;

  @JsonKey(name: 'streams', fromJson: _getLessonTypesFromStreams)
  final List<LessonType> lessonTypes;

  @JsonKey(fromJson: _getListFromString)
  final List<String> teachers;

  @JsonKey(name: 'failed')
  final bool isFailed;

  Course(
    this.id,
    this.subject,
    this.subjectId,
    this.absenceCount,
    this.streams,
    this.lessonTypes,
    this.teachers,
    this.isFailed,
  );

  factory Absence.fromJson(Map<String, dynamic> json) =>
      _$AbsenceFromJson(json);

  static final _lectureRegex = RegExp(r'\d\d\d$');
  static final _laboratoryRegex = RegExp(r'-\w\d$');

  static List<String> _getListFromString(String data){
    return data.split('###');
  }

  static List<LessonType> _getLessonTypesFromStreams(String streams) {
    List<String> allStreams = streams.split('###');
    return allStreams.map((stream) {
      if (_lectureRegex.hasMatch(stream)) return LessonType.lecture;
      if (_laboratoryRegex.hasMatch(stream)) return LessonType.laboratory;
      return LessonType.practice;
    }).toList();
  }
}
