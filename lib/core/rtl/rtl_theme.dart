import 'package:flutter/material.dart';

/// A utility class for creating RTL-friendly themes for Arabic interfaces
class RTLTheme {
  /// Creates a theme data optimized for RTL Arabic interfaces
  static ThemeData createRTLTheme({
    bool isDark = false,
    Color? primaryColor,
    Color? accentColor,
    String? fontFamily,
    double? textScaleFactor,
  }) {
    // Default colors if not provided
    final Color defaultPrimaryColor = isDark ? const Color(0xFFE67E22) : const Color(0xFFE67E22);
    final Color defaultAccentColor = isDark ? const Color(0xFF3498DB) : const Color(0xFF3498DB);
    
    // Use provided colors or defaults
    final Color primaryColorFinal = primaryColor ?? defaultPrimaryColor;
    final Color accentColorFinal = accentColor ?? defaultAccentColor;
    
    // Create color scheme based on light/dark mode
    final ColorScheme colorScheme = isDark
        ? ColorScheme.dark(
            primary: primaryColorFinal,
            secondary: accentColorFinal,
            surface: const Color(0xFF2C3E50),
            background: const Color(0xFF34495E),
            error: const Color(0xFFE74C3C),
          )
        : ColorScheme.light(
            primary: primaryColorFinal,
            secondary: accentColorFinal,
            surface: const Color(0xFFECF0F1),
            background: const Color(0xFFF5F5F5),
            error: const Color(0xFFE74C3C),
          );
    
    // Create text theme with Arabic font
    final TextTheme textTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.copyWith(
      displayLarge: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 32 * (textScaleFactor ?? 1.0),
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 28 * (textScaleFactor ?? 1.0),
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 24 * (textScaleFactor ?? 1.0),
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 22 * (textScaleFactor ?? 1.0),
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 20 * (textScaleFactor ?? 1.0),
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 18 * (textScaleFactor ?? 1.0),
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.bold,
        fontSize: 16 * (textScaleFactor ?? 1.0),
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.w600,
        fontSize: 14 * (textScaleFactor ?? 1.0),
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.w600,
        fontSize: 12 * (textScaleFactor ?? 1.0),
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.normal,
        fontSize: 16 * (textScaleFactor ?? 1.0),
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.normal,
        fontSize: 14 * (textScaleFactor ?? 1.0),
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.normal,
        fontSize: 12 * (textScaleFactor ?? 1.0),
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.w600,
        fontSize: 14 * (textScaleFactor ?? 1.0),
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.w500,
        fontSize: 12 * (textScaleFactor ?? 1.0),
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily ?? 'Cairo',
        fontWeight: FontWeight.w500,
        fontSize: 10 * (textScaleFactor ?? 1.0),
      ),
    );
    
    // Create the theme
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryColorFinal,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: fontFamily ?? 'Cairo',
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColorFinal,
        elevation: 4.0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 20 * (textScaleFactor ?? 1.0),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.white,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorFinal,
          foregroundColor: isDark ? Colors.white : Colors.white,
          textStyle: TextStyle(
            fontFamily: fontFamily ?? 'Cairo',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColorFinal,
          side: BorderSide(color: primaryColorFinal),
          textStyle: TextStyle(
            fontFamily: fontFamily ?? 'Cairo',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColorFinal,
          textStyle: TextStyle(
            fontFamily: fontFamily ?? 'Cairo',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: primaryColorFinal,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
        ),
        errorStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: colorScheme.error,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        alignLabelWithHint: true,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: isDark ? const Color(0xFF2C3E50) : Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 20 * (textScaleFactor ?? 1.0),
          color: isDark ? Colors.white : Colors.black,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontSize: 16 * (textScaleFactor ?? 1.0),
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        modalElevation: 24,
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.grey.shade900,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        actionTextColor: accentColorFinal,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        thickness: 1,
        space: 16,
      ),
      
      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: isDark ? Colors.white : primaryColorFinal,
        unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 14 * (textScaleFactor ?? 1.0),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontWeight: FontWeight.normal,
          fontSize: 14 * (textScaleFactor ?? 1.0),
        ),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColorFinal;
          }
          return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColorFinal;
          }
          return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        }),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColorFinal;
          }
          return isDark ? Colors.grey.shade400 : Colors.grey.shade50;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColorFinal.withOpacity(0.5);
          }
          return isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        }),
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColorFinal,
        inactiveTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        thumbColor: primaryColorFinal,
        overlayColor: primaryColorFinal.withOpacity(0.2),
        valueIndicatorColor: primaryColorFinal,
        valueIndicatorTextStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: Colors.white,
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColorFinal,
        circularTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        linearTrackColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      ),
      
      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: Colors.white,
        ),
      ),
      
      // Popup menu theme
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? const Color(0xFF2C3E50) : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
        selectedItemColor: primaryColorFinal,
        unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        selectedLabelStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 12 * (textScaleFactor ?? 1.0),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily ?? 'Cairo',
          fontSize: 12 * (textScaleFactor ?? 1.0),
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? const Color(0xFF2C3E50) : Colors.white,
        elevation: 16,
        scrimColor: Colors.black54,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColorFinal,
        foregroundColor: Colors.white,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 10,
        splashColor: accentColorFinal.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Text selection theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColorFinal,
        selectionColor: primaryColorFinal.withOpacity(0.3),
        selectionHandleColor: primaryColorFinal,
      ),
      
      // Scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          isDark ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
        thickness: MaterialStateProperty.all(6),
        radius: const Radius.circular(3),
        thumbVisibility: MaterialStateProperty.all(true),
      ),
    );
  }
  
  /// Creates a dark theme optimized for RTL Arabic interfaces
  static ThemeData darkRTLTheme({
    Color? primaryColor,
    Color? accentColor,
    String? fontFamily,
    double? textScaleFactor,
  }) {
    return createRTLTheme(
      isDark: true,
      primaryColor: primaryColor,
      accentColor: accentColor,
      fontFamily: fontFamily,
      textScaleFactor: textScaleFactor,
    );
  }
  
  /// Creates a light theme optimized for RTL Arabic interfaces
  static ThemeData lightRTLTheme({
    Color? primaryColor,
    Color? accentColor,
    String? fontFamily,
    double? textScaleFactor,
  }) {
    return createRTLTheme(
      isDark: false,
      primaryColor: primaryColor,
      accentColor: accentColor,
      fontFamily: fontFamily,
      textScaleFactor: textScaleFactor,
    );
  }
}