import 'package:flutter/material.dart';

class PlantHeader extends StatelessWidget {
  final int accuracy;
  final VoidCallback onBack;

  const PlantHeader({
    Key? key,
    required this.accuracy,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              ),
              Text(
                'ความแม่นยำ $accuracy%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 48), // เพื่อจัดกึ่งกลาง
            ],
          ),
        ),
      ),
    );
  }
}