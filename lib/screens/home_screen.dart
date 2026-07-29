import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';
import '../services/image_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageService _imageService = ImageService();
  final AIService _aiService = AIService();

  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isDarkMode = false;

  String _selectedLanguage = 'tr';
  int _selectedTab = 0;

  bool get _isTurkish => _selectedLanguage == 'tr';

  Color get _backgroundColor =>
      _isDarkMode ? const Color(0xFF08070D) : const Color(0xFFFFF8FC);

  Color get _cardColor => _isDarkMode ? const Color(0xFF17131F) : Colors.white;

  Color get _primaryTextColor =>
      _isDarkMode ? const Color(0xFFF9F6FF) : const Color(0xFF21143D);

  Color get _secondaryTextColor =>
      _isDarkMode ? const Color(0xFFB9B0C7) : const Color(0xFF6F647A);

  Color get _borderColor =>
      _isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.grey.shade200;

  String _text({required String tr, required String en}) {
    return _isTurkish ? tr : en;
  }

  Future<void> _pickFromCamera() async {
    final image = await _imageService.pickFromCamera();
    await _setSelectedImageAndAnalyze(image);
  }

  Future<void> _pickFromGallery() async {
    final image = await _imageService.pickFromGallery();
    await _setSelectedImageAndAnalyze(image);
  }

  Future<void> _setSelectedImageAndAnalyze(XFile? image) async {
    if (image == null || _isLoading) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });

    await _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    final image = _selectedImage;

    if (image == null || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _aiService.analyzeFace(image);

      if (!mounted) {
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      );
    } on AIServiceException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _text(
          tr: 'Beklenmeyen hata oluştu: $error',
          en: 'An unexpected error occurred: $error',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _showSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void updateDarkMode(bool value) {
              setState(() {
                _isDarkMode = value;
              });

              setSheetState(() {});
            }

            void updateLanguage(String value) {
              setState(() {
                _selectedLanguage = value;
              });

              setSheetState(() {});
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    20 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _text(tr: 'Ayarlar', en: 'Settings'),
                                  style: TextStyle(
                                    color: _primaryTextColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _text(
                                    tr: 'GlowMatch deneyimini kişiselleştir.',
                                    en: 'Personalize your GlowMatch experience.',
                                  ),
                                  style: TextStyle(
                                    color: _secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _settingsSectionTitle(
                        _text(tr: 'Görünüm', en: 'Appearance'),
                      ),
                      const SizedBox(height: 9),
                      _settingsContainer(
                        child: _settingsSwitchTile(
                          icon: _isDarkMode
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          title: _text(tr: 'Karanlık Mod', en: 'Dark Mode'),
                          subtitle: _isDarkMode
                              ? _text(
                                  tr: 'Karanlık görünüm açık',
                                  en: 'Dark appearance is enabled',
                                )
                              : _text(
                                  tr: 'Aydınlık görünüm açık',
                                  en: 'Light appearance is enabled',
                                ),
                          value: _isDarkMode,
                          onChanged: updateDarkMode,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _settingsSectionTitle(_text(tr: 'Dil', en: 'Language')),
                      const SizedBox(height: 9),
                      _settingsContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              _settingsIcon(Icons.language_outlined),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _text(
                                        tr: 'Uygulama Dili',
                                        en: 'Application Language',
                                      ),
                                      style: TextStyle(
                                        color: _primaryTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _text(
                                        tr: 'Arayüzde kullanılacak dili seç.',
                                        en: 'Choose the interface language.',
                                      ),
                                      style: TextStyle(
                                        color: _secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedLanguage,
                                  dropdownColor: _cardColor,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: _primaryTextColor,
                                  ),
                                  style: TextStyle(
                                    color: _primaryTextColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'tr',
                                      child: Text('Türkçe'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'en',
                                      child: Text('English'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      updateLanguage(value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _settingsSectionTitle(
                        _text(tr: 'Uygulama', en: 'Application'),
                      ),
                      const SizedBox(height: 9),
                      _settingsContainer(
                        child: Column(
                          children: [
                            _settingsActionTile(
                              icon: Icons.star_outline,
                              title: _text(
                                tr: 'Uygulamayı Değerlendir',
                                en: 'Rate the App',
                              ),
                              subtitle: _text(
                                tr: 'GlowMatch için yorum bırak.',
                                en: 'Leave a review for GlowMatch.',
                              ),
                              onTap: () {
                                _showMessage(
                                  _text(
                                    tr: 'Değerlendirme özelliği Play Store sürümünde açılacak.',
                                    en: 'Rating will be available in the Play Store version.',
                                  ),
                                );
                              },
                            ),
                            _settingsDivider(),
                            _settingsActionTile(
                              icon: Icons.privacy_tip_outlined,
                              title: _text(
                                tr: 'Gizlilik Politikası',
                                en: 'Privacy Policy',
                              ),
                              subtitle: _text(
                                tr: 'Verilerin nasıl kullanıldığını incele.',
                                en: 'Review how your data is used.',
                              ),
                              onTap: () {
                                _showInformationDialog(
                                  title: _text(
                                    tr: 'Gizlilik Politikası',
                                    en: 'Privacy Policy',
                                  ),
                                  message: _text(
                                    tr: 'GlowMatch, seçtiğin fotoğrafı yalnızca kişiselleştirilmiş analiz oluşturmak için kullanır. Play Store yayını öncesinde ayrıntılı gizlilik politikası bu bölüme eklenecektir.',
                                    en: 'GlowMatch uses your selected photo only to create a personalized analysis. A detailed privacy policy will be added before the Play Store release.',
                                  ),
                                );
                              },
                            ),
                            _settingsDivider(),
                            _settingsActionTile(
                              icon: Icons.info_outline,
                              title: _text(
                                tr: 'GlowMatch Hakkında',
                                en: 'About GlowMatch',
                              ),
                              subtitle: 'GlowMatch AI • Beta v0.5',
                              onTap: () {
                                _showInformationDialog(
                                  title: _text(
                                    tr: 'GlowMatch Hakkında',
                                    en: 'About GlowMatch',
                                  ),
                                  message: _text(
                                    tr: 'GlowMatch, yüz ve cilt tonu analizine göre kişiselleştirilmiş makyaj ürünü önerileri sunan yapay zekâ destekli bir güzellik asistanıdır.',
                                    en: 'GlowMatch is an AI-powered beauty assistant that provides personalized makeup recommendations based on facial and skin tone analysis.',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7C3AED),
                            side: BorderSide(
                              color: const Color(
                                0xFF7C3AED,
                              ).withValues(alpha: 0.30),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            _text(tr: 'Kapat', en: 'Close'),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showInformationDialog({
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text(
            title,
            style: TextStyle(
              color: _primaryTextColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: _secondaryTextColor, height: 1.5),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
              ),
              child: Text(_text(tr: 'Tamam', en: 'OK')),
            ),
          ],
        );
      },
    );
  }

  Widget _settingsSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _settingsContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.white.withValues(alpha: 0.035)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: child,
    );
  }

  Widget _settingsSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 8, 10),
      child: Row(
        children: [
          _settingsIcon(icon),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: _secondaryTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFF7C3AED),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _settingsActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              _settingsIcon(icon),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: _secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsIcon(IconData icon) {
    return Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: const Color(0xFF7C3AED), size: 21),
    );
  }

  Widget _settingsDivider() {
    return Divider(height: 1, indent: 69, color: _borderColor);
  }

  Widget _buildSettingsButton() {
    return Material(
      color: _isDarkMode ? Colors.white.withValues(alpha: 0.07) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _showSettings,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor),
          ),
          child: Icon(
            Icons.settings_outlined,
            color: _primaryTextColor,
            size: 21,
          ),
        ),
      ),
    );
  }

  Future<void> _showPhotoSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: _borderColor),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _secondaryTextColor.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _text(
                    tr: 'Fotoğraf kaynağını seç',
                    en: 'Choose a photo source',
                  ),
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _sourceButton(
                        icon: Icons.camera_alt_outlined,
                        title: _text(tr: 'Kamera', en: 'Camera'),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickFromCamera();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sourceButton(
                        icon: Icons.photo_library_outlined,
                        title: _text(tr: 'Galeri', en: 'Gallery'),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickFromGallery();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF8B5CF6), size: 30),
              const SizedBox(height: 9),
              Text(
                title,
                style: TextStyle(
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandMark() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/branding/glowmatch_icon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeroDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 194,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 20,
                width: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF5B21B6),
                          Color(0xFFD946EF),
                          Color(0xFFEC4899),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        _text(
                          tr: 'Kendi tonunu\nkeşfet',
                          en: 'Discover your\nperfect tone',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'serif',
                          fontSize: 35,
                          height: 0.96,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      _text(
                        tr: 'Cildine en uygun makyajı bul,\nher gün ışılda.',
                        en: 'Find makeup made for your skin,\nand glow every day.',
                      ),
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -4,
                top: 2,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY(-0.12)
                    ..rotateX(0.05),
                  child: Container(
                    width: 166,
                    height: 166,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(42),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isDarkMode
                            ? const [
                                Color(0xFF5B21B6),
                                Color(0xFF241036),
                                Color(0xFF12071D),
                              ]
                            : const [
                                Color(0xFFF8E8FF),
                                Color(0xFFD8B4FE),
                                Color(0xFFF9A8D4),
                              ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: _isDarkMode ? 0.18 : 0.55,
                        ),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: _isDarkMode ? 0.56 : 0.20,
                          ),
                          blurRadius: 24,
                          offset: const Offset(13, 18),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFFD946EF,
                          ).withValues(alpha: _isDarkMode ? 0.42 : 0.27),
                          blurRadius: 36,
                          spreadRadius: 2,
                          offset: const Offset(-8, -7),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: _isDarkMode ? 0.10 : 0.65,
                          ),
                          blurRadius: 12,
                          offset: const Offset(-7, -8),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: _isDarkMode ? 0.30 : 0.13,
                            ),
                            blurRadius: 12,
                            offset: const Offset(5, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34),
                        child: Image.asset(
                          'assets/branding/glowmatch_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _premiumActionCard(
          icon: Icons.camera_alt_outlined,
          title: _text(tr: 'Cildimi Analiz Et', en: 'Analyze My Skin'),
          subtitle: _text(
            tr: 'Fotoğraftan sana özel\ntonları keşfet',
            en: 'Discover tones made for you\nfrom a photo',
          ),
          onTap: _showPhotoSourceSheet,
          accent: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 12),
        _premiumActionCard(
          icon: Icons.colorize_outlined,
          title: _text(tr: 'Tonumu Dönüştür', en: 'Convert My Shade'),
          subtitle: _text(
            tr: 'Kullandığın fondöteni\nbaşka markalarda bul',
            en: 'Find your foundation shade\nin other brands',
          ),
          onTap: () {
            _showMessage(
              _text(
                tr: 'Ton dönüştürme özelliği yakında açılacak.',
                en: 'Shade conversion is coming soon.',
              ),
            );
          },
          accent: const Color(0xFFD946EF),
        ),
        const SizedBox(height: 12),
        _premiumActionCard(
          icon: Icons.folder_special_outlined,
          title: _text(tr: 'Kayıtlı Görünümlerim', en: 'Saved Looks'),
          subtitle: _text(
            tr: 'Geçmiş analizlerini ve\nfavorilerini incele',
            en: 'Review previous analyses\nand favorites',
          ),
          onTap: () {
            _showMessage(
              _text(
                tr: 'Kayıtlı görünümler bölümü yakında açılacak.',
                en: 'Saved looks are coming soon.',
              ),
            );
          },
          accent: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _premiumActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accent,
  }) {
    final cardColor = _isDarkMode
        ? const Color(0xFF17131F).withValues(alpha: 0.96)
        : Colors.white.withValues(alpha: 0.92);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          height: 104,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _isDarkMode
                  ? accent.withValues(alpha: 0.46)
                  : const Color(0xFFE7D9F7),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isDarkMode ? 0.38 : 0.10,
                ),
                blurRadius: 18,
                offset: const Offset(7, 11),
              ),
              BoxShadow(
                color: Colors.white.withValues(
                  alpha: _isDarkMode ? 0.035 : 0.72,
                ),
                blurRadius: 10,
                offset: const Offset(-5, -6),
              ),
              BoxShadow(
                color: _isDarkMode
                    ? accent.withValues(alpha: 0.20)
                    : const Color(0xFFD8B4FE).withValues(alpha: 0.22),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? accent.withValues(alpha: 0.13)
                      : const Color(0xFFF4EAFF),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: accent.withValues(alpha: _isDarkMode ? 0.58 : 0.22),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(
                        alpha: _isDarkMode ? 0.28 : 0.13,
                      ),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Icon(icon, color: accent, size: 29),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 12.4,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                  border: Border.all(color: accent.withValues(alpha: 0.18)),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: accent,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyRecommendation() {
    return Container(
      width: double.infinity,
      height: 154,
      padding: const EdgeInsets.fromLTRB(17, 15, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDarkMode
              ? const [Color(0xFF3B1F2B), Color(0xFF17131F)]
              : const [Color(0xFFFFF8FB), Color(0xFFFFEDF5)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isDarkMode
              ? const Color(0xFFF472B6).withValues(alpha: 0.48)
              : const Color(0xFFF8C9DF),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFEC4899,
            ).withValues(alpha: _isDarkMode ? 0.16 : 0.09),
            blurRadius: 24,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEC4899).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: Color(0xFFEC4899),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _text(tr: 'Bugünün Önerisi', en: 'Today’s Pick'),
                    style: const TextStyle(
                      color: Color(0xFFDB2777),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text(tr: 'Sana Özel Ton', en: 'Your Perfect Shade'),
                  style: TextStyle(color: _secondaryTextColor, fontSize: 11.5),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nude Beige 23',
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontFamily: 'serif',
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _text(tr: 'Nötr alt ton', en: 'Neutral undertone'),
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 32,
            child: Transform.rotate(
              angle: -0.12,
              child: Container(
                width: 132,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF2C39B),
                      Color(0xFFE9A978),
                      Color(0xFFD88F60),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(42),
                    bottomLeft: Radius.circular(42),
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(22),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE9A978).withValues(alpha: 0.30),
                      blurRadius: 17,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 4,
            child: Container(
              width: 70,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDarkMode
                    ? const Color(0xFF3A2638)
                    : const Color(0xFFFFF2E7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFF3C4D7).withValues(alpha: 0.45),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '%92',
                    style: TextStyle(
                      color: _isDarkMode
                          ? const Color(0xFFF9A8D4)
                          : const Color(0xFFBE185D),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    _text(tr: 'UYUMLULUK', en: 'MATCH'),
                    style: TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: _isDarkMode
              ? const Color(0xFF15121D).withValues(alpha: 0.98)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isDarkMode
                ? const Color(0xFF6D4A7E)
                : const Color(0xFFE8DDF1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isDarkMode ? 0.32 : 0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _navItem(
              index: 0,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: _text(tr: 'Ana Sayfa', en: 'Home'),
            ),
            _navItem(
              index: 1,
              icon: Icons.bar_chart_outlined,
              selectedIcon: Icons.bar_chart_rounded,
              label: _text(tr: 'Analizlerim', en: 'Analyses'),
            ),
            _navItem(
              index: 2,
              icon: Icons.favorite_border_rounded,
              selectedIcon: Icons.favorite_rounded,
              label: _text(tr: 'Favoriler', en: 'Favorites'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final selected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
          if (index != 0) {
            _showMessage(
              index == 1
                  ? _text(
                      tr: 'Analizlerim bölümü yakında açılacak.',
                      en: 'Analyses are coming soon.',
                    )
                  : _text(
                      tr: 'Favoriler bölümü yakında açılacak.',
                      en: 'Favorites are coming soon.',
                    ),
            );
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? selectedIcon : icon,
              color: selected ? const Color(0xFFD946EF) : _secondaryTextColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFFD946EF) : _secondaryTextColor,
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = _isDarkMode
        ? const [Color(0xFF06050A), Color(0xFF0D0913), Color(0xFF09070D)]
        : const [Color(0xFFFFFBFD), Color(0xFFFFF5FB), Color(0xFFF8F1FF)];

    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 18,
        toolbarHeight: 70,
        title: Row(
          children: [
            _buildBrandMark(),
            const SizedBox(width: 10),
            Text(
              'GlowMatch',
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Center(child: _buildSettingsButton()),
          const SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundGradient,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -110,
              child: _ambientGlow(const Color(0xFFB76EFF), 245),
            ),
            Positioned(
              top: 260,
              left: -130,
              child: _ambientGlow(const Color(0xFFFF7AB8), 265),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
              child: Column(
                children: [
                  _buildHeroDashboard(),
                  const SizedBox(height: 14),
                  _buildDailyRecommendation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ambientGlow(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: _isDarkMode ? 0.08 : 0.13),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: _isDarkMode ? 0.16 : 0.20),
              blurRadius: 95,
              spreadRadius: 30,
            ),
          ],
        ),
      ),
    );
  }
}
