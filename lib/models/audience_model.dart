class AudienceModel {
  final int genderMale;
  final int genderFemale;
  final int genderOther;
  final int age18_24;
  final int age25_34;
  final int age35Plus;
  final List<String> countryTop;

  AudienceModel({
    required this.genderMale,
    required this.genderFemale,
    required this.genderOther,
    required this.age18_24,
    required this.age25_34,
    required this.age35Plus,
    required this.countryTop,
  });

  factory AudienceModel.fromMap(Map<String, dynamic> map) {
    return AudienceModel(
      genderMale: map['gender_male'] ?? 0,
      genderFemale: map['gender_female'] ?? 0,
      genderOther: map['gender_other'] ?? 0,
      age18_24: map['age_18_24'] ?? 0,
      age25_34: map['age_25_34'] ?? 0,
      age35Plus: map['age_35_plus'] ?? 0,
      countryTop: List<String>.from(map['country_top'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gender_male': genderMale,
      'gender_female': genderFemale,
      'gender_other': genderOther,
      'age_18_24': age18_24,
      'age_25_34': age25_34,
      'age_35_plus': age35Plus,
      'country_top': countryTop,
    };
  }
}
