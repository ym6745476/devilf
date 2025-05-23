import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:arabic_mmorpg/core/localization/app_localizations.dart';
import 'package:arabic_mmorpg/core/rtl/rtl.dart';
import 'package:arabic_mmorpg/main/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const ArabicMMORPGApp());
}

class ArabicMMORPGApp extends StatelessWidget {
  const ArabicMMORPGApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الفتح: طريق الانتقام',
      debugShowCheckedModeBanner: false,
      theme: RTLTheme.lightRTLTheme(),
      darkTheme: RTLTheme.darkRTLTheme(),
      themeMode: ThemeMode.system,
      locale: const Locale('ar', ''),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const GameApp(),
    );
  }
}