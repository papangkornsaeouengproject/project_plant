import 'package:flutter/material.dart';

class WaterInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การรดน้ำ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildInfoTile(
            icon: Icons.water_drop,
            color: Colors.blue,
            title: 'รดน้ำ 2–3 ครั้งต่อสัปดาห์',
            subtitle: 'ให้ดินชุ่มแต่ไม่แฉะ หลีกเลี่ยงการรดน้ำมากเกินไป',
          ),
          SizedBox(height: 15),
          _buildInfoTile(
            icon: Icons.opacity,
            color: Colors.lightBlue,
            title: 'ระวังรากเน่า',
            subtitle: 'ถ้าน้ำขังในกระถาง หรือระบายน้ำไม่ดีอาจทำให้รากเน่าได้',
          ),
          SizedBox(height: 15),
          _buildInfoTile(
            icon: Icons.cloud,
            color: Colors.grey,
            title: 'ในฤดูฝน',
            subtitle: 'ลดความถี่ในการรดน้ำลง',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
