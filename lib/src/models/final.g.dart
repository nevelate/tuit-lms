// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Final _$FinalFromJson(Map<String, dynamic> json) => Final(
  json['subject'] as String?,
  (json['subject_id'] as num).toInt(),
  (json['f_grade'] as num?)?.toInt(),
  json['stream'] as String?,
  json['room'] as String?,
  DateTime.parse(json['date'] as String),
  json['from'] as String,
  json['to'] as String,
  (json['final_limit'] as num).toInt(),
  (json['final_info'] as List<dynamic>)
      .map((e) => TestPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FinalToJson(Final instance) => <String, dynamic>{
  'subject': instance.subject,
  'subject_id': instance.subjectId,
  'f_grade': instance.grade,
  'stream': instance.stream,
  'room': instance.room,
  'date': instance.examDate.toIso8601String(),
  'from': instance.startTime,
  'to': instance.endTime,
  'final_limit': instance.timeLimit,
  'final_info': instance.testPoints,
};
