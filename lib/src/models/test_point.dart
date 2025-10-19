class TestPoint{
  final int testNumber;
  final int point;

  TestPoint(this.testNumber, this.point);

  factory TestPoint.fromJson(Map<String, dynamic> json) {
    return TestPoint(
      json['number'] as int,
      json['point'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': testNumber,
        'point': point,
      };
}