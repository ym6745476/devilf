import 'package:flutter/material.dart';
import 'rtl_app_bar.dart';

/// A custom Scaffold that properly handles RTL layout for Arabic interfaces
class RTLScaffold extends StatelessWidget {
  final String? appBarTitle;
  final TextStyle? appBarTitleStyle;
  final Widget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? drawerIsOpen;
  final bool? endDrawerIsOpen;

  const RTLScaffold({
    Key? key,
    this.appBarTitle,
    this.appBarTitleStyle,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerIsOpen,
    this.endDrawerIsOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a custom app bar if title is provided but no custom app bar
    final Widget? finalAppBar = appBar ?? (appBarTitle != null
        ? RTLAppBar(
            title: appBarTitle!,
            titleStyle: appBarTitleStyle,
          )
        : null);

    // Adjust floating action button location for RTL
    final FloatingActionButtonLocation? finalFabLocation = 
        _adjustFloatingActionButtonLocation(floatingActionButtonLocation);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: finalAppBar is PreferredSizeWidget ? finalAppBar : null,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: finalFabLocation,
        persistentFooterButtons: persistentFooterButtons,
        drawer: drawer,
        endDrawer: endDrawer,
        drawerScrimColor: drawerScrimColor,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        drawerIsOpen: drawerIsOpen,
        endDrawerIsOpen: endDrawerIsOpen,
      ),
    );
  }

  /// Adjusts the floating action button location for RTL layout
  FloatingActionButtonLocation? _adjustFloatingActionButtonLocation(
      FloatingActionButtonLocation? location) {
    if (location == null) return null;

    // Map standard locations to their RTL equivalents
    if (location == FloatingActionButtonLocation.startTop) {
      return FloatingActionButtonLocation.endTop;
    } else if (location == FloatingActionButtonLocation.startFloat) {
      return FloatingActionButtonLocation.endFloat;
    } else if (location == FloatingActionButtonLocation.startDocked) {
      return FloatingActionButtonLocation.endDocked;
    } else if (location == FloatingActionButtonLocation.endTop) {
      return FloatingActionButtonLocation.startTop;
    } else if (location == FloatingActionButtonLocation.endFloat) {
      return FloatingActionButtonLocation.startFloat;
    } else if (location == FloatingActionButtonLocation.endDocked) {
      return FloatingActionButtonLocation.startDocked;
    }

    return location;
  }
}

/// A custom page route that properly handles RTL transitions for Arabic interfaces
class RTLPageRoute<T> extends MaterialPageRoute<T> {
  RTLPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // For RTL, we want to slide from left to right (opposite of LTR)
    if (settings.name == '/') return child;
    
    const Offset begin = Offset(-1.0, 0.0);
    const Offset end = Offset.zero;
    const Curve curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

/// A custom drawer that properly handles RTL layout for Arabic interfaces
class RTLDrawer extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final double? width;
  final String? semanticLabel;

  const RTLDrawer({
    Key? key,
    this.child,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.width,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? Container(),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      width: width,
      semanticLabel: semanticLabel,
    );
  }
}

/// A custom bottom navigation bar that properly handles RTL layout for Arabic interfaces
class RTLBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;
  final double? elevation;
  final BottomNavigationBarType? type;
  final Color? backgroundColor;
  final double? iconSize;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final double? selectedFontSize;
  final double? unselectedFontSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  const RTLBottomNavigationBar({
    Key? key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
    this.backgroundColor,
    this.iconSize,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize,
    this.unselectedFontSize,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reverse the items order for RTL layout
    final List<BottomNavigationBarItem> rtlItems = items.reversed.toList();
    
    // Adjust the current index for the reversed list
    final int rtlCurrentIndex = items.length - 1 - currentIndex;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomNavigationBar(
        items: rtlItems,
        onTap: onTap != null 
            ? (index) => onTap!(items.length - 1 - index) 
            : null,
        currentIndex: rtlCurrentIndex,
        elevation: elevation,
        type: type,
        backgroundColor: backgroundColor,
        iconSize: iconSize ?? 24.0,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
        selectedFontSize: selectedFontSize ?? 14.0,
        unselectedFontSize: unselectedFontSize ?? 12.0,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        showSelectedLabels: showSelectedLabels,
        showUnselectedLabels: showUnselectedLabels,
        mouseCursor: mouseCursor,
        enableFeedback: enableFeedback,
        landscapeLayout: landscapeLayout,
      ),
    );
  }
}