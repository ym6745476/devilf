import 'package:flutter/material.dart';
import 'rtl_text_widget.dart';

/// A custom AppBar that properly handles RTL layout for Arabic interfaces
class RTLAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final bool? primary;
  final bool excludeHeaderSemantics;
  final double? titleTextScaleFactor;
  final bool localizeNumbers;
  final bool localizePunctuation;

  const RTLAppBar({
    Key? key,
    required this.title,
    this.titleStyle,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 4.0,
    this.shadowColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.leadingWidth,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleTextScaleFactor,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: RTLTextWidget(
        text: title,
        style: titleStyle,
        textAlign: centerTitle ? TextAlign.center : TextAlign.right,
        textScaleFactor: titleTextScaleFactor,
        localizeNumbers: localizeNumbers,
        localizePunctuation: localizePunctuation,
      ),
      backgroundColor: backgroundColor,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      leadingWidth: leadingWidth,
      primary: primary!,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleTextStyle: titleStyle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A custom SliverAppBar that properly handles RTL layout for Arabic interfaces
class RTLSliverAppBar extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final bool? primary;
  final bool excludeHeaderSemantics;
  final double? titleTextScaleFactor;
  final bool localizeNumbers;
  final bool localizePunctuation;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool forceElevated;
  final double? collapsedHeight;

  const RTLSliverAppBar({
    Key? key,
    required this.title,
    this.titleStyle,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 4.0,
    this.shadowColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.leadingWidth,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleTextScaleFactor,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.forceElevated = false,
    this.collapsedHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: RTLTextWidget(
        text: title,
        style: titleStyle,
        textAlign: centerTitle ? TextAlign.center : TextAlign.right,
        textScaleFactor: titleTextScaleFactor,
        localizeNumbers: localizeNumbers,
        localizePunctuation: localizePunctuation,
      ),
      backgroundColor: backgroundColor,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      leadingWidth: leadingWidth,
      primary: primary!,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleTextStyle: titleStyle,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      forceElevated: forceElevated,
      collapsedHeight: collapsedHeight,
    );
  }
}

/// A custom bottom app bar that properly handles RTL layout for Arabic interfaces
class RTLBottomAppBar extends StatelessWidget {
  final Color? color;
  final double? elevation;
  final NotchedShape? shape;
  final Clip clipBehavior;
  final double notchMargin;
  final Widget? child;

  const RTLBottomAppBar({
    Key? key,
    this.color,
    this.elevation,
    this.shape,
    this.clipBehavior = Clip.none,
    this.notchMargin = 4.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      notchMargin: notchMargin,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? Container(),
      ),
    );
  }
}

/// A custom app bar action button that properly handles RTL layout for Arabic interfaces
class RTLAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final EdgeInsetsGeometry padding;

  const RTLAppBarAction({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color,
      iconSize: size ?? 24.0,
      tooltip: tooltip,
      padding: padding,
    );
  }
}

/// A custom app bar back button that properly handles RTL layout for Arabic interfaces
class RTLBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final String? tooltip;

  const RTLBackButton({
    Key? key,
    this.color,
    this.onPressed,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_forward), // Use forward arrow for RTL back button
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      color: color,
      tooltip: tooltip ?? MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}

/// A custom app bar title with subtitle that properly handles RTL layout for Arabic interfaces
class RTLAppBarTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool centerTitle;
  final double? titleTextScaleFactor;
  final double? subtitleTextScaleFactor;
  final bool localizeNumbers;
  final bool localizePunctuation;

  const RTLAppBarTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.centerTitle = true,
    this.titleTextScaleFactor,
    this.subtitleTextScaleFactor,
    this.localizeNumbers = true,
    this.localizePunctuation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextAlign textAlign = centerTitle ? TextAlign.center : TextAlign.right;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        RTLTextWidget(
          text: title,
          style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
          textAlign: textAlign,
          textScaleFactor: titleTextScaleFactor,
          localizeNumbers: localizeNumbers,
          localizePunctuation: localizePunctuation,
        ),
        if (subtitle != null)
          RTLTextWidget(
            text: subtitle!,
            style: subtitleStyle ?? Theme.of(context).textTheme.titleSmall,
            textAlign: textAlign,
            textScaleFactor: subtitleTextScaleFactor,
            localizeNumbers: localizeNumbers,
            localizePunctuation: localizePunctuation,
          ),
      ],
    );
  }
}