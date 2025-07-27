import 'package:flutter/material.dart';

class PlantInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ต้นวาสนา',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.eco, color: Colors.green, size: 20),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'ชื่อทางวิทยาศาสตร์ : Dracaena fragrans (L.) Ker Gawl.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'ชื่อทางอังกฤษ : Corn Plant, Lucky Plant, Fragrant Dracaena',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.account_tree, color: Colors.brown, size: 18),
              SizedBox(width: 8),
              Text(
                'Family : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                'Asparagaceae',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            'ข้อดี',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15),
          _buildCareTip(
            icon: Icons.home,
            color: Colors.green,
            title: 'ช่วยทำให้อากาศในบ้านหรือออฟฟิศ สะอาดขึ้น',
            subtitle: 'และลดฝุ่นในอากาศ',
          ),
          SizedBox(height: 15),
          _buildCareTip(
            icon: Icons.favorite,
            color: Colors.blue,
            title: 'ดูแลง่าย เหมาะกับผู้เริ่มต้นปลูกต้นไม้',
            subtitle: '',
          ),
          SizedBox(height: 15),
          _buildCareTip(
            icon: Icons.wb_sunny,
            color: Colors.green,
            title: 'เหมาะกับการปลูกในกระถาง ตั้งในห้องต้องใสสว่าง',
            subtitle: 'ห้องนอน หรือมุมทำงาน',
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ต้นวาสนา',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ชื่อ วาสนา เป็นนามมงคล หมายถึง โชคลาภ มากิมี ความเจริญรุ่งเรือง เชื่อว่าหากปลูกสวยออกดอก จะโชคดีลาภก้อนออกตอง',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTip({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
