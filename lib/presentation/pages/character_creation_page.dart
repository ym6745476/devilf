import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';
import 'package:arabic_mmorpg/core/rtl/rtl_text_widget.dart';

class CharacterCreationPage extends ConsumerStatefulWidget {
  const CharacterCreationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends ConsumerState<CharacterCreationPage> {
  final _nameController = TextEditingController();
  String _selectedClass = 'warrior';
  String _selectedGender = 'male';
  int _currentStep = 0;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCharacter() async {
    if (_nameController.text.isEmpty) {
      _showError('الرجاء إدخال اسم الشخصية');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    // محاكاة إنشاء الشخصية
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isCreating = false;
      });

      // العودة إلى صفحة اختيار الشخصية
      Navigator.of(context).pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RTLText(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _createCharacter();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/character_creation_background.jpg'),
            fit: BoxFit.cover,
            errorBuilder: _backgroundErrorBuilder,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // خطوات إنشاء الشخصية
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
                          localizations.translate('character_creation'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Stepper(
                            currentStep: _currentStep,
                            onStepTapped: (step) {
                              setState(() {
                                _currentStep = step;
                              });
                            },
                            controlsBuilder: (context, details) {
                              return const SizedBox.shrink();
                            },
                            steps: [
                              // الخطوة 1: اختيار الفئة
                              Step(
                                title: RTLText(
                                  localizations.translate('select_class'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    _buildClassOption('warrior', localizations),
                                    _buildClassOption('mage', localizations),
                                    _buildClassOption('archer', localizations),
                                    _buildClassOption('assassin', localizations),
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep > 0
                                    ? StepState.complete
                                    : StepState.indexed,
                              ),
                              // الخطوة 2: اختيار الجنس
                              Step(
                                title: RTLText(
                                  'اختر الجنس',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    _buildGenderOption('male', localizations),
                                    _buildGenderOption('female', localizations),
                                  ],
                                ),
                                isActive: _currentStep >= 1,
                                state: _currentStep > 1
                                    ? StepState.complete
                                    : StepState.indexed,
                              ),
                              // الخطوة 3: تخصيص الشخصية
                              Step(
                                title: RTLText(
                                  localizations.translate('customize'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    // حقل اسم الشخصية
                                    TextField(
                                      controller: _nameController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'اسم الشخصية',
                                        labelStyle: const TextStyle(color: Colors.white70),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white30),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amber),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // خيارات التخصيص الإضافية ستضاف لاحقًا
                                    const RTLText(
                                      'خيارات التخصيص الإضافية ستضاف لاحقًا',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                isActive: _currentStep >= 2,
                                state: _currentStep > 2
                                    ? StepState.complete
                                    : StepState.indexed,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // زر الرجوع
                            ElevatedButton(
                              onPressed: _previousStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              child: RTLText(
                                localizations.translate('back'),
                              ),
                            ),
                            // زر التالي أو الإنشاء
                            ElevatedButton(
                              onPressed: _isCreating ? null : _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: _isCreating
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    )
                                  : RTLText(
                                      _currentStep < 2
                                          ? localizations.translate('next')
                                          : localizations.translate('create'),
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
              
              // عرض معاينة الشخصية
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // صورة الشخصية
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
                            _getClassIcon(_selectedClass),
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // معلومات الشخصية
                      RTLText(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : '< اسم الشخصية >',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RTLText(
                        '${_getClassTranslation(_selectedClass, localizations)} - ${_getGenderTranslation(_selectedGender, localizations)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassOption(String classType, AppLocalizations localizations) {
    final isSelected = _selectedClass == classType;
    
    return Card(
      color: isSelected ? Colors.amber.withOpacity(0.3) : Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedClass = classType;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                _getClassIcon(classType),
                size: 32,
                color: isSelected ? Colors.amber : Colors.white,
              ),
              const SizedBox(width: 16),
              RTLText(
                _getClassTranslation(classType, localizations),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.amber : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, AppLocalizations localizations) {
    final isSelected = _selectedGender == gender;
    
    return Card(
      color: isSelected ? Colors.amber.withOpacity(0.3) : Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.amber : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                gender == 'male' ? Icons.male : Icons.female,
                size: 32,
                color: isSelected ? Colors.amber : Colors.white,
              ),
              const SizedBox(width: 16),
              RTLText(
                _getGenderTranslation(gender, localizations),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.amber : Colors.white,
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

  String _getClassTranslation(String characterClass, AppLocalizations localizations) {
    return localizations.translate(characterClass);
  }

  String _getGenderTranslation(String gender, AppLocalizations localizations) {
    return localizations.translate(gender);
  }

  static Widget _backgroundErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: const Color(0xFF1A237E),
    );
  }
}