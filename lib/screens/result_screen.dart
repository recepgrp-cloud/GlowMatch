import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  Widget buildCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.pink,
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foundation = result["foundation"];
    final lipstick = result["lipstick"];
    final blush = result["blush"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("GlowMatch Sonucu"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Icon(
            Icons.auto_awesome,
            size: 90,
            color: Colors.pink,
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "AI Analizi Tamamlandı",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          buildCard(
            icon: Icons.face,
            title: "Cilt Tonu",
            value: result["skinTone"],
          ),

          buildCard(
            icon: Icons.wb_sunny,
            title: "Alt Ton",
            value: result["undertone"],
          ),

          buildCard(
            icon: Icons.water_drop,
            title: "Cilt Tipi",
            value: result["skinType"],
          ),

          buildCard(
            icon: Icons.crop_square,
            title: "Yüz Şekli",
            value: result["faceShape"],
          ),

          buildCard(
            icon: Icons.remove_red_eye,
            title: "Göz Rengi",
            value: result["eyeColor"],
          ),

          buildCard(
            icon: Icons.content_cut,
            title: "Saç Rengi",
            value: result["hairColor"],
          ),

          const Divider(height: 40),

          const Text(
            "Önerilen Ürünler",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          buildCard(
            icon: Icons.brush,
            title: foundation["brand"],
            value:
                "${foundation["product"]}\nKod: ${foundation["code"]}",
          ),

          buildCard(
            icon: Icons.favorite,
            title: lipstick["brand"],
            value:
                "${lipstick["product"]}\nKod: ${lipstick["code"]}",
          ),

          buildCard(
            icon: Icons.palette,
            title: blush["brand"],
            value:
                "${blush["product"]}\nKod: ${blush["code"]}",
          ),

          const SizedBox(height: 30),

          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Yeni Analiz Yap"),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}