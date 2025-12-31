import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

extension Trimming on String {
  String removeUpToColonAndTrim() {
    String s = this;
    int colonIndex = s.indexOf(':');
    s = s.substring(colonIndex + 1);
    return s.trim();
  }
}

extension RemovingFileExtension on String {
  String removeFileExtension() {
    String s = this;
    int dotIndex = s.lastIndexOf('.');
    return s.substring(dotIndex + 1, s.length - 1);
  }
}

extension IsNullOrWhiteSpace on String? {
  bool isNullOrWhiteSpace() {
    String? s = this;
    return s == null || s.trim() == '';
  }
}

extension DoubleParsing on String {
  double? parseOrReturnNull() {
    return double.tryParse(replaceAll('.', ','));
  }
}

extension GetHTML on Dio {
  Future<Document> getHtml(String path, {Options? options}) async {
    Dio dio = this;
    final response = await dio.get(path, options: options);
    return parse(response.data);
  }
}

extension GetWeek on DateTime {
  int weekNumber() {
    // Monday = first day
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstDayWeekday = firstDayOfYear.weekday; // Monday=1 … Sunday=7

    // Offset to make week start on Monday
    int offset = (firstDayWeekday - DateTime.monday) % 7;

    return ((difference(firstDayOfYear).inDays + offset) ~/ 7) + 1;
  }
}
