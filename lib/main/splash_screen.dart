import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/core/rtl/rtl.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';

/// Splash screen shown during app initialization
class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  String _loadingText = '';
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    
    // Set up animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    
    _animationController.forward();
    
    // Simulate loading process
    _simulateLoading();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _simulateLoading() {
    const totalSteps = 5;
    const stepDuration = Duration(milliseconds: 800);
    
    final loadingTexts = [
      'تحميل الموارد...',
      'تهيئة العالم...',
      'تحميل الشخصيات...',
      'تحميل المهام...',
      'جاهز للمغامرة!',
    ];
    
    int currentStep = 0;
    
    _progressTimer = Timer.periodic(stepDuration, (timer) {
      if (currentStep < totalSteps) {
        setState(() {
          _loadingProgress = (currentStep + 1) / totalSteps;
          _loadingText = loadingTexts[currentStep];
        });
        currentStep++;
      } else {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
        
        // Delay a bit before completing initialization
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onInitializationComplete();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/ui/logo.png',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Game title
              RTLTextWidget(
                text: 'الفتح: طريق الانتقام',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Loading indicator
              if (_isLoading) ...[
                SizedBox(
                  width: 240,
                  child: Column(
                    children: [
                      // Loading text
                      RTLTextWidget(
                        text: _loadingText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _loadingProgress,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Progress percentage
                      RTLTextWidget(
                        text: '${(_loadingProgress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Copyright text
              RTLTextWidget(
                text: '© 2025 جميع الحقوق محفوظة',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}