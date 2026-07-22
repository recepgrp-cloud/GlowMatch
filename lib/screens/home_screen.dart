import 'dart:typed_data';

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
  Uint8List? _selectedImageBytes;

  bool _isLoading = false;
  bool _isDarkMode = false;

  String _selectedLanguage = 'tr';

  bool get _isTurkish => _selectedLanguage == 'tr';

  Color get _backgroundColor =>
      _isDarkMode ? const Color(0xFF111116) : const Color(0xFFF8F7FC);

  Color get _cardColor => _isDarkMode ? const Color(0xFF1C1C24) : Colors.white;

  Color get _primaryTextColor =>
      _isDarkMode ? Colors.white : const Color(0xFF20202A);

  Color get _secondaryTextColor =>
      _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;

  Color get _borderColor =>
      _isDarkMode ? Colors.white.withValues(alpha: 0.10) : Colors.grey.shade200;

  String _text({required String tr, required String en}) {
    return _isTurkish ? tr : en;
  }

  Future<void> _pickFromCamera() async {
    final image = await _imageService.pickFromCamera();
    await _setSelectedImage(image);
  }

  Future<void> _pickFromGallery() async {
    final image = await _imageService.pickFromGallery();
    await _setSelectedImage(image);
  }

  Future<void> _setSelectedImage(XFile? image) async {
    if (image == null) {
      return;
    }

    try {
      final bytes = await image.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _text(tr: 'Fotoğraf okunamadı.', en: 'The photo could not be loaded.'),
      );
    }
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

  void _removeSelectedImage() {
    if (_isLoading) {
      return;
    }

    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
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
      backgroundColor: _cardColor,
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

            return SafeArea(
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
          backgroundColor: _cardColor,
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
            ),
            borderRadius: BorderRadius.circular(23),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.24),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, size: 36, color: Colors.white),
        ),
        const SizedBox(height: 18),
        Text(
          _text(
            tr: 'Sana Uygun Renkleri Keşfet',
            en: 'Discover Your Perfect Colors',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _primaryTextColor,
            fontSize: 27,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _text(
            tr: 'Fotoğrafını yükle, yapay zekâ cilt tonunu analiz etsin ve sana uygun makyaj ürünlerini önersin.',
            en: 'Upload your photo and let AI analyze your skin tone and recommend suitable makeup products.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: _secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildImageArea() {
    final hasImage = _selectedImageBytes != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: hasImage ? 360 : 285,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: hasImage
              ? const Color(0xFF7C3AED).withValues(alpha: 0.35)
              : _borderColor,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: hasImage
                  ? Image.memory(
                      _selectedImageBytes!,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    )
                  : _buildEmptyImageState(),
            ),
          ),
          if (hasImage)
            Positioned(
              top: 14,
              right: 14,
              child: Material(
                color: Colors.black.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: _removeSelectedImage,
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.close, size: 21, color: Colors.white),
                  ),
                ),
              ),
            ),
          if (hasImage)
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xFF86EFAC),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _text(tr: 'Fotoğraf hazır', en: 'Photo ready'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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

  Widget _buildEmptyImageState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isDarkMode
              ? const [Color(0xFF221B30), Color(0xFF281B26)]
              : const [Color(0xFFF5F3FF), Color(0xFFFDF2F8)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                color: _cardColor.withValues(alpha: 0.90),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.14),
                ),
              ),
              child: const Icon(
                Icons.face_retouching_natural,
                size: 57,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _text(tr: 'Fotoğrafını ekle', en: 'Add your photo'),
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _text(
                tr: 'İyi ışıkta çekilmiş, yüzünün net göründüğü bir fotoğraf kullan.',
                en: 'Use a well-lit photo where your face is clearly visible.',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: _secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _pickFromCamera,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(_text(tr: 'Kamera', en: 'Camera')),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _pickFromGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(_text(tr: 'Galeri', en: 'Gallery')),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7C3AED),
                side: BorderSide(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                  width: 1.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    final hasImage = _selectedImage != null;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: !hasImage
          ? const SizedBox.shrink()
          : SizedBox(
              key: const ValueKey('analyze-button'),
              width: double.infinity,
              height: 60,
              child: FilledButton(
                onPressed: _isLoading ? null : _analyzeImage,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color(0xFF7C3AED),
                  disabledBackgroundColor: const Color(
                    0xFF7C3AED,
                  ).withValues(alpha: 0.55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                    ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 21,
                                height: 21,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _text(
                                  tr: 'Analiz ediliyor...',
                                  en: 'Analyzing...',
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _text(
                                  tr: 'AI Analizi Başlat',
                                  en: 'Start AI Analysis',
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildAnalysisInfo() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: !_isLoading
          ? const SizedBox.shrink()
          : Container(
              key: const ValueKey('loading-info'),
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.face_retouching_natural,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _text(
                            tr: 'GlowMatch seni analiz ediyor',
                            en: 'GlowMatch is analyzing you',
                          ),
                          style: TextStyle(
                            color: _primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _text(
                            tr: 'Cilt tonu, alt ton ve ürün uyumları hazırlanıyor.',
                            en: 'Skin tone, undertone and product matches are being prepared.',
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: _secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                color: Color(0xFFDB2777),
              ),
              const SizedBox(width: 9),
              Text(
                _text(tr: 'Daha iyi analiz için', en: 'For a better analysis'),
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildTipRow(
            _text(
              tr: 'Yüzün doğrudan kameraya dönük olsun.',
              en: 'Face the camera directly.',
            ),
          ),
          const SizedBox(height: 10),
          _buildTipRow(
            _text(
              tr: 'Doğal veya dengeli bir ışık kullan.',
              en: 'Use natural or balanced lighting.',
            ),
          ),
          const SizedBox(height: 10),
          _buildTipRow(
            _text(
              tr: 'Filtreli ve aşırı karanlık fotoğraflardan kaçın.',
              en: 'Avoid filtered or overly dark photos.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 15, color: Color(0xFF16A34A)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: _secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 16, color: Color(0xFF7C3AED)),
          SizedBox(width: 5),
          Text(
            'AI',
            style: TextStyle(
              color: Color(0xFF7C3AED),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 23),
            const SizedBox(width: 8),
            Text(
              'GlowMatch',
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          Center(child: _buildAiBadge()),
          const SizedBox(width: 8),
          Center(child: _buildSettingsButton()),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 35),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildImageArea(),
              const SizedBox(height: 17),
              _buildPhotoButtons(),
              const SizedBox(height: 16),
              _buildAnalyzeButton(),
              if (_selectedImage != null) const SizedBox(height: 15),
              _buildAnalysisInfo(),
              if (_isLoading) const SizedBox(height: 17),
              _buildTipsCard(),
              const SizedBox(height: 22),
              Text(
                _text(
                  tr: 'Fotoğraf yalnızca kişiselleştirilmiş analiz oluşturmak için kullanılır.',
                  en: 'Your photo is used only to create a personalized analysis.',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
