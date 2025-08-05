class PlantData {
  final String name;
  final String engName;
  final String scienceName;
  final String family;
  final int accuracy;
  final String meaningName;
  final String water;
  final String light;
  final String advantageFirst;
  final String advantageSecond;
  final String advantageThird;

  PlantData({
    required this.name,
    required this.engName,
    required this.scienceName,
    required this.family,
    required this.accuracy,
    required this.meaningName,
    required this.water,
    required this.light,
    required this.advantageFirst,
    required this.advantageSecond,
    required this.advantageThird,
  });

  factory PlantData.fromFirebase(Map<String, dynamic> data) {
    return PlantData(
      name: data['name'] ?? '',
      engName: data['eng_name'] ?? '',
      scienceName: data['science_name'] ?? '',
      family: data['Family'] ?? '',
      accuracy: 87, // จากการสแกน
      meaningName: data['meaning_name'] ?? '',
      water: data['water'] ?? '',
      light: data['light'] ?? '',
      advantageFirst: data['Advantage_first'] ?? '',
      advantageSecond: data['Advantage_second'] ?? '',
      advantageThird: data['Advantage_third'] ?? '',
    );
  }
}