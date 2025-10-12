// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  (json['id'] as num).toInt(),
  json['subject'] as String?,
  (json['subject_id'] as num).toInt(),
  (json['attendance'] as num).toInt(),
  (json['streams'] as List<dynamic>).map((e) => e as String).toList(),
  (json['lessonTypes'] as List<dynamic>)
      .map((e) => $enumDecode(_$LessonTypeEnumMap, e))
      .toList(),
  (json['teachers'] as List<dynamic>).map((e) => e as String).toList(),
  json['failed'] as bool,
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'subject': instance.subject,
  'subject_id': instance.subjectId,
  'attendance': instance.absenceCount,
  'streams': instance.streams,
  'lessonTypes': instance.lessonTypes
      .map((e) => _$LessonTypeEnumMap[e]!)
      .toList(),
  'teachers': instance.teachers,
  'failed': instance.isFailed,
};

const _$LessonTypeEnumMap = {
  LessonType.lecture: 'lecture',
  LessonType.practice: 'practice',
  LessonType.laboratory: 'laboratory',
};
