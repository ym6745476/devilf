import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';
import 'package:arabic_mmorpg/core/rtl/rtl_text_widget.dart';
import 'package:arabic_mmorpg/presentation/pages/character_selection_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('الرجاء إدخال اسم المستخدم وكلمة المرور');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // محاكاة عملية تسجيل الدخول
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // الانتقال إلى صفحة اختيار الشخصية
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CharacterSelectionPage(),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/login_background.jpg'),
            fit: BoxFit.cover,
            errorBuilder: _backgroundErrorBuilder,
          ),
        ),
        child: Center(
          child: Card(
            color: Colors.black.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // عنوان اللعبة
                  RTLText(
                    localizations.translate('app_name'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // حقل اسم المستخدم
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: localizations.translate('username'),
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.person, color: Colors.amber),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // حقل كلمة المرور
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: localizations.translate('password'),
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // زر تسجيل الدخول
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            )
                          : RTLText(
                              localizations.translate('login'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // زر إنشاء حساب
                  TextButton(
                    onPressed: () {
                      // الانتقال إلى صفحة إنشاء الحساب
                    },
                    child: RTLText(
                      localizations.translate('register'),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                      ),
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

  static Widget _backgroundErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: const Color(0xFF1A237E),
    );
  }
}