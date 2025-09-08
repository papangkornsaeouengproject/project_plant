import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PlantAnalyzer {
  late Interpreter _interpreter;
  final List<String> labels;

  PlantAnalyzer({required this.labels});

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/model_unquant.tflite');
  }

  Future<void> processPlantImage({
    required String imagePath,
    required Function(PlantAnalysisResult) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      if (!File(imagePath).existsSync()) {
        onError('ไม่พบไฟล์ภาพ');
        return;
      }

      final imageBytes = File(imagePath).readAsBytesSync();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        onError('ไม่สามารถอ่านไฟล์ภาพได้');
        return;
      }

      img.Image resized = img.copyResize(image, width: 224, height: 224);

      Float32List inputBytes = Float32List(1 * 224 * 224 * 3);
      int pixelIndex = 0;
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          img.Pixel pixel = resized.getPixel(x, y);
          inputBytes[pixelIndex++] = pixel.r / 255.0;
          inputBytes[pixelIndex++] = pixel.g / 255.0;
          inputBytes[pixelIndex++] = pixel.b / 255.0;
        }
      }

      var input = inputBytes.reshape([1, 224, 224, 3]);
      var output = List.filled(1 * labels.length, 0.0).reshape([1, labels.length]);

      _interpreter.run(input, output);

      int maxIndex = 0;
      double maxConfidence = output[0][0].toDouble();
      for (int i = 1; i < labels.length; i++) {
        double c = output[0][i].toDouble();
        if (c > maxConfidence) {
          maxConfidence = c;
          maxIndex = i;
        }
      }

      final result = PlantAnalysisResult(
        plantName: labels[maxIndex],
        confidence: maxConfidence * 100,
        imagePath: imagePath,
        allPredictions: _getAllPredictions(output[0]),
      );

      onSuccess(result);
    } catch (e) {
      onError('เกิดข้อผิดพลาด: $e');
    }
  }

  List<PredictionResult> _getAllPredictions(List<dynamic> output) {
    List<PredictionResult> predictions = [];
    for (int i = 0; i < labels.length; i++) {
      predictions.add(PredictionResult(label: labels[i], confidence: output[i].toDouble() * 100));
    }
    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return predictions;
  }

  void dispose() => _interpreter.close();
}

class PlantAnalysisResult {
  final String plantName;
  final double confidence;
  final String imagePath;
  final List<PredictionResult> allPredictions;

  PlantAnalysisResult({
    required this.plantName,
    required this.confidence,
    required this.imagePath,
    required this.allPredictions,
  });
}

class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({required this.label, required this.confidence});
}

extension ListExtension<T> on List<T> {
  List<dynamic> reshape(List<int> shape) {
    if (shape.isEmpty) return this;
    int totalSize = shape.reduce((a, b) => a * b);
    if (length != totalSize) throw ArgumentError('ขนาดไม่ตรงกัน');
    return _reshapeRecursive(this, shape, 0);
  }

  List<dynamic> _reshapeRecursive(List<T> data, List<int> shape, int depth) {
    if (depth == shape.length - 1) return data.sublist(0, shape[depth]);
    List<dynamic> result = [];
    int step = shape.sublist(depth + 1).reduce((a, b) => a * b);
    for (int i = 0; i < shape[depth]; i++) {
      int start = i * step;
      int end = start + step;
      result.add(_reshapeRecursive(data.sublist(start, end), shape, depth + 1));
    }
    return result;
  }
}
