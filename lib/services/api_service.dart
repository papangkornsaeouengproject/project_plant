import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000'; // เชื่อม FastAPI

  // ฟังก์ชันอัปโหลดภาพไปยัง /predict
  Future<Map<String, dynamic>> uploadImage(String imagePath) async {
    final uri = Uri.parse('$baseUrl/predict');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('API failed with status: ${response.statusCode}');
    }
  }

  // ทดสอบเรียก root endpoint
  Future<String> getMessage() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to load message');
    }
  }
}
