import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';
import 'package:arabic_mmorpg/core/rtl/rtl_text_widget.dart';
import 'package:arabic_mmorpg/presentation/pages/character_creation_page.dart';
import 'package:arabic_mmorpg/presentation/pages/game_page.dart';

class CharacterSelectionPage extends ConsumerStatefulWidget {
  const CharacterSelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends ConsumerState<CharacterSelectionPage> {
  int? _selectedCharacterIndex;
  bool _isLoading = false;

  // قائمة الشخصيات المحفوظة (محاكاة)
  final List<Map<String, dynamic>> _characters = [
    {
      'name': 'فارس الظلام',
      'class': 'warrior',
      'level': 10,
      'lastPlayed': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'name': 'ساحر النار',
      'class': 'mage',
      'level': 8,
      'lastPlayed': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  Future<void> _startGame() async {
    if (_selectedCharacterIndex == null) {
      _showError('الرجاء اختيار شخصية');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // محاكاة تحميل بيانات الشخصية
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // الانتقال إلى صفحة اللعبة
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GamePage(),
        ),
      );
    }
  }

  void _createNewCharacter() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CharacterCreationPage(),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RTLText(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getClassTranslation(String characterClass) {
    switch (characterClass) {
      case 'warrior':
        return AppLocalizations.of(context).translate('warrior');
      case 'mage':
        return AppLocalizations.of(context).translate('mage');
      case 'archer':
        return AppLocalizations.of(context).translate('archer');
      case 'assassin':
        return AppLocalizations.of(context).translate('assassin');
      default:
        return characterClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/character_selection_background.jpg'),
            fit: BoxFit.cover,
            errorBuilder: _backgroundErrorBuilder,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // قائمة الشخصيات
              Expanded(
                flex: 2,
                child: Card(
                  color: Colors.black.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RTLText(
                          localizations.translate('character_selection'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _characters.isEmpty
                              ? Center(
                                  child: RTLText(
                                    'لا توجد شخصيات. أنشئ شخصية جديدة للبدء.',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _characters.length,
                                  itemBuilder: (context, index) {
                                    final character = _characters[index];
                                    final isSelected = _selectedCharacterIndex == index;
                                    
                                    return Card(
                                      color: isSelected
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.black45,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: isSelected
                                              ? Colors.amber
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedCharacterIndex = index;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              // صورة الشخصية
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[800],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    _getClassIcon(character['class']),
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // معلومات الشخصية
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RTLText(
                                                      character['name'],
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    RTLText(
                                                      '${_getClassTranslation(character['class'])} - ${localizations.translate('level')} ${character['level']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    RTLText(
                                                      'آخر لعب: ${_formatDate(character['lastPlayed'])}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // زر إنشاء شخصية جديدة
                            ElevatedButton.icon(
                              onPressed: _createNewCharacter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: RTLText(
                                localizations.translate('create'),
                              ),
                            ),
                            // زر بدء اللعب
                            ElevatedButton(
                              onPressed: _isLoading ? null : _startGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    )
                                  : RTLText(
                                      localizations.translate('start_game'),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // عرض الشخصية المختارة
              Expanded(
                flex: 3,
                child: _selectedCharacterIndex != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // صورة الشخصية المختارة
                            Container(
                              width: 300,
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getClassIcon(_characters[_selectedCharacterIndex!]['class']),
                                  size: 120,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // اسم الشخصية
                            RTLText(
                              _characters[_selectedCharacterIndex!]['name'],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: RTLText(
                          'اختر شخصية للبدء',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getClassIcon(String characterClass) {
    switch (characterClass) {
      case 'warrior':
        return Icons.shield;
      case 'mage':
        return Icons.auto_fix_high;
      case 'archer':
        return Icons.gps_fixed;
      case 'assassin':
        return Icons.flash_on;
      default:
        return Icons.person;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Widget _backgroundErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: const Color(0xFF1A237E),
    );
  }
}