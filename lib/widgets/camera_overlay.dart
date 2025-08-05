import 'package:flutter/material.dart';
import '../painters/crosshair_painter.dart';

class CameraOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Dark overlay with transparent center
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
          ),
          // Focus guide
          _buildFocusGuide(),
          // Instructions
          _buildInstructions(context),
        ],
      ),
    );
  }

  Widget _buildFocusGuide() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.greenAccent.withOpacity(0.8),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Corner indicators
            _buildCornerIndicators(),
            // Center cross
            Center(
              child: Container(
                width: 40,
                height: 40,
                child: CustomPaint(painter: CrosshairPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerIndicators() {
    return Stack(
      children: [
        // Top corners
        Positioned(top: -2, left: -2, child: _buildCornerIndicator()),
        Positioned(
          top: -2,
          right: -2,
          child: Transform.rotate(
            angle: 1.5708,
            child: _buildCornerIndicator(),
          ),
        ),
        // Bottom corners
        Positioned(
          bottom: -2,
          left: -2,
          child: Transform.rotate(
            angle: -1.5708,
            child: _buildCornerIndicator(),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Transform.rotate(
            angle: 3.14159,
            child: _buildCornerIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildCornerIndicator() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.greenAccent, width: 4),
          left: BorderSide(color: Colors.greenAccent, width: 4),
        ),
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_florist,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ถ่ายรูปดอกไม้หรือใบพืชในกรอบ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}