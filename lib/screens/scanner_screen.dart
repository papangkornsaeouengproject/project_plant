import 'package:flutter/material.dart';
import 'dart:async';

import 'plant_detail_screen.dart';
import 'error_screen.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isScanning = false;

  void _startScan() {
    setState(() {
      _isScanning = true;
    });

    Timer(Duration(seconds: 3), () {
      setState(() => _isScanning = false);
      Timer(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantDetailScreen()),
        );
      });
    });
  }

  void _showError() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ErrorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildCameraFrame(),
          if (_isScanning) _buildScanningOverlay(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildBackground() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade900, Colors.greenAccent.shade100],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      image: DecorationImage(
        image: AssetImage('assets/plant_bg.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.4),
          BlendMode.darken,
        ),
      ),
    ),
  );

  Widget _buildCameraFrame() => Center(
    child: Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
    ),
  );

  Widget _buildScanningOverlay() => Container(
    color: Colors.black.withOpacity(0.7),
    child: Center(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 4,
            ),
            SizedBox(height: 25),
            Text(
              'กำลังวิเคราะห์ภาพ...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'โปรดรอสักครู่เพื่อดูผลลัพธ์',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildBottomButtons() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: _startScan,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.green.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(Icons.camera_alt, size: 42, color: Colors.black87),
            ),
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _testButton(
                label: 'ทดสอบ: พบต้นไม้',
                color: Colors.green.shade700,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantDetailScreen()),
                ),
              ),
              _testButton(
                label: 'ทดสอบ: ไม่พบ',
                color: Colors.redAccent,
                onPressed: _showError,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _testButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 6,
      ),
      child: Text(label),
    );
  }
}
