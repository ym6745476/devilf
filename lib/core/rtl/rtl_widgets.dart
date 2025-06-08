import 'package:flutter/material.dart';
import 'rtl_text_widget.dart';

/// A button with RTL support for Arabic interfaces
class RTLButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isOutlined;
  final bool isText;
  final IconData? icon;
  final bool iconLeading;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool disabled;

  const RTLButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.style,
    this.isOutlined = false,
    this.isText = false,
    this.icon,
    this.iconLeading = false,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
    this.width,
    this.height,
    this.textStyle,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget textWidget = RTLTextWidget(
      text: text,
      style: textStyle,
      localizeNumbers: localizeNumbers,
      localizePunctuation: localizePunctuation,
      enforceRTL: enforceRTL,
    );

    Widget buttonContent;
    if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconLeading
            ? [
                Icon(icon),
                const SizedBox(width: 8),
                textWidget,
              ]
            : [
                textWidget,
                const SizedBox(width: 8),
                Icon(icon),
              ],
      );
    } else {
      buttonContent = textWidget;
    }

    Widget button;
    if (isOutlined) {
      button = OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: style,
        child: buttonContent,
      );
    } else if (isText) {
      button = TextButton(
        onPressed: disabled ? null : onPressed,
        style: style,
        child: buttonContent,
      );
    } else {
      button = ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: style,
        child: buttonContent,
      );
    }

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}

/// A card with RTL support for Arabic interfaces
class RTLCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Clip? clipBehavior;
  final bool? semanticContainer;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;

  const RTLCard({
    Key? key,
    required this.child,
    this.color,
    this.elevation,
    this.shape,
    this.margin,
    this.padding,
    this.clipBehavior,
    this.semanticContainer,
    this.borderRadius,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }
    
    Widget card = Card(
      color: color,
      elevation: elevation,
      shape: shape ?? (borderRadius != null 
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : null),
      margin: margin,
      clipBehavior: clipBehavior ?? Clip.none,
      semanticContainer: semanticContainer ?? true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: content,
      ),
    );
    
    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: card,
      );
    }
    
    return card;
  }
}

/// A list tile with RTL support for Arabic interfaces
class RTLListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final MouseCursor? mouseCursor;
  final bool selected;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;

  const RTLListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: trailing, // Swap leading and trailing for RTL
        title: title,
        subtitle: subtitle,
        trailing: leading, // Swap leading and trailing for RTL
        isThreeLine: isThreeLine,
        dense: dense,
        visualDensity: visualDensity,
        shape: shape,
        selectedColor: selectedColor,
        iconColor: iconColor,
        textColor: textColor,
        contentPadding: contentPadding,
        enabled: enabled,
        onTap: onTap,
        onLongPress: onLongPress,
        mouseCursor: mouseCursor,
        selected: selected,
        focusColor: focusColor,
        hoverColor: hoverColor,
        focusNode: focusNode,
        autofocus: autofocus,
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
        enableFeedback: enableFeedback,
        horizontalTitleGap: horizontalTitleGap,
        minVerticalPadding: minVerticalPadding,
        minLeadingWidth: minLeadingWidth,
      ),
    );
  }
}

/// A dialog with RTL support for Arabic interfaces
class RTLDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsets insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final bool barrierDismissible;
  final Color? barrierColor;
  final bool useSafeArea;
  final bool scrollable;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;

  const RTLDialog({
    Key? key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    this.clipBehavior = Clip.none,
    this.shape,
    this.barrierDismissible = true,
    this.barrierColor,
    this.useSafeArea = true,
    this.scrollable = false,
    this.titleStyle,
    this.contentStyle,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: title != null
            ? RTLTextWidget(
                text: title!,
                style: titleStyle,
                localizeNumbers: localizeNumbers,
                localizePunctuation: localizePunctuation,
                enforceRTL: enforceRTL,
              )
            : titleWidget,
        content: content != null
            ? RTLTextWidget(
                text: content!,
                style: contentStyle,
                localizeNumbers: localizeNumbers,
                localizePunctuation: localizePunctuation,
                enforceRTL: enforceRTL,
              )
            : contentWidget,
        actions: actions,
        backgroundColor: backgroundColor,
        elevation: elevation,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        scrollable: scrollable,
      ),
    );
  }

  /// Shows the dialog
  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      builder: (BuildContext context) => this,
    );
  }
}

/// A form field with RTL support for Arabic interfaces
class RTLFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool? enabled;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? initialValue;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const RTLFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.enabled,
    this.decoration,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.style,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.inputFormatters,
    this.autovalidateMode,
    this.initialValue,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
        .copyWith(
          labelText: labelText,
          hintText: hintText,
          prefix: prefix,
          suffix: suffix,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        decoration: effectiveDecoration,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        autofocus: autofocus,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        inputFormatters: [
          ...(inputFormatters ?? []),
          if (localizeNumbers || localizePunctuation)
            TextInputFormatter.withFunction((oldValue, newValue) {
              String text = newValue.text;
              
              if (localizeNumbers) {
                text = _localizeNumbers(text);
              }
              
              if (localizePunctuation) {
                text = _localizePunctuation(text);
              }
              
              return TextEditingValue(
                text: text,
                selection: newValue.selection,
                composing: newValue.composing,
              );
            }),
        ],
        autovalidateMode: autovalidateMode,
        initialValue: controller == null ? initialValue : null,
      ),
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

/// A dropdown button with RTL support for Arabic interfaces
class RTLDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Widget? hint;
  final Widget? disabledHint;
  final VoidCallback? onTap;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;

  const RTLDropdownButton({
    Key? key,
    required this.items,
    this.value,
    this.onChanged,
    this.selectedItemBuilder,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        hint: hint,
        disabledHint: disabledHint,
        onTap: onTap,
        elevation: elevation,
        style: style,
        icon: icon,
        iconDisabledColor: iconDisabledColor,
        iconEnabledColor: iconEnabledColor,
        iconSize: iconSize,
        isDense: isDense,
        isExpanded: isExpanded,
        itemHeight: itemHeight,
        focusColor: focusColor,
        focusNode: focusNode,
        autofocus: autofocus,
        dropdownColor: dropdownColor,
        menuMaxHeight: menuMaxHeight,
        enableFeedback: enableFeedback,
        alignment: alignment,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// A checkbox with RTL support for Arabic interfaces
class RTLCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final String? label;
  final TextStyle? labelStyle;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;

  const RTLCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.label,
    this.labelStyle,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          checkColor: checkColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          shape: shape,
          side: side,
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RTLTextWidget(
            text: label!,
            style: labelStyle,
            localizeNumbers: localizeNumbers,
            localizePunctuation: localizePunctuation,
            enforceRTL: enforceRTL,
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            checkColor: checkColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            materialTapTargetSize: materialTapTargetSize,
            visualDensity: visualDensity,
            focusNode: focusNode,
            autofocus: autofocus,
            shape: shape,
            side: side,
          ),
        ],
      ),
    );
  }
}

/// A radio button with RTL support for Arabic interfaces
class RTLRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? label;
  final TextStyle? labelStyle;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;

  const RTLRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.labelStyle,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          mouseCursor: mouseCursor,
          toggleable: toggleable,
          activeColor: activeColor,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RTLTextWidget(
            text: label!,
            style: labelStyle,
            localizeNumbers: localizeNumbers,
            localizePunctuation: localizePunctuation,
            enforceRTL: enforceRTL,
          ),
          const SizedBox(width: 8),
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            mouseCursor: mouseCursor,
            toggleable: toggleable,
            activeColor: activeColor,
            materialTapTargetSize: materialTapTargetSize,
            visualDensity: visualDensity,
            focusNode: focusNode,
            autofocus: autofocus,
          ),
        ],
      ),
    );
  }
}

/// A switch with RTL support for Arabic interfaces
class RTLSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageProvider? inactiveThumbImage;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final Color? focusColor;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? label;
  final TextStyle? labelStyle;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool enforceRTL;

  const RTLSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.labelStyle,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.enforceRTL = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          activeTrackColor: activeTrackColor,
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
          activeThumbImage: activeThumbImage,
          inactiveThumbImage: inactiveThumbImage,
          materialTapTargetSize: materialTapTargetSize,
          dragStartBehavior: dragStartBehavior,
          focusColor: focusColor,
          hoverColor: hoverColor,
          focusNode: focusNode,
          autofocus: autofocus,
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RTLTextWidget(
            text: label!,
            style: labelStyle,
            localizeNumbers: localizeNumbers,
            localizePunctuation: localizePunctuation,
            enforceRTL: enforceRTL,
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            activeTrackColor: activeTrackColor,
            inactiveThumbColor: inactiveThumbColor,
            inactiveTrackColor: inactiveTrackColor,
            activeThumbImage: activeThumbImage,
            inactiveThumbImage: inactiveThumbImage,
            materialTapTargetSize: materialTapTargetSize,
            dragStartBehavior: dragStartBehavior,
            focusColor: focusColor,
            hoverColor: hoverColor,
            focusNode: focusNode,
            autofocus: autofocus,
          ),
        ],
      ),
    );
  }
}