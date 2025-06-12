import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings = {};

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar', ''), // Arabic
    Locale('en', ''), // English
  ];

  Future<bool> load() async {
    // Load the language JSON file from the "assets/localization" folder
    String jsonString =
        await rootBundle.loadString('assets/localization/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value);
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key, {Map<String, dynamic>? args}) {
    String text = _getNestedValue(key, _localizedStrings) ?? key;
    
    if (args != null) {
      args.forEach((argKey, argValue) {
        text = text.replaceAll('{$argKey}', argValue.toString());
      });
    }
    
    return text;
  }
  
  // Get nested values from the localization map using dot notation
  dynamic _getNestedValue(String key, Map<String, dynamic> map) {
    List<String> keys = key.split('.');
    dynamic value = map;
    
    for (String k in keys) {
      if (value is! Map<String, dynamic>) return null;
      value = value[k];
      if (value == null) return null;
    }
    
    return value;
  }

  // Format methods for different types of data
  String formatDate(DateTime date, {String? pattern}) {
    final DateFormat formatter = DateFormat(
      pattern ?? 'yyyy/MM/dd',
      locale.languageCode,
    );
    return formatter.format(date);
  }

  String formatTime(DateTime time, {String? pattern}) {
    final DateFormat formatter = DateFormat(
      pattern ?? 'HH:mm:ss',
      locale.languageCode,
    );
    return formatter.format(time);
  }

  String formatNumber(num number, {String? pattern}) {
    final NumberFormat formatter = NumberFormat(
      pattern ?? '#,##0.##',
      locale.languageCode,
    );
    return formatter.format(number);
  }

  String formatCurrency(num amount, {String? symbol, String? pattern}) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: symbol ?? 'د.ع',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String formatPercentage(num percentage, {String? pattern}) {
    final NumberFormat formatter = NumberFormat.percentPattern(locale.languageCode);
    return formatter.format(percentage / 100);
  }

  // Convert Western Arabic numerals to Eastern Arabic numerals if needed
  String localizeNumbers(String text) {
    if (locale.languageCode != 'ar') return text;
    
    const List<String> eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const List<String> western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    for (int i = 0; i < western.length; i++) {
      text = text.replaceAll(western[i], eastern[i]);
    }
    
    return text;
  }

  // Convert Western punctuation to Arabic punctuation if needed
  String localizePunctuation(String text) {
    if (locale.languageCode != 'ar') return text;
    
    const Map<String, String> punctuationMap = {
      ',': '،',
      ';': '؛',
      '?': '؟',
      '%': '٪',
    };
    
    punctuationMap.forEach((western, eastern) {
      text = text.replaceAll(western, eastern);
    });
    
    return text;
  }

  // Apply all localization transformations to a text
  String localizeText(String text) {
    if (locale.languageCode != 'ar') return text;
    
    text = localizeNumbers(text);
    text = localizePunctuation(text);
    
    return text;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}