class QueryData {
  String coverLetterType;
  String myProfile;
  double professionalLevel;
  String? companyName;
  String? positionApplyingFor;
  String? jobDescription;

  QueryData({
    required this.coverLetterType,
    required this.myProfile,
    this.professionalLevel = 100.0,
    this.companyName,
    this.positionApplyingFor,
    this.jobDescription,
  });
}
