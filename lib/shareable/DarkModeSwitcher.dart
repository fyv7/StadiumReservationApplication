import 'package:flutter/material.dart';

class ThemeSwitcherWidget extends StatefulWidget {
  final Widget child;

  const ThemeSwitcherWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();

  static _ThemeSwitcherWidgetState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedThemeSwitcher>()?.data;
  }
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const _InheritedThemeSwitcher({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedThemeSwitcher oldWidget) => true;
}