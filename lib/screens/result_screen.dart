import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/product_link_service.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  String _value(String key) {
    final value = result[key];

    if (value == null || value.toString().trim().isEmpty) {
      return 'Belirsiz';
    }

    return value.toString().trim();
  }

  String _itemValue(
    Map<String, dynamic> item,
    String key, {
    String fallback = '',
  }) {
    final value = item[key];

    if (value == null || value.toString().trim().isEmpty) {
      return fallback;
    }

    return value.toString().trim();
  }

  bool _itemBool(Map<String, dynamic> item, String key) {
    final value = item[key];

    if (value is bool) {
      return value;
    }

    return value?.toString().toLowerCase() == 'true';
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

    return [
      {
        'brand': _value(fallbackBrandKey),
        'product': '',
        'shade': _value(fallbackCodeKey),
      },
    ];
  }

  int _matchScore(Map<String, dynamic> item) {
    final value = item['matchScore'];

    if (value is num) {
      return value.toInt().clamp(0, 100);
    }

    return (int.tryParse(value?.toString() ?? '') ?? 0).clamp(0, 100);
  }

  List<String> _matchReasons(Map<String, dynamic> item) {
    final reason = _itemValue(
      item,
      'matchReason',
      fallback: 'Genel ürün özelliklerine göre önerildi',
    );

    return reason
        .split(',')
        .map((text) => text.trim())
        .where((text) => text.isNotEmpty)
        .map((text) => '${text[0].toUpperCase()}${text.substring(1)}')
        .toList();
  }

  Color _matchScoreColor(int score) {
    if (score >= 85) {
      return Colors.green;
    }

    if (score >= 70) {
      return Colors.orange;
    }

    if (score > 0) {
      return Colors.deepOrange;
    }

    return Colors.grey;
  }

  String _priceText(Map<String, dynamic> item) {
    final value = item['averagePrice'];

    final price = value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '');

    if (price == null || price <= 0) {
      return 'Fiyat bilgisi yok';
    }

    return 'Yaklaşık $price TL';
  }

  String _priceSegment(Map<String, dynamic> item, int index) {
    final value = item['priceSegment']?.toString().trim().toLowerCase();

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

  Color _segmentColor(String segment) {
    return switch (segment) {
      'Premium' => Colors.deepPurple,
      'Ekonomik' => Colors.green,
      'Orta Segment' => Colors.orange,
      _ => Colors.pink,
    };
  }

  List<String> _storeNames(Map<String, dynamic> item) {
    final value = item['stores'];

    if (value is! List) {
      return const [];
    }

    final stores = <String>[];

    for (final rawStore in value) {
      final store = rawStore.toString().trim().toLowerCase();

      if (store.isEmpty || store == 'google' || stores.contains(store)) {
        continue;
      }

      stores.add(store);
    }

    return stores;
  }

  Map<String, String> _storeLinks(Map<String, dynamic> item) {
    final value = item['storeLinks'];

    if (value is! Map) {
      return const {};
    }

    return value.map(
      (key, link) =>
          MapEntry(key.toString().trim().toLowerCase(), link.toString().trim()),
    );
  }

  String _storeTitle(String store) {
    return switch (store) {
      'trendyol' => 'Trendyol’da İncele',
      'gratis' => 'Gratis’te İncele',
      'watsons' => 'Watsons’ta İncele',
      'sephora' => 'Sephora’da İncele',
      'boyner' => 'Boyner’de İncele',
      'amazon' => 'Amazon’da İncele',
      'official' => 'Resmî Mağazada İncele',
      _ => 'Mağazada İncele',
    };
  }

  IconData _storeIcon(String store) {
    return switch (store) {
      'trendyol' => Icons.shopping_bag_outlined,
      'gratis' => Icons.store_mall_directory_outlined,
      'watsons' => Icons.shopping_cart_outlined,
      'sephora' => Icons.diamond_outlined,
      'boyner' => Icons.local_mall_outlined,
      'amazon' => Icons.inventory_2_outlined,
      'official' => Icons.verified_outlined,
      _ => Icons.storefront_outlined,
    };
  }

  String _storeSubtitle(String store, String? directLink) {
    if (directLink != null && directLink.trim().isNotEmpty) {
      return 'Doğrudan ürün sayfasını aç';
    }

    return switch (store) {
      'trendyol' => 'Trendyol’da ürün adı ve renk koduyla ara',
      'gratis' => 'Gratis sonuçlarında ürünü ara',
      'watsons' => 'Watsons sonuçlarında ürünü ara',
      'sephora' => 'Sephora sonuçlarında ürünü ara',
      'boyner' => 'Boyner sonuçlarında ürünü ara',
      'amazon' => 'Amazon Türkiye’de ürünü ara',
      'official' => 'Markanın resmî satış sayfasını aç',
      _ => 'Ürünü bu mağazada ara',
    };
  }

  Future<void> _openStore({
    required BuildContext sheetContext,
    required BuildContext pageContext,
    required String store,
    required String brand,
    required String product,
    required String shade,
    String? directLink,
  }) async {
    Navigator.pop(sheetContext);

    final opened = await ProductLinkService.openStore(
      store: store,
      brand: brand,
      product: product,
      shade: shade,
      directLink: directLink,
    );

    if (!pageContext.mounted || opened) {
      return;
    }

    ScaffoldMessenger.of(pageContext)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${_storeTitle(store)} bağlantısı açılamadı.')),
      );
  }

  Future<void> _showProductStores({
    required BuildContext context,
    required Map<String, dynamic> item,
    required String brand,
    required String product,
    required String shade,
  }) async {
    final stores = _storeNames(item);
    final links = _storeLinks(item);

    final title = [
      brand,
      product,
      shade,
    ].where((text) => text.trim().isNotEmpty).join(' ');

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.deepPurple,
                        size: 27,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Ürünü Nerede İncelemek İstersin?',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (stores.isEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Text(
                        'Bu ürün için doğrulanmış mağaza henüz eklenmedi. Google üzerinden farklı satıcıları arayabilirsin.',
                        style: TextStyle(fontSize: 13, height: 1.35),
                      ),
                    ),
                  for (final store in stores) ...[
                    _storeButton(
                      icon: _storeIcon(store),
                      title: _storeTitle(store),
                      subtitle: _storeSubtitle(store, links[store]),
                      onTap: () {
                        _openStore(
                          sheetContext: sheetContext,
                          pageContext: context,
                          store: store,
                          brand: brand,
                          product: product,
                          shade: shade,
                          directLink: links[store],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  _storeButton(
                    icon: Icons.search,
                    title: 'Google’da Ara',
                    subtitle: 'Diğer mağaza ve fiyat seçeneklerini gör',
                    onTap: () {
                      _openStore(
                        sheetContext: sheetContext,
                        pageContext: context,
                        store: 'google',
                        brand: brand,
                        product: product,
                        shade: shade,
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('Vazgeç'),
                    ),
                  ),
                  Text(
                    'Fiyat ve stok durumu mağazaya göre değişebilir. Satın almadan önce ürün adını ve renk kodunu kontrol et.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _storeButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: Colors.deepPurple),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, size: 20, color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  String _recommendationText(String title, String key) {
    final items = _recommendations(
      key,
      fallbackBrandKey: '${title}Brand',
      fallbackCodeKey: '${title}Code',
    );

    final buffer = StringBuffer();

    for (int index = 0; index < items.length; index++) {
      final item = items[index];

      final label = switch (index) {
        0 => 'En Uygun',
        1 => 'Alternatif 1',
        _ => 'Alternatif 2',
      };

      buffer.writeln(label);

      buffer.writeln('${item['brand'] ?? ''} — ${item['product'] ?? ''}');

      buffer.writeln('Kod / Renk: ${item['shade'] ?? ''}');

      buffer.writeln('Fiyat: ${_priceText(item)}');

      buffer.writeln('Fiyat Kategorisi: ${_priceSegment(item, index)}');

      final score = _matchScore(item);

      if (score > 0) {
        buffer.writeln('Uyum: %$score');
      }

      buffer.writeln(
        'Öneri nedeni: ${_itemValue(item, 'matchReason', fallback: 'Genel ürün özelliklerine göre önerildi')}',
      );

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
    await Clipboard.setData(ClipboardData(text: _buildCopyText()));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Analiz panoya kopyalandı.')),
      );
  }

  Future<void> _selectAllAnalysis(BuildContext context) async {
    final controller = TextEditingController(text: _buildCopyText());

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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Kapat'),
            ),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: controller.text));

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
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

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: SelectableText(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: SelectableText(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _analysisDetails() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: const Icon(
          Icons.face_retouching_natural,
          color: Colors.deepPurple,
        ),
        title: const Text(
          'Yüz Analizi Detayları',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Cilt tonu, alt ton ve diğer analizleri görüntüle',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _infoCard(
            icon: Icons.face,
            title: 'Cilt Tonu',
            value: _value('skinTone'),
          ),
          _infoCard(
            icon: Icons.wb_sunny_outlined,
            title: 'Alt Ton',
            value: _value('undertone'),
          ),
          _infoCard(
            icon: Icons.water_drop_outlined,
            title: 'Cilt Tipi',
            value: _value('skinType'),
          ),
          _infoCard(
            icon: Icons.crop_square,
            title: 'Yüz Şekli',
            value: _value('faceShape'),
          ),
          _infoCard(
            icon: Icons.remove_red_eye_outlined,
            title: 'Göz Rengi',
            value: _value('eyeColor'),
          ),
          _infoCard(
            icon: Icons.content_cut,
            title: 'Mevcut Saç Rengi',
            value: _value('hairColor'),
          ),
        ],
      ),
    );
  }

  Widget _featureChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepPurple),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBadge(int score) {
    if (score <= 0) {
      return const SizedBox.shrink();
    }

    final color = _matchScoreColor(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 16, color: color),
          const SizedBox(width: 5),
          Text(
            '%$score Uyumlu',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonBox(List<String> reasons) {
    if (reasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: Colors.deepPurple),
              SizedBox(width: 7),
              Text(
                'Neden önerildi?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          for (int index = 0; index < reasons.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 17,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: SelectableText(
                    reasons[index],
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            if (index != reasons.length - 1) const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }

  Widget _recommendationItem({
    required BuildContext context,
    required int index,
    required Map<String, dynamic> item,
  }) {
    final medal = switch (index) {
      0 => '🥇',
      1 => '🥈',
      _ => '🥉',
    };

    final brand = _itemValue(item, 'brand', fallback: 'Marka belirtilmedi');

    final product = _itemValue(item, 'product');

    final shade = _itemValue(item, 'shade', fallback: 'Renk belirtilmedi');

    final finish = _itemValue(item, 'finish');

    final coverage = _itemValue(item, 'coverage');

    final shadeFamily = _itemValue(item, 'shadeFamily');

    final vegan = _itemBool(item, 'vegan');

    final crueltyFree = _itemBool(item, 'crueltyFree');

    final score = _matchScore(item);

    final reasons = _matchReasons(item);

    final segment = _priceSegment(item, index);

    final segmentColor = _segmentColor(segment);

    final skinTypesValue = item['skinTypes'];

    final skinTypes = skinTypesValue is List
        ? skinTypesValue
              .map((value) => value.toString().trim())
              .where((value) => value.isNotEmpty)
              .join(', ')
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: segmentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: segmentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: segmentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$medal $segment',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: segmentColor,
                  ),
                ),
              ),
              _scoreBadge(score),
            ],
          ),
          const SizedBox(height: 13),
          SelectableText(
            brand,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.colorize, size: 20, color: Colors.pink),
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
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 20,
                      color: segmentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SelectableText(
                        _priceText(item),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: segmentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (shadeFamily.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText(
              'Renk ailesi: $shadeFamily',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
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
                  _featureChip(
                    icon: Icons.auto_awesome,
                    label: 'Bitiş: $finish',
                  ),
                if (coverage.isNotEmpty)
                  _featureChip(
                    icon: Icons.layers_outlined,
                    label: 'Kapatıcılık: $coverage',
                  ),
                if (skinTypes.isNotEmpty)
                  _featureChip(
                    icon: Icons.water_drop_outlined,
                    label: skinTypes,
                  ),
                if (vegan)
                  _featureChip(icon: Icons.eco_outlined, label: 'Vegan'),
                if (crueltyFree)
                  _featureChip(
                    icon: Icons.pets_outlined,
                    label: 'Cruelty Free',
                  ),
              ],
            ),
          ],
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: 14),
            _reasonBox(reasons),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 49,
            child: FilledButton.icon(
              onPressed: () {
                _showProductStores(
                  context: context,
                  item: item,
                  brand: brand,
                  product: product,
                  shade: shade,
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text(
                'Ürünü İncele',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String recommendationsKey,
    required String fallbackBrandKey,
    required String fallbackCodeKey,
  }) {
    final items = _recommendations(
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
                Icon(icon, color: Colors.pink, size: 28),
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
            for (int index = 0; index < items.length; index++) ...[
              _recommendationItem(
                context: context,
                index: index,
                item: items[index],
              ),
              if (index != items.length - 1) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  Widget _affordableFoundationSection(BuildContext context) {
    final value = result['affordableFoundationAlternatives'];

    if (value is! List || value.isEmpty) {
      return const SizedBox.shrink();
    }

    final items = value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    if (items.isEmpty) {
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
                Icon(Icons.savings_outlined, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    'Aynı Tonda Daha Uygun Alternatifler',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ana fondöten önerisine yakın, daha ekonomik seçenekler.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            for (int index = 0; index < items.length; index++) ...[
              _recommendationItem(
                context: context,
                index: index,
                item: items[index],
              ),
              if (index != items.length - 1) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 21),
          tooltip: 'Geri',
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 22),
            SizedBox(width: 8),
            Text(
              'GlowMatch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.20),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 17,
                    color: Color(0xFF16A34A),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Tamamlandı',
                    style: TextStyle(
                      color: Color(0xFF15803D),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 15),
            const SelectableText(
              'GlowMatch AI Sonucu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Yüz analizine göre kişiselleştirilmiş ürün önerilerin hazır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            _analysisDetails(),
            const SelectableText(
              'Önerilen Makyaj Ürünleri',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _recommendationSection(
              context: context,
              title: 'Fondöten',
              icon: Icons.brush,
              recommendationsKey: 'foundationRecommendations',
              fallbackBrandKey: 'foundationBrand',
              fallbackCodeKey: 'foundationCode',
            ),
            _affordableFoundationSection(context),
            _recommendationSection(
              context: context,
              title: 'Kapatıcı',
              icon: Icons.opacity,
              recommendationsKey: 'concealerRecommendations',
              fallbackBrandKey: 'concealerBrand',
              fallbackCodeKey: 'concealerCode',
            ),
            _recommendationSection(
              context: context,
              title: 'Allık',
              icon: Icons.palette_outlined,
              recommendationsKey: 'blushRecommendations',
              fallbackBrandKey: 'blushBrand',
              fallbackCodeKey: 'blushCode',
            ),
            _recommendationSection(
              context: context,
              title: 'Ruj',
              icon: Icons.favorite_outline,
              recommendationsKey: 'lipstickRecommendations',
              fallbackBrandKey: 'lipstickBrand',
              fallbackCodeKey: 'lipstickCode',
            ),
            const SizedBox(height: 10),
            const SelectableText(
              'Saç Önerileri',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _infoCard(
              icon: Icons.face_retouching_natural,
              title: 'Saç Modeli',
              value: _value('hairStyle'),
            ),
            _infoCard(
              icon: Icons.color_lens_outlined,
              title: 'Saç Rengi Önerisi',
              value: _value('hairColorSuggestion'),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SelectableText(
                        _value('disclaimer'),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
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
                onPressed: () => Navigator.pop(context),
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
