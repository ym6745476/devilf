import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that handles RTL text rendering with proper Arabic text shaping
class RTLTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? textScaleFactor;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;

  const RTLTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaleFactor,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String processedText = _processText(text);
    
    return Text(
      processedText,
      style: style,
      textAlign: textAlign ?? TextAlign.right,
      textDirection: textDirection ?? TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
    );
  }

  String _processText(String text) {
    String result = text;
    
    // Apply RTL override if needed
    if (enforceRTL) {
      result = '\u202B' + result; // RTL embedding
    }
    
    // Localize numbers if needed
    if (localizeNumbers) {
      result = _localizeNumbers(result);
    }
    
    // Localize punctuation if needed
    if (localizePunctuation) {
      result = _localizePunctuation(result);
    }
    
    return result;
  }

  String _localizeNumbers(String text) {
    const List<String> eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const List<String> western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String result = text;
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    
    return result;
  }

  String _localizePunctuation(String text) {
    const Map<String, String> punctuationMap = {
      ',': '،',
      ';': '؛',
      '?': '؟',
      '%': '٪',
    };
    
    String result = text;
    punctuationMap.forEach((western, eastern) {
      result = result.replaceAll(western, eastern);
    });
    
    return result;
  }
}

/// A text field that handles RTL input with proper Arabic text shaping
class RTLTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool localizeNumbers;
  final bool localizePunctuation;

  const RTLTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
  }) : super(key: key);

  @override
  _RTLTextFieldState createState() => _RTLTextFieldState();
}

class _RTLTextFieldState extends State<RTLTextField> {
  late TextEditingController _controller;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      onChanged: (value) {
        if (!_isComposing && widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      inputFormatters: [
        ...(widget.inputFormatters ?? []),
        if (widget.localizeNumbers || widget.localizePunctuation)
          TextInputFormatter.withFunction((oldValue, newValue) {
            String text = newValue.text;
            
            if (widget.localizeNumbers) {
              text = _localizeNumbers(text);
            }
            
            if (widget.localizePunctuation) {
              text = _localizePunctuation(text);
            }
            
            return TextEditingValue(
              text: text,
              selection: newValue.selection,
              composing: newValue.composing,
            );
          }),
      ],
      enabled: widget.enabled,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  String _localizeNumbers(String text) {
    const List<String> eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const List<String> western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String result = text;
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    
    return result;
  }

  String _localizePunctuation(String text) {
    const Map<String, String> punctuationMap = {
      ',': '،',
      ';': '؛',
      '?': '؟',
      '%': '٪',
    };
    
    String result = text;
    punctuationMap.forEach((western, eastern) {
      result = result.replaceAll(western, eastern);
    });
    
    return result;
  }
}

/// A rich text widget that handles RTL text with proper Arabic text shaping
class RTLRichTextWidget extends StatelessWidget {
  final List<InlineSpan> children;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? textScaleFactor;

  const RTLRichTextWidget({
    Key? key,
    required this.children,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style,
        children: children,
      ),
      textAlign: textAlign ?? TextAlign.right,
      textDirection: textDirection ?? TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: softWrap ?? true,
      textScaleFactor: textScaleFactor ?? 1.0,
    );
  }
}

/// A text span that handles RTL text with proper Arabic text shaping
class RTLTextSpan extends TextSpan {
  RTLTextSpan({
    required String text,
    TextStyle? style,
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
    bool localizeNumbers = true,
    bool localizePunctuation = true,
    bool enforceRTL = true,
  }) : super(
          text: _processText(
            text,
            localizeNumbers: localizeNumbers,
            localizePunctuation: localizePunctuation,
            enforceRTL: enforceRTL,
          ),
          style: style,
          children: children,
          recognizer: recognizer,
          semanticsLabel: semanticsLabel,
        );

  static String _processText(
    String text, {
    bool localizeNumbers = true,
    bool localizePunctuation = true,
    bool enforceRTL = true,
  }) {
    String result = text;
    
    // Apply RTL override if needed
    if (enforceRTL) {
      result = '\u202B' + result; // RTL embedding
    }
    
    // Localize numbers if needed
    if (localizeNumbers) {
      result = _localizeNumbers(result);
    }
    
    // Localize punctuation if needed
    if (localizePunctuation) {
      result = _localizePunctuation(result);
    }
    
    return result;
  }

  static String _localizeNumbers(String text) {
    const List<String> eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const List<String> western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String result = text;
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    
    return result;
  }

  static String _localizePunctuation(String text) {
    const Map<String, String> punctuationMap = {
      ',': '،',
      ';': '؛',
      '?': '؟',
      '%': '٪',
    };
    
    String result = text;
    punctuationMap.forEach((western, eastern) {
      result = result.replaceAll(western, eastern);
    });
    
    return result;
  }
}

/// A text direction utility class
class RTLTextUtils {
  /// Determines if the text is primarily RTL
  static bool isRTL(String text) {
    if (text.isEmpty) return false;
    
    // Count RTL and LTR characters
    int rtlCount = 0;
    int ltrCount = 0;
    
    for (int i = 0; i < text.length; i++) {
      final int code = text.codeUnitAt(i);
      
      // Arabic range
      if (code >= 0x0600 && code <= 0x06FF) {
        rtlCount++;
      }
      // Hebrew range
      else if (code >= 0x0590 && code <= 0x05FF) {
        rtlCount++;
      }
      // Latin range
      else if ((code >= 0x0041 && code <= 0x005A) || (code >= 0x0061 && code <= 0x007A)) {
        ltrCount++;
      }
    }
    
    return rtlCount > ltrCount;
  }
  
  /// Localizes numbers to Eastern Arabic numerals
  static String localizeNumbers(String text) {
    const List<String> eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const List<String> western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String result = text;
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], eastern[i]);
    }
    
    return result;
  }
  
  /// Localizes punctuation to Arabic punctuation
  static String localizePunctuation(String text) {
    const Map<String, String> punctuationMap = {
      ',': '،',
      ';': '؛',
      '?': '؟',
      '%': '٪',
    };
    
    String result = text;
    punctuationMap.forEach((western, eastern) {
      result = result.replaceAll(western, eastern);
    });
    
    return result;
  }
  
  /// Applies RTL embedding to text
  static String enforceRTL(String text) {
    return '\u202B' + text; // RTL embedding
  }
  
  /// Applies LTR embedding to text
  static String enforceLTR(String text) {
    return '\u202A' + text; // LTR embedding
  }
  
  /// Processes text for RTL display
  static String processText(
    String text, {
    bool localizeNumbers = true,
    bool localizePunctuation = true,
    bool enforceRTL = true,
  }) {
    String result = text;
    
    // Apply RTL override if needed
    if (enforceRTL) {
      result = RTLTextUtils.enforceRTL(result);
    }
    
    // Localize numbers if needed
    if (localizeNumbers) {
      result = RTLTextUtils.localizeNumbers(result);
    }
    
    // Localize punctuation if needed
    if (localizePunctuation) {
      result = RTLTextUtils.localizePunctuation(result);
    }
    
    return result;
  }
}