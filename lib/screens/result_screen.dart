import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  String _value(String key) {
    final value = result[key];

    if (value == null || value.toString().trim().isEmpty) {
      return 'Belirsiz';
    }

    return value.toString();
  }

  List<Map<String, dynamic>> _recommendations(
    String key, {
    required String fallbackBrandKey,
    required String fallbackCodeKey,
  }) {
    final value = result[key];

    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    }

    return [
      {
        'brand': _value(fallbackBrandKey),
        'product': '',
        'shade': _value(fallbackCodeKey),
      },
    ];
  }

  String _recommendationText(String title, String key) {
    final recommendations = _recommendations(
      key,
      fallbackBrandKey: '${title}Brand',
      fallbackCodeKey: '${title}Code',
    );

    final buffer = StringBuffer();

    for (int index = 0; index < recommendations.length; index++) {
      final item = recommendations[index];

      final label = switch (index) {
        0 => 'En Uygun',
        1 => 'Alternatif 1',
        _ => 'Alternatif 2',
      };

      buffer.writeln(label);
      buffer.writeln(
        '${item['brand'] ?? ''} — ${item['product'] ?? ''}',
      );
      buffer.writeln('Kod / Renk: ${item['shade'] ?? ''}');
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _buildCopyText() {
    return '''
GlowMatch AI Analizi

Cilt Tonu:
${_value('skinTone')}

Alt Ton:
${_value('undertone')}

Cilt Tipi:
${_value('skinType')}

Yüz Şekli:
${_value('faceShape')}

Göz Rengi:
${_value('eyeColor')}

Mevcut Saç Rengi:
${_value('hairColor')}

FONDÖTEN
${_recommendationText('foundation', 'foundationRecommendations')}

KAPATICI
${_recommendationText('concealer', 'concealerRecommendations')}

ALLIK
${_recommendationText('blush', 'blushRecommendations')}

RUJ
${_recommendationText('lipstick', 'lipstickRecommendations')}

Saç Modeli Önerisi:
${_value('hairStyle')}

Saç Rengi Önerisi:
${_value('hairColorSuggestion')}

Not:
${_value('disclaimer')}
''';
  }

  Future<void> _copyAnalysis(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: _buildCopyText()),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Analiz panoya kopyalandı.'),
        ),
      );
  }

  Future<void> _selectAllAnalysis(BuildContext context) async {
    final controller = TextEditingController(
      text: _buildCopyText(),
    );

    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tüm Analiz'),
          content: SizedBox(
            width: 600,
            height: 450,
            child: TextField(
              controller: controller,
              readOnly: true,
              autofocus: true,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Kapat'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: controller.text),
                );

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Tüm analiz kopyalandı.'),
                    ),
                  );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Kopyala'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        title: SelectableText(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: SelectableText(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection({
    required String title,
    required IconData icon,
    required String recommendationsKey,
    required String fallbackBrandKey,
    required String fallbackCodeKey,
  }) {
    final recommendations = _recommendations(
      recommendationsKey,
      fallbackBrandKey: fallbackBrandKey,
      fallbackCodeKey: fallbackCodeKey,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.pink,
                  size: 28,
                ),
                const SizedBox(width: 10),
                SelectableText(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            for (int index = 0;
                index < recommendations.length;
                index++) ...[
              _buildRecommendationItem(
                index: index,
                recommendation: recommendations[index],
              ),

              if (index != recommendations.length - 1)
                const Divider(height: 26),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required int index,
    required Map<String, dynamic> recommendation,
  }) {
    final label = switch (index) {
      0 => '🥇 En Uygun',
      1 => '🥈 Alternatif 1',
      _ => '🥉 Alternatif 2',
    };

    final brand = recommendation['brand']?.toString() ?? 'Belirsiz';
    final product =
        recommendation['product']?.toString() ?? '';
    final shade = recommendation['shade']?.toString() ?? 'Belirsiz';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 7),
        SelectableText(
          product.isEmpty ? brand : '$brand — $product',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        SelectableText('Kod / Renk: $shade'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('Analiz Sonucu'),
        centerTitle: true,
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 15),
            const SelectableText(
              'GlowMatch AI Sonucu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            _buildInfoCard(
              icon: Icons.face,
              title: 'Cilt Tonu',
              value: _value('skinTone'),
            ),
            _buildInfoCard(
              icon: Icons.wb_sunny_outlined,
              title: 'Alt Ton',
              value: _value('undertone'),
            ),
            _buildInfoCard(
              icon: Icons.water_drop_outlined,
              title: 'Cilt Tipi',
              value: _value('skinType'),
            ),
            _buildInfoCard(
              icon: Icons.crop_square,
              title: 'Yüz Şekli',
              value: _value('faceShape'),
            ),
            _buildInfoCard(
              icon: Icons.remove_red_eye_outlined,
              title: 'Göz Rengi',
              value: _value('eyeColor'),
            ),
            _buildInfoCard(
              icon: Icons.content_cut,
              title: 'Mevcut Saç Rengi',
              value: _value('hairColor'),
            ),

            const SizedBox(height: 16),

            const SelectableText(
              'Önerilen Makyaj Ürünleri',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildRecommendationSection(
              title: 'Fondöten',
              icon: Icons.brush,
              recommendationsKey: 'foundationRecommendations',
              fallbackBrandKey: 'foundationBrand',
              fallbackCodeKey: 'foundationCode',
            ),

            _buildRecommendationSection(
              title: 'Kapatıcı',
              icon: Icons.opacity,
              recommendationsKey: 'concealerRecommendations',
              fallbackBrandKey: 'concealerBrand',
              fallbackCodeKey: 'concealerCode',
            ),

            _buildRecommendationSection(
              title: 'Allık',
              icon: Icons.palette_outlined,
              recommendationsKey: 'blushRecommendations',
              fallbackBrandKey: 'blushBrand',
              fallbackCodeKey: 'blushCode',
            ),

            _buildRecommendationSection(
              title: 'Ruj',
              icon: Icons.favorite_outline,
              recommendationsKey: 'lipstickRecommendations',
              fallbackBrandKey: 'lipstickBrand',
              fallbackCodeKey: 'lipstickCode',
            ),

            const SizedBox(height: 10),

            const SelectableText(
              'Saç Önerileri',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildInfoCard(
              icon: Icons.face_retouching_natural,
              title: 'Saç Modeli',
              value: _value('hairStyle'),
            ),

            _buildInfoCard(
              icon: Icons.color_lens_outlined,
              title: 'Saç Rengi Önerisi',
              value: _value('hairColorSuggestion'),
            ),

            const SizedBox(height: 15),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _value('disclaimer'),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _selectAllAnalysis(context),
                icon: const Icon(Icons.select_all),
                label: const Text('Tümünü Seç'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _copyAnalysis(context),
                icon: const Icon(Icons.copy_all_outlined),
                label: const Text('Analizi Kopyala'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Yeni Analiz Yap'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}