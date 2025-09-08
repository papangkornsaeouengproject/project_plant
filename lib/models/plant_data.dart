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
  final String watering_indoor;
  final String watering_outdoor;
  final String light_detail;
  final String how_to_watering;
  final String temp;
  final String warning;
  final String image;


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
    required this.watering_indoor,
    required this.watering_outdoor,
    required this.light_detail,
    required this.how_to_watering,
    required this.temp,
    required this.warning,
    required this.image,
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
      watering_indoor: data['watering_indoor'] ?? '',
      watering_outdoor: data['watering_outdoor'] ?? '',
      light_detail: data['light_detail'] ?? '',
      how_to_watering: data['how_to_watering'] ?? '',
      temp: data['temp'] ?? '',
      warning: data['warning'] ?? '',
      image: data['image'] ?? '',
    );
  }
}