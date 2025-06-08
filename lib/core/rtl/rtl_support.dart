import 'package:flutter/material.dart';

class RTLSupport {
  /// تحديد اتجاه النص بناءً على محتواه
  static TextDirection getTextDirection(String text) {
    // التعبير النمطي للأحرف العربية
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    
    // إذا كان النص يحتوي على أحرف عربية، استخدم RTL
    if (arabicRegex.hasMatch(text)) {
      return TextDirection.rtl;
    }
    
    // وإلا استخدم LTR
    return TextDirection.ltr;
  }
  
  /// تغليف عنصر واجهة المستخدم باتجاه النص المناسب
  static Widget wrapWithDirectionality(Widget child, String text) {
    return Directionality(
      textDirection: getTextDirection(text),
      child: child,
    );
  }
  
  /// تعديل الهوامش بناءً على اتجاه النص
  static EdgeInsets getAdjustedPadding(EdgeInsets padding, TextDirection direction) {
    if (direction == TextDirection.rtl) {
      return EdgeInsets.fromLTRB(
        padding.right,
        padding.top,
        padding.left,
        padding.bottom,
      );
    }
    return padding;
  }
  
  /// تعديل المحاذاة بناءً على اتجاه النص
  static Alignment getAdjustedAlignment(Alignment alignment, TextDirection direction) {
    if (direction == TextDirection.rtl) {
      // عكس المحاذاة الأفقية
      return Alignment(
        -alignment.x,
        alignment.y,
      );
    }
    return alignment;
  }
}