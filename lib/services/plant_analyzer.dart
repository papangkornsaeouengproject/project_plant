import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PlantAnalyzer {
  final String apiUrl = 'http://10.0.2.2:8000/predict';

  Future<void> processPlantImage({
    required String imagePath,
    required Function(PlantAnalysisResult) onSuccess,
    required Function() onError,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      var mimeType = lookupMimeType(imagePath) ?? 'application/octet-stream';
      var mimeSplit = mimeType.split('/');

      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imagePath,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      );

      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['predictions'].isNotEmpty) {
          final pred = data['predictions'][0];

          final result = PlantAnalysisResult(
            plantName: pred['name'],
            confidence: pred['confidence'],
            description: _generateMockDescription(pred['name']),
            imagePath: imagePath,
          );
          onSuccess(result);
        } else {
          print("❌ ไม่มีการตรวจพบพืชในภาพ");
          onError();
        }
      } else {
        print('❌ การเรียก API ล้มเหลว: ${response.statusCode}');
        onError();
      }
    } catch (e) {
      print('❌ เกิดข้อผิดพลาด: $e');
      onError();
    }
  }

  String _generateMockDescription(String name) {
    return 'พืชชนิด "$name" เจริญเติบโตได้ดีในอากาศร้อนชื้น เหมาะแก่การปลูกในบ้านหรือสวน.';
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
