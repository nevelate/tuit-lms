import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuit_lms/tuit_lms.dart';

import 'test_point.dart';

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

  factory Final.fromJson(Map<String, dynamic> json) => Final(
    (json['subject'] as String?)?.replaceAll("&#039;", "'"),
    (json['subject_id'] as num).toInt(),
    int.tryParse(json['f_grade'].toString()),
    json['stream'] as String?,
    json['room'] as String?,
    DateFormat('dd-MM-yyyy').parse(json['date'] as String),
    json['from'] as String,
    json['to'] as String,
    (json['final_limit'] as num).toInt(),
    (jsonDecode(json['final_info']) as List<dynamic>)
        .map((e) => TestPoint.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'subject': subject,
    'subject_id': subjectId,
    'f_grade': grade,
    'stream': stream,
    'room': room,
    'date': examDate.toIso8601String(),
    'from': startTime,
    'to': endTime,
    'final_limit': timeLimit,
    'final_info': testPoints,
  };
}
