import 'dart:async';
import 'dart:math';

class PlantAnalyzer {
  Future<void> processPlantImage({
    required String imagePath,
    required Function(PlantAnalysisResult) onSuccess,
    required Function() onError,
  }) async {
    try {
      // TODO: ใส่ Roboflow AI model ตรงนี้
      // Simulate AI processing time
      await Future.delayed(Duration(seconds: 3));

      // Simulate random success/failure for demo
      final random = Random();
      final isSuccess = random.nextBool();

      if (isSuccess) {
        // Create mock result
        final result = PlantAnalysisResult(
          plantName: _generateMockPlantName(),
          confidence: 0.85 + (random.nextDouble() * 0.15), // 85-100%
          description: _generateMockDescription(),
          imagePath: imagePath,
        );
        onSuccess(result);
      } else {
        onError();
      }
    } catch (e) {
      print('Error in plant analysis: $e');
      onError();
    }
  }

  String _generateMockPlantName() {
    final plants = [
      'ดอกไม้สีแดง',
      'ใบไผ่',
      'ดอกบัว',
      'ต้นมะม่วง',
      'ดอกรักเร่',
      'ใบโบ๊ะ',
      'ดอกกุหลาบ',
      'ต้นกล้วย',
    ];
    return plants[Random().nextInt(plants.length)];
  }

  String _generateMockDescription() {
    return 'พืชชนิดนี้มีความสวยงามและเจริญเติบโตได้ดีในสภาพอากาศร้อนชื้น เหมาะสำหรับการปลูกในสวนหรือกระถาง';
  }
}

class PlantAnalysisResult {
  final String plantName;
  final double confidence;
  final String description;
  final String imagePath;

  PlantAnalysisResult({
    required this.plantName,
    required this.confidence,
    required this.description,
    required this.imagePath,
  });
}