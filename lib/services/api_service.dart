import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter _interpreter;

  // โหลดโมเดล
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/model_unquant.tflite');
  }

  // เตรียมรูปภาพและรันโมเดล
  Future<List<dynamic>> predict(String imagePath) async {
    // โหลดภาพ
    final imageBytes = File(imagePath).readAsBytesSync();
    img.Image? image = img.decodeImage(imageBytes);
    
    if (image == null) {
      throw Exception('ไม่สามารถโหลดภาพได้');
    }

    // ปรับขนาดให้ตรงกับ input ของโมเดล เช่น 224x224
    img.Image resized = img.copyResize(image, width: 224, height: 224);

    // แปลงเป็น Float32List สำหรับโมเดล
    Float32List inputBytes = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        img.Pixel pixel = resized.getPixel(x, y);
        
        // Normalize ค่า RGB (0-255 → 0.0-1.0)
        inputBytes[pixelIndex++] = pixel.r / 255.0;
        inputBytes[pixelIndex++] = pixel.g / 255.0; 
        inputBytes[pixelIndex++] = pixel.b / 255.0;
      }
    }

    // Reshape input เป็น [1, 224, 224, 3]
    var input = inputBytes.reshape([1, 224, 224, 3]);

    // เตรียม output - ปรับให้ตรงกับจำนวน class ของโมเดล
    var output = List.filled(1 * 3, 0.0).reshape([1, 3]); // สมมติมี 3 classes

    // รันโมเดล
    _interpreter.run(input, output);

    return output[0];
  }

  // ปิด interpreter เมื่อไม่ใช้แล้ว
  void dispose() {
    _interpreter.close();
  }
}

// Extension สำหรับ reshape
extension ListExtension<T> on List<T> {
  List<dynamic> reshape(List<int> shape) {
    if (shape.isEmpty) return this;
    
    int totalSize = shape.reduce((a, b) => a * b);
    if (length != totalSize) {
      throw ArgumentError('ขนาดไม่ตรงกัน: expected $totalSize, got $length');
    }
    
    return _reshapeRecursive(this, shape, 0);
  }
  
  List<dynamic> _reshapeRecursive(List<T> data, List<int> shape, int depth) {
    if (depth == shape.length - 1) {
      return data.sublist(0, shape[depth]);
    }
    
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