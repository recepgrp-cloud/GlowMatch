import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final bool isDarkMode;
  final String language;

  const ResultScreen({
    super.key,
    required this.result,
    this.isDarkMode = false,
    this.language = 'tr',
  });

  bool get _isTurkish => language == 'tr';

  Color get _backgroundColor =>
      isDarkMode ? const Color(0xFF08070D) : const Color(0xFFFFF8FC);

  Color get _cardColor =>
      isDarkMode ? const Color(0xFF17131F) : Colors.white;

  Color get _primaryTextColor =>
      isDarkMode ? const Color(0xFFF9F6FF) : const Color(0xFF21143D);

  Color get _secondaryTextColor =>
      isDarkMode ? const Color(0xFFB9B0C7) : const Color(0xFF6F647A);

  Color get _borderColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.10)
      : const Color(0xFFEDE7F3);

  String _text({required String tr, required String en}) {
    return _isTurkish ? tr : en;
  }

  String _value(String key, {String? fallback}) {
    final value = result[key];

    if (value == null || value.toString().trim().isEmpty) {
      return fallback ?? _text(tr: 'Belirsiz', en: 'Unclear');
    }

    return value.toString().trim();
  }

  List<Map<String, dynamic>> _recommendations(
    String key, {
    required String fallbackBrandKey,
    required String fallbackCodeKey,
  }) {
    final value = result[key];

    if (value is List) {
      final items = value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (items.isNotEmpty) {
        return items;
      }
    }

    final fallbackBrand = _value(fallbackBrandKey, fallback: '');
    final fallbackShade = _value(fallbackCodeKey, fallback: '');

    if (fallbackBrand.isEmpty && fallbackShade.isEmpty) {
      return [];
    }

    return [
      {
        'brand': fallbackBrand,
        'product': '',
        'shade': fallbackShade,
      },
    ];
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

  int _matchScore(Map<String, dynamic> recommendation) {
    final value = recommendation['matchScore'];

    if (value is num) {
      return value.toInt().clamp(0, 100).toInt();
    }

    return int.tryParse(value?.toString() ?? '')?.clamp(0, 100).toInt() ?? 0;
  }

  Map<String, String> _storeLinks(Map<String, dynamic> recommendation) {
    final value = recommendation['storeLinks'];

    if (value is! Map) {
      return {};
    }

    return {
      for (final entry in value.entries)
        if (entry.key.toString().trim().isNotEmpty &&
            entry.value.toString().trim().isNotEmpty)
          entry.key.toString().trim().toLowerCase():
              entry.value.toString().trim(),
    };
  }

  String _priceText(Map<String, dynamic> recommendation) {
    final value = recommendation['averagePrice'];
    final price = value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '');

    if (price == null || price <= 0) {
      return _text(tr: 'Fiyat bilgisi yok', en: 'Price unavailable');
    }

    return _text(tr: 'Yaklaşık $price TL', en: 'Approx. $price TRY');
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
        return _text(tr: 'Premium', en: 'Premium');
      }

      if (value.contains('ekonomik') || value.contains('budget')) {
        return _text(tr: 'Ekonomik', en: 'Budget');
      }

      if (value.contains('orta') || value.contains('mid')) {
        return _text(tr: 'Orta Segment', en: 'Mid-range');
      }
    }

    return switch (index) {
      0 => _text(tr: 'Ana Öneri', en: 'Top Match'),
      1 => _text(tr: 'Alternatif', en: 'Alternative'),
      _ => _text(tr: 'Diğer Alternatif', en: 'Another Option'),
    };
  }

  Color _segmentColor(String segment) {
    final normalized = segment.toLowerCase();

    if (normalized.contains('premium')) {
      return const Color(0xFF7C3AED);
    }

    if (normalized.contains('ekonomik') || normalized.contains('budget')) {
      return const Color(0xFF059669);
    }

    if (normalized.contains('orta') || normalized.contains('mid')) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFFDB2777);
  }

  String _rankLabel(int index) {
    return switch (index) {
      0 => _text(tr: 'En güçlü eşleşme', en: 'Best match'),
      1 => _text(tr: 'İkinci seçenek', en: 'Second choice'),
      _ => _text(tr: 'Üçüncü seçenek', en: 'Third choice'),
    };
  }

  Future<void> _openStore(
    BuildContext context,
    String link,
  ) async {
    final uri = Uri.tryParse(link);

    if (uri == null) {
      _showMessage(
        context,
        _text(tr: 'Mağaza bağlantısı geçersiz.', en: 'Invalid store link.'),
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      _showMessage(
        context,
        _text(
          tr: 'Mağaza bağlantısı açılamadı.',
          en: 'The store link could not be opened.',
        ),
      );
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _recommendationCopyText(
    String categoryTitle,
    List<Map<String, dynamic>> recommendations,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(categoryTitle.toUpperCase());

    for (int index = 0; index < recommendations.length; index++) {
      final item = recommendations[index];
      final brand = _recommendationValue(item, 'brand');
      final product = _recommendationValue(item, 'product');
      final shade = _recommendationValue(item, 'shade');
      final score = _matchScore(item);
      final reason = _recommendationValue(item, 'matchReason');

      buffer.writeln('${index + 1}. $brand${product.isEmpty ? '' : ' - $product'}');
      buffer.writeln(
        '${_text(tr: 'Kod / Renk', en: 'Shade')}: $shade',
      );

      if (score > 0) {
        buffer.writeln('${_text(tr: 'Uyum', en: 'Match')}: %$score');
      }

      if (reason.isNotEmpty) {
        buffer.writeln('${_text(tr: 'Neden', en: 'Why')}: $reason');
      }

      buffer.writeln();
    }

    return buffer.toString();
  }

  String _buildCopyText() {
    final foundations = _recommendations(
      'foundationRecommendations',
      fallbackBrandKey: 'foundationBrand',
      fallbackCodeKey: 'foundationCode',
    );

    final concealers = _recommendations(
      'concealerRecommendations',
      fallbackBrandKey: 'concealerBrand',
      fallbackCodeKey: 'concealerCode',
    );

    final blushes = _recommendations(
      'blushRecommendations',
      fallbackBrandKey: 'blushBrand',
      fallbackCodeKey: 'blushCode',
    );

    final lipsticks = _recommendations(
      'lipstickRecommendations',
      fallbackBrandKey: 'lipstickBrand',
      fallbackCodeKey: 'lipstickCode',
    );

    return '''
GlowMatch AI

${_text(tr: 'Cilt Tonu', en: 'Skin Tone')}: ${_value('skinTone')}
${_text(tr: 'Alt Ton', en: 'Undertone')}: ${_value('undertone')}
${_text(tr: 'Cilt Tipi', en: 'Skin Type')}: ${_value('skinType')}
${_text(tr: 'Yüz Şekli', en: 'Face Shape')}: ${_value('faceShape')}
${_text(tr: 'Göz Rengi', en: 'Eye Color')}: ${_value('eyeColor')}
${_text(tr: 'Mevcut Saç Rengi', en: 'Current Hair Color')}: ${_value('hairColor')}

${_recommendationCopyText(_text(tr: 'Fondöten', en: 'Foundation'), foundations)}
${_recommendationCopyText(_text(tr: 'Kapatıcı', en: 'Concealer'), concealers)}
${_recommendationCopyText(_text(tr: 'Allık', en: 'Blush'), blushes)}
${_recommendationCopyText(_text(tr: 'Ruj', en: 'Lipstick'), lipsticks)}
${_text(tr: 'Saç Modeli', en: 'Hairstyle')}: ${_value('hairStyle')}
${_text(tr: 'Saç Rengi Önerisi', en: 'Hair Color Suggestion')}: ${_value('hairColorSuggestion')}

${_value('disclaimer')}
''';
  }

  Future<void> _copyAnalysis(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _buildCopyText()));

    if (!context.mounted) {
      return;
    }

    _showMessage(
      context,
      _text(
        tr: 'Analiz panoya kopyalandı.',
        en: 'Analysis copied to clipboard.',
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? const [
                  Color(0xFF2A1547),
                  Color(0xFF17101F),
                  Color(0xFF30122E),
                ]
              : const [
                  Color(0xFFF3E8FF),
                  Color(0xFFFFF1F7),
                  Color(0xFFEDE9FE),
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _text(
                        tr: 'Analizin hazır',
                        en: 'Your analysis is ready',
                      ),
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _text(
                        tr: 'Tonuna göre seçilen ürünler aşağıda.',
                        en: 'Products selected for your tone are below.',
                      ),
                      style: TextStyle(
                        color: _secondaryTextColor,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _summaryChip(
                icon: Icons.face_outlined,
                label: _text(tr: 'Cilt', en: 'Skin'),
                value: _value('skinTone'),
              ),
              _summaryChip(
                icon: Icons.wb_sunny_outlined,
                label: _text(tr: 'Alt ton', en: 'Undertone'),
                value: _value('undertone'),
              ),
              _summaryChip(
                icon: Icons.water_drop_outlined,
                label: _text(tr: 'Cilt tipi', en: 'Skin type'),
                value: _value('skinType'),
              ),
              _summaryChip(
                icon: Icons.crop_free,
                label: _text(tr: 'Yüz', en: 'Face'),
                value: _value('faceShape'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF7C3AED),
            size: 17,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF7C3AED), size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(
    BuildContext context, {
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

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading(
          icon: icon,
          title: title,
          subtitle: _text(
            tr: 'Uyum puanı, ürün özellikleri ve satış bağlantıları.',
            en: 'Match score, product details and store links.',
          ),
        ),
        for (int index = 0; index < recommendations.length; index++) ...[
          _buildRecommendationCard(
            context,
            index: index,
            recommendation: recommendations[index],
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAffordableFoundationSection(BuildContext context) {
    final value = result['affordableFoundationAlternatives'];

    if (value is! List || value.isEmpty) {
      return const SizedBox.shrink();
    }

    final alternatives = value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    if (alternatives.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading(
          icon: Icons.savings_outlined,
          title: _text(
            tr: 'Daha uygun fondötenler',
            en: 'More affordable foundations',
          ),
          subtitle: _text(
            tr: 'Ana öneriye yakın tonda, daha hesaplı seçenekler.',
            en: 'Lower-priced options close to the main recommendation.',
          ),
        ),
        for (int index = 0; index < alternatives.length; index++) ...[
          _buildRecommendationCard(
            context,
            index: index,
            recommendation: alternatives[index],
            affordable: true,
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required int index,
    required Map<String, dynamic> recommendation,
    bool affordable = false,
  }) {
    final brand = _recommendationValue(
      recommendation,
      'brand',
      fallback: _text(tr: 'Marka belirtilmedi', en: 'Brand unavailable'),
    );

    final product = _recommendationValue(recommendation, 'product');
    final shade = _recommendationValue(
      recommendation,
      'shade',
      fallback: _text(tr: 'Renk belirtilmedi', en: 'Shade unavailable'),
    );
    final finish = _recommendationValue(recommendation, 'finish');
    final coverage = _recommendationValue(recommendation, 'coverage');
    final matchReason = _recommendationValue(recommendation, 'matchReason');
    final score = _matchScore(recommendation);
    final vegan = _recommendationBool(recommendation, 'vegan');
    final crueltyFree = _recommendationBool(recommendation, 'crueltyFree');
    final storeLinks = _storeLinks(recommendation);
    final segment = affordable
        ? _text(tr: 'Uygun Alternatif', en: 'Budget Alternative')
        : _priceSegmentText(recommendation, index);
    final accent = affordable ? const Color(0xFF059669) : _segmentColor(segment);

    final skinTypesValue = recommendation['skinTypes'];
    final skinTypes = skinTypesValue is List
        ? skinTypesValue
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .join(', ')
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.18 : 0.045),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: accent,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rankLabel(index),
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      brand,
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (product.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product,
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  segment,
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDarkMode ? 0.10 : 0.055),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Icon(Icons.colorize, color: accent, size: 20),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '${_text(tr: 'Kod / Renk', en: 'Shade')}: $shade',
                    style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  _priceText(recommendation),
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (score > 0) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _text(tr: 'GlowMatch uyumu', en: 'GlowMatch score'),
                    style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '%$score',
                  style: TextStyle(
                    color: accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 8,
                backgroundColor: accent.withValues(alpha: 0.10),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ],
          if (matchReason.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.035)
                    : const Color(0xFFFAF8FC),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: accent,
                    size: 19,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      matchReason,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
              spacing: 7,
              runSpacing: 7,
              children: [
                if (finish.isNotEmpty)
                  _featureChip(
                    icon: Icons.auto_awesome,
                    label: '${_text(tr: 'Bitiş', en: 'Finish')}: $finish',
                  ),
                if (coverage.isNotEmpty)
                  _featureChip(
                    icon: Icons.layers_outlined,
                    label:
                        '${_text(tr: 'Kapatıcılık', en: 'Coverage')}: $coverage',
                  ),
                if (skinTypes.isNotEmpty)
                  _featureChip(
                    icon: Icons.water_drop_outlined,
                    label: skinTypes,
                  ),
                if (vegan)
                  _featureChip(
                    icon: Icons.eco_outlined,
                    label: _text(tr: 'Vegan', en: 'Vegan'),
                  ),
                if (crueltyFree)
                  _featureChip(
                    icon: Icons.pets_outlined,
                    label: _text(tr: 'Hayvan dostu', en: 'Cruelty free'),
                  ),
              ],
            ),
          ],
          if (storeLinks.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              _text(tr: 'Mağazada görüntüle', en: 'View in store'),
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in storeLinks.entries)
                  OutlinedButton.icon(
                    onPressed: () => _openStore(context, entry.value),
                    icon: const Icon(Icons.open_in_new, size: 17),
                    label: Text(entry.key),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accent,
                      side: BorderSide(color: accent.withValues(alpha: 0.35)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _featureChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.045)
            : const Color(0xFFF8F5FA),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF7C3AED), size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading(
          icon: Icons.content_cut,
          title: _text(tr: 'Saç önerileri', en: 'Hair suggestions'),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            children: [
              _hairRow(
                icon: Icons.face_retouching_natural,
                title: _text(tr: 'Saç modeli', en: 'Hairstyle'),
                value: _value('hairStyle'),
              ),
              Divider(height: 27, color: _borderColor),
              _hairRow(
                icon: Icons.color_lens_outlined,
                title: _text(tr: 'Saç rengi', en: 'Hair color'),
                value: _value('hairColorSuggestion'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hairRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFDB2777).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: const Color(0xFFDB2777), size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFFF59E0B),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _value('disclaimer'),
              style: TextStyle(
                color: _secondaryTextColor,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: _primaryTextColor),
        ),
        title: Text(
          _text(tr: 'Analiz Sonucu', en: 'Analysis Result'),
          style: TextStyle(
            color: _primaryTextColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _text(tr: 'Analizi kopyala', en: 'Copy analysis'),
            onPressed: () => _copyAnalysis(context),
            icon: Icon(Icons.copy_all_outlined, color: _primaryTextColor),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            _buildHero(),
            const SizedBox(height: 28),
            _buildRecommendationSection(
              context,
              title: _text(tr: 'Fondöten', en: 'Foundation'),
              icon: Icons.brush_outlined,
              recommendationsKey: 'foundationRecommendations',
              fallbackBrandKey: 'foundationBrand',
              fallbackCodeKey: 'foundationCode',
            ),
            _buildAffordableFoundationSection(context),
            _buildRecommendationSection(
              context,
              title: _text(tr: 'Kapatıcı', en: 'Concealer'),
              icon: Icons.opacity_outlined,
              recommendationsKey: 'concealerRecommendations',
              fallbackBrandKey: 'concealerBrand',
              fallbackCodeKey: 'concealerCode',
            ),
            _buildRecommendationSection(
              context,
              title: _text(tr: 'Allık', en: 'Blush'),
              icon: Icons.palette_outlined,
              recommendationsKey: 'blushRecommendations',
              fallbackBrandKey: 'blushBrand',
              fallbackCodeKey: 'blushCode',
            ),
            _buildRecommendationSection(
              context,
              title: _text(tr: 'Ruj', en: 'Lipstick'),
              icon: Icons.favorite_outline,
              recommendationsKey: 'lipstickRecommendations',
              fallbackBrandKey: 'lipstickBrand',
              fallbackCodeKey: 'lipstickCode',
            ),
            _buildHairSection(),
            const SizedBox(height: 18),
            _buildDisclaimer(),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _copyAnalysis(context),
                icon: const Icon(Icons.copy_all_outlined),
                label: Text(
                  _text(tr: 'Analizi Kopyala', en: 'Copy Analysis'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh),
                label: Text(
                  _text(tr: 'Yeni Analiz Yap', en: 'Start New Analysis'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7C3AED),
                  side: BorderSide(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.32),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
