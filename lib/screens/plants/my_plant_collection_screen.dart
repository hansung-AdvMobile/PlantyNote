// my_plant_collection_screen.dart  # 4번 화면
import 'package:flutter/material.dart';

class MyPlantCollectionScreen extends StatelessWidget {
  const MyPlantCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY 정원'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/plant_register');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _plantListItem(
            context,
            plantName: '팥이',
            imageUrl: 'assets/images/sample_plant.png',
            dDayWater: 1,
            dDayFertilizer: 220,
          ),
          const SizedBox(height: 16),
          _plantListItem(
            context,
            plantName: '콩콩이',
            imageUrl: 'assets/images/sample_plant.png',
            dDayWater: 3,
            dDayFertilizer: 34,
          ),
        ],
      ),
    );
  }

  Widget _plantListItem(
      BuildContext context, {
        required String plantName,
        required String imageUrl,
        required int dDayWater,
        required int dDayFertilizer,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/plant_timeline');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _dDayBadge('D-$dDayFertilizer', Colors.red),
                      const SizedBox(width: 8),
                      _dDayBadge('D-$dDayWater', Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _dDayBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
