import 'package:flutter/material.dart';
import '../models/plant_data.dart';
import '../services/firebase_service.dart';
import '../widgets/plant_header.dart';
import '../widgets/plant_image.dart';
import '../widgets/plant_name.dart';
import '../widgets/care_icons.dart';
import '../widgets/plant_details.dart';
import '../widgets/action_buttons.dart';
import '../widgets/detail_modal.dart';

class PlantScanResultScreen extends StatefulWidget {
  final String scannedPlantName;
  final int accuracy;

  const PlantScanResultScreen({
    Key? key,
    required this.scannedPlantName,
    required this.accuracy,
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

      PlantData? data = await FirebaseService.getPlantData(widget.scannedPlantName);

      if (data != null) {
        data = PlantData(
          name: data.name,
          engName: data.engName,
          scienceName: data.scienceName,
          family: data.family,
          accuracy: widget.accuracy,
          meaningName: data.meaningName,
          water: data.water,
          light: data.light,
          advantageFirst: data.advantageFirst,
          advantageSecond: data.advantageSecond,
          advantageThird: data.advantageThird,
          watering_indoor: data.watering_indoor,
          watering_outdoor: data.watering_outdoor,
          light_detail: data.light_detail,
          how_to_watering: data.how_to_watering,
          temp: data.temp,
          warning: data.warning,
          image: data.image,
        );

        setState(() {
          _plantData = data;
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

  void _handleBack() {
    Navigator.pop(context);
  }

  void _handleIconTap(String type) {
    setState(() {
      _showDetail = type;
    });
  }

  void _handleScanNew() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _closeModal() {
    setState(() {
      _showDetail = null;
    });
  }

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
                        onPressed: _handleScanNew,
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
                              children: [
                                PlantImage(imageUrl: _plantData!.image), // ✅ ส่ง imageUrl เข้ามา
                                PlantName(name: _plantData!.name),
                                CareIcons(
                                  plantData: _plantData!,
                                  onIconTap: _handleIconTap,
                                ),
                                PlantDetails(plantData: _plantData!),
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
