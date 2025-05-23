import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/core/rtl/rtl.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';
import 'package:arabic_mmorpg/main/splash_screen.dart';

/// Main Game Application
class GameApp extends StatefulWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  _GameAppState createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  @override
  void initState() {
    super.initState();
    // Initialize game services, load configurations, etc.
  }

  @override
  Widget build(BuildContext context) {
    return RTLScaffold(
      body: SplashScreen(
        onInitializationComplete: () {
          // Navigate to the appropriate screen after initialization
          // For now, we'll just show a placeholder
          _showPlaceholder();
        },
      ),
    );
  }

  void _showPlaceholder() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const _PlaceholderScreen(),
      ),
    );
  }
}

/// Temporary placeholder screen until the game is fully implemented
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return RTLScaffold(
      appBarTitle: localizations.translate('app.name'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            RTLTextWidget(
              text: localizations.translate('app.name'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RTLTextWidget(
              text: localizations.translate('app.welcome'),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            RTLButton(
              text: localizations.translate('mainMenu.play'),
              onPressed: () {
                // TODO: Implement game start
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: RTLTextWidget(
                      text: 'قريباً...',
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              width: 200,
            ),
            const SizedBox(height: 16),
            RTLButton(
              text: localizations.translate('mainMenu.settings'),
              onPressed: () {
                // TODO: Implement settings screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: RTLTextWidget(
                      text: 'قريباً...',
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              isOutlined: true,
              width: 200,
            ),
            const SizedBox(height: 16),
            RTLButton(
              text: localizations.translate('mainMenu.about'),
              onPressed: () {
                // Show about dialog
                showDialog(
                  context: context,
                  builder: (context) => RTLDialog(
                    title: localizations.translate('mainMenu.about'),
                    content: 'الفتح: طريق الانتقام\n\nلعبة MMORPG عربية\n\nالإصدار: 1.0.0\n\n© 2025 جميع الحقوق محفوظة',
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: RTLTextWidget(
                          text: 'موافق',
                        ),
                      ),
                    ],
                  ),
                );
              },
              isText: true,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}