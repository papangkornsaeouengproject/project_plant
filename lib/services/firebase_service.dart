import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant_data.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ดึงข้อมูลพืชจาก Firebase ตาม collection และ document name
  static Future<PlantData?> getPlantData(String plantName) async {
    try {
      // ค้นหาจาก collection 'plant' -> document ตามชื่อพืช -> collection ชื่อพืชนั้น
      DocumentSnapshot doc = await _firestore
          .collection('plant')
          .doc(plantName.toLowerCase()) // เช่น 'dracaena', 'wasana'
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PlantData.fromFirebase(data);
      }
      return null;
    } catch (e) {
      print('Error getting plant data: $e');
      return null;
    }
  }

  // ดึงข้อมูลพืชทั้งหมด (สำหรับ dropdown หรือ list)
  static Future<List<PlantData>> getAllPlants() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('plant').get();
      
      List<PlantData> plants = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        plants.add(PlantData.fromFirebase(data));
      }
      
      return plants;
    } catch (e) {
      print('Error getting all plants: $e');
      return [];
    }
  }

}