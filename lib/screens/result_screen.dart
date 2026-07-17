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

  Widget _buildAnalysisDetailsSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(
          Icons.psychology_alt_outlined,
          color: Colors.deepPurple,
        ),
        title: const Text(
          'AI Analiz Detayları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Cilt, yüz, göz ve saç analizini görmek için dokun',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
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
        ],
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


  Widget _buildAffordableFoundationSection() {
    final value = result['affordableFoundationAlternatives'];

    if (value is! List || value.isEmpty) {
      return const SizedBox.shrink();
    }

    final alternatives = value
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();

    if (alternatives.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.savings_outlined,
                  color: Colors.green,
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    'Aynı Tonda Daha Uygun Alternatifler',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ana fondöten önerisine yakın, 300 TL ile 1000 TL arasındaki seçenekler.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 14),
            for (int index = 0;
                index < alternatives.length;
                index++) ...[
              _buildRecommendationItem(
                index: index,
                recommendation: alternatives[index],
              ),
              if (index != alternatives.length - 1)
                const Divider(height: 26),
            ],
          ],
        ),
      ),
    );
  }

  String _recommendationValue(
  Map<String, dynamic> recommendation,
  String key, {
  String fallback = '',
}) {
  final value = recommendation[key];

  if (value == null || value.toString().trim().isEmpty) {
    return fallback;
  }

  return value.toString().trim();
}

bool _recommendationBool(
  Map<String, dynamic> recommendation,
  String key,
) {
  final value = recommendation[key];

  if (value is bool) {
    return value;
  }

  return value.toString().toLowerCase() == 'true';
}

String _priceText(Map<String, dynamic> recommendation) {
  final value = recommendation['averagePrice'];

  if (value == null) {
    return 'Fiyat bilgisi yok';
  }

  final price = value is num
      ? value.toInt()
      : int.tryParse(value.toString());

  if (price == null || price <= 0) {
    return 'Fiyat bilgisi yok';
  }

  return 'Yaklaşık $price TL';
}

String _priceSegmentText(
  Map<String, dynamic> recommendation,
  int index,
) {
  final value = recommendation['priceSegment']
      ?.toString()
      .trim()
      .toLowerCase();

  if (value != null) {
    if (value.contains('premium')) {
      return 'Premium';
    }

    if (value.contains('ekonomik') || value.contains('budget')) {
      return 'Ekonomik';
    }

    if (value.contains('orta') || value.contains('mid')) {
      return 'Orta Segment';
    }
  }

  return switch (index) {
    0 => 'Ana Öneri',
    1 => 'Alternatif',
    _ => 'Diğer Alternatif',
  };
}

Color _priceSegmentColor(String segment) {
  switch (segment) {
    case 'Premium':
      return Colors.deepPurple;

    case 'Ekonomik':
      return Colors.green;

    case 'Orta Segment':
      return Colors.orange;

    default:
      return Colors.pink;
  }
}

Widget _buildFeatureChip({
  required IconData icon,
  required String label,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.grey.shade300,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.deepPurple,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildRecommendationItem({
  required int index,
  required Map<String, dynamic> recommendation,
}) {
  final medal = switch (index) {
    0 => '🥇',
    1 => '🥈',
    _ => '🥉',
  };

  final brand = _recommendationValue(
    recommendation,
    'brand',
    fallback: 'Marka belirtilmedi',
  );

  final product = _recommendationValue(
    recommendation,
    'product',
  );

  final shade = _recommendationValue(
    recommendation,
    'shade',
    fallback: 'Renk belirtilmedi',
  );

  final finish = _recommendationValue(
    recommendation,
    'finish',
  );

  final coverage = _recommendationValue(
    recommendation,
    'coverage',
  );

  final shadeFamily = _recommendationValue(
    recommendation,
    'shadeFamily',
  );

  final vegan = _recommendationBool(
    recommendation,
    'vegan',
  );

  final crueltyFree = _recommendationBool(
    recommendation,
    'crueltyFree',
  );

  final skinTypesValue = recommendation['skinTypes'];

  final skinTypes = skinTypesValue is List
      ? skinTypesValue
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(', ')
      : '';

  final segment = _priceSegmentText(
    recommendation,
    index,
  );

  final segmentColor = _priceSegmentColor(segment);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: segmentColor.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: segmentColor.withValues(alpha: 0.25),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SelectableText(
                '$medal $segment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: segmentColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: segmentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _priceText(recommendation),
                style: TextStyle(
                  color: segmentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        SelectableText(
          brand,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (product.isNotEmpty) ...[
          const SizedBox(height: 4),
          SelectableText(
            product,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        const SizedBox(height: 11),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.colorize,
                size: 20,
                color: Colors.pink,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectableText(
                  'Kod / Renk: $shade',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (shadeFamily.isNotEmpty) ...[
          const SizedBox(height: 8),
          SelectableText(
            'Renk ailesi: $shadeFamily',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],

        if (finish.isNotEmpty ||
            coverage.isNotEmpty ||
            skinTypes.isNotEmpty ||
            vegan ||
            crueltyFree) ...[
          const SizedBox(height: 13),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (finish.isNotEmpty)
                _buildFeatureChip(
                  icon: Icons.auto_awesome,
                  label: 'Bitiş: $finish',
                ),

              if (coverage.isNotEmpty)
                _buildFeatureChip(
                  icon: Icons.layers_outlined,
                  label: 'Kapatıcılık: $coverage',
                ),

              if (skinTypes.isNotEmpty)
                _buildFeatureChip(
                  icon: Icons.water_drop_outlined,
                  label: skinTypes,
                ),

              if (vegan)
                _buildFeatureChip(
                  icon: Icons.eco_outlined,
                  label: 'Vegan',
                ),

              if (crueltyFree)
                _buildFeatureChip(
                  icon: Icons.pets_outlined,
                  label: 'Cruelty Free',
                ),
            ],
          ),
        ],
      ],
    ),
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

            _buildAffordableFoundationSection(),

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

            const SizedBox(height: 8),

            _buildAnalysisDetailsSection(),

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