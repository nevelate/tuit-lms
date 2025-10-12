// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../absence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Absence _$AbsenceFromJson(Map<String, dynamic> json) => Absence(
  json['subject'] as String?,
  (json['subject_id'] as num).toInt(),
  DateTime.parse(json['date'] as String),
  json['type'] as String?,
  json['calendar'] as String?,
  (json['theme_number'] as num).toInt(),
);

Map<String, dynamic> _$AbsenceToJson(Absence instance) => <String, dynamic>{
  'subject': instance.subject,
  'subject_id': instance.subjectId,
  'date': instance.date.toIso8601String(),
  'type': instance.lessonType,
  'calendar': instance.themeTitle,
  'theme_number': instance.themeNumber,
};
