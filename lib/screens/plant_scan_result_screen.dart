import 'dart:io' show File;                 // ✅ ใช้สำหรับ Image.file (Android/iOS)
import 'package:flutter/foundation.dart';   // ✅ ใช้ kIsWeb guard
import 'package:flutter/material.dart';

import '../models/plant_data.dart';
import '../services/firebase_service.dart';
import '../widgets/plant_header.dart';
import '../widgets/plant_image.dart';
import '../widgets/plant_name.dart';
import '../widgets/care_icons.dart';
import '../widgets/plant_details.dart';
import '../widgets/detail_modal.dart';
import '../services/plant_analyzer.dart';

class PlantScanResultScreen extends StatefulWidget {
  final String scannedPlantName;
  final int accuracy;
  final String imagePath; // path ไฟล์ที่ถ่ายจากกล้อง/แกลเลอรี (โลคัล)
  final List<PredictionResult> allPredictions;

  const PlantScanResultScreen({
    Key? key,
    required this.scannedPlantName,
    required this.accuracy,
    required this.imagePath,
    required this.allPredictions,
  }) : super(key: key);

  @override
  State<PlantScanResultScreen> createState() => _PlantScanResultScreenState();
}

class _PlantScanResultScreenState extends State<PlantScanResultScreen> {
  String? _showDetail;
  PlantData? _plantData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlantData();
  }

  Future<void> _loadPlantData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final dataFromFirebase =
          await FirebaseService.getPlantData(widget.scannedPlantName);

      if (dataFromFirebase != null) {
        final dataWithAccuracy = PlantData(
          name: dataFromFirebase.name,
          engName: dataFromFirebase.engName,
          scienceName: dataFromFirebase.scienceName,
          family: dataFromFirebase.family,
          accuracy: widget.accuracy,
          meaningName: dataFromFirebase.meaningName,
          water: dataFromFirebase.water,
          light: dataFromFirebase.light,
          advantageFirst: dataFromFirebase.advantageFirst,
          advantageSecond: dataFromFirebase.advantageSecond,
          advantageThird: dataFromFirebase.advantageThird,
          watering_indoor: dataFromFirebase.watering_indoor,
          watering_outdoor: dataFromFirebase.watering_outdoor,
          light_detail: dataFromFirebase.light_detail,
          how_to_watering: dataFromFirebase.how_to_watering,
          temp: dataFromFirebase.temp,
          warning: dataFromFirebase.warning,
          image: dataFromFirebase.image, // ✅ URL รูปจากฐานข้อมูล
        );

        setState(() {
          _plantData = dataWithAccuracy;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'ไม่พบข้อมูลของพืช "${widget.scannedPlantName}"';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
        _isLoading = false;
      });
    }
  }

  void _handleBack() => Navigator.pop(context);
  void _handleIconTap(String type) => setState(() => _showDetail = type);
  void _closeModal() => setState(() => _showDetail = null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text('กำลังโหลดข้อมูลพืช...'),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ลองสแกนใหม่'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        PlantHeader(
                          accuracy: _plantData!.accuracy,
                          onBack: _handleBack,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ✅ รูปหลักจากฐานข้อมูล (URL)
                                PlantImage(imageUrl: _plantData!.image),

                                // ✅ พรีวิว "รูปที่ถ่าย" (เฉพาะมือถือ/แท็บเล็ต)
                                if (!kIsWeb && (widget.imagePath).isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'ภาพที่ถ่าย',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.file(
                                                File(widget.imagePath),
                                                height: 120,
                                                width: double.infinity,
                                                  fit: BoxFit.contain,   // ✅ เห็นทั้งภาพ ไม่โดนครอป
                                                errorBuilder: (_, __, ___) => const SizedBox(
                                                  height: 120,
                                                  child: Center(
                                                    child: Icon(Icons.broken_image, size: 40),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // ชื่อและรายละเอียดอื่น ๆ
                                PlantName(name: _plantData!.name),
                                CareIcons(
                                  plantData: _plantData!,
                                  onIconTap: _handleIconTap,
                                ),
                                PlantDetails(plantData: _plantData!),

                                const SizedBox(height: 16),
                                const Center(
                                  child: Text(
                                    'ผลทำนายทั้งหมด',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: widget.allPredictions
                                        .map((p) => Text(
                                              '• ${p.label}: ${p.confidence.toStringAsFixed(1)}%',
                                              style: const TextStyle(fontSize: 13),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_showDetail != null)
                      DetailModal(
                        type: _showDetail!,
                        plantData: _plantData!,
                        onClose: _closeModal,
                      ),
                  ],
                ),
    );
  }
}
