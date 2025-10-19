class Information {
  final String? fullName;
  final DateTime birthDate;
  final String? gender;

  final String? studentNumber;
  final String? group;
  final String? tutor;

  final String? address;
  final String? temporaryAddress;

  final String? base64Photo;

  final String? specialization;
  final String? studyLanguage;
  final String? degree;
  final String? typeOfStudy;
  final int year;

  final String? stipend;

  Information({
    this.fullName,
    required this.birthDate,
    this.gender,
    this.studentNumber,
    this.group,
    this.tutor,
    this.address,
    this.temporaryAddress,
    this.base64Photo,
    this.specialization,
    this.studyLanguage,
    this.degree,
    this.typeOfStudy,
    required this.year,
    this.stipend,
});
}
