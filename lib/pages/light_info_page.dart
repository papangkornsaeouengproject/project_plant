import 'package:flutter/material.dart';

class LightInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'แสงสว่าง',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildInfoTile(
            icon: Icons.wb_sunny,
            color: Colors.orange,
            title: 'แสงแดดรำไร',
            subtitle:
                'ควรวางต้นวาสนาในจุดที่มีแสงสว่างพอประมาณ เช่น ริมหน้าต่างที่มีม่านกรองแสง',
          ),
          SizedBox(height: 15),
          _buildInfoTile(
            icon: Icons.light_mode,
            color: Colors.yellow[800]!,
            title: 'หลีกเลี่ยงแสงแดดจัด',
            subtitle: 'ไม่ควรวางไว้กลางแจ้งที่โดนแดดโดยตรง อาจทำให้ใบไหม้',
          ),
          SizedBox(height: 15),
          _buildInfoTile(
            icon: Icons.house,
            color: Colors.green,
            title: 'เหมาะสำหรับในอาคาร',
            subtitle:
                'เหมาะกับห้องนั่งเล่น ห้องนอน หรือสำนักงานที่มีแสงธรรมชาติ',
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
