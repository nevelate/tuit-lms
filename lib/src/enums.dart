enum TableLessonType {
  full(1),
  left(2),
  right(3);

  final int value;
  const TableLessonType(this.value);

  static TableLessonType fromValue(int value) {
    return TableLessonType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TableLessonType.full,
    );
  }
}

enum LessonType { lecture, practice, laboratory }
