import 'package:json_annotation/json_annotation.dart';
import 'dart:core';

import 'package:tuit_lms/src/enums.dart';

part 'code_gen/course.g.dart';

@JsonSerializable()
class Course {
  final int id;
  final String? subject;

  @JsonKey(name: 'subject_id')
  final int subjectId;

  @JsonKey(name: 'attendance')
  final int absenceCount;

  final List<String> streams;

  final List<LessonType> lessonTypes;

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

  factory Course.fromJson(Map<String, dynamic> json) {
    final streamsString = json['streams'] as String? ?? '';
    final streams = streamsString.isNotEmpty
        ? streamsString.split('###')
        : <String>[];

    final lessonTypes = _getLessonTypesFromStreams(streams);

    final teachersString = json['teachers'] as String? ?? '';
    final teachers = teachersString.isNotEmpty
        ? teachersString.split('###')
        : <String>[];

    return Course(
      json['id'] as int,
      json['subject'] as String?,
      json['subject_id'] as int,
      json['attendance'] as int,
      streams,
      lessonTypes,
      teachers,
      json['failed'] as bool,
    );
  }

  static final _lectureRegex = RegExp(r'\d\d\d$');
  static final _laboratoryRegex = RegExp(r'-\w\d$');

  static List<LessonType> _getLessonTypesFromStreams(List<String> streams) {
    return streams.map((stream) {
      if (_lectureRegex.hasMatch(stream)) return LessonType.lecture;
      if (_laboratoryRegex.hasMatch(stream)) return LessonType.laboratory;
      return LessonType.practice;
    }).toList();
  }
}
