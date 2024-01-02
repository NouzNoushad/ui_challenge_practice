import 'dart:math';

import 'package:flutter/material.dart';

class ThemeSwitcherScreen extends StatefulWidget {
  const ThemeSwitcherScreen({super.key});

  @override
  State<ThemeSwitcherScreen> createState() => _ThemeSwitcherScreenState();
}

class _ThemeSwitcherScreenState extends State<ThemeSwitcherScreen> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return ThemeTransitionScreen(
        isDark: isDark,
        offset: Offset(MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height - 20),
        duration: const Duration(milliseconds: 800),
        childBuilder: (context, index) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Theme Switcher'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
              child: const Icon(Icons.add),
            ),
            body: Center(
                child: Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(
                fontSize: 30,
              ),
            )),
          );
        });
  }
}

class ThemeTransitionScreen extends StatefulWidget {
  const ThemeTransitionScreen(
      {super.key,
      required this.childBuilder,
      this.offset = Offset.zero,
      this.themeController,
      this.radius,
      this.duration = const Duration(milliseconds: 400),
      this.isDark = false});
  final Widget Function(BuildContext, int) childBuilder;
  final bool isDark;
  final AnimationController? themeController;
  final Offset offset;
  final double? radius;
  final Duration? duration;

  @override
  State<ThemeTransitionScreen> createState() => _ThemeTransitionScreenState();
}

class _ThemeTransitionScreenState extends State<ThemeTransitionScreen>
    with SingleTickerProviderStateMixin {
  bool isDarkVisible = false;
  late AnimationController? controller;
  bool isDark = false;
  late double radius;
  Offset position = Offset.zero;
  final darkNotifier = ValueNotifier<bool>(false);

  ThemeData getTheme(bool dark) {
    if (dark) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }

  @override
  void initState() {
    if (widget.themeController == null) {
      controller = AnimationController(vsync: this, duration: widget.duration);
    } else {
      controller = widget.themeController;
    }
    super.initState();
  }

  double setRadius(Size size) {
    final maxValue = max(size.width, size.height);
    return maxValue * 1.5;
  }

  updateRadius() {
    final size = MediaQuery.of(context).size;
    if (widget.radius == null) {
      radius = setRadius(size);
    } else {
      radius = widget.radius!;
    }
  }

  @override
  void didChangeDependencies() {
    updateRadius();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ThemeTransitionScreen oldWidget) {
    darkNotifier.value = widget.isDark;
    if (widget.isDark != oldWidget.isDark) {
      if (isDark) {
        controller?.reverse();
        darkNotifier.value = false;
      } else {
        controller?.reset();
        controller?.forward();
        darkNotifier.value = true;
      }
      position = widget.offset;
    }
    if (widget.radius != oldWidget.radius) {
      updateRadius();
    }
    if (widget.duration != oldWidget.duration) {
      controller?.duration = widget.duration;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    isDark = darkNotifier.value;
    Widget customBody(int index) {
      return ValueListenableBuilder(
          valueListenable: darkNotifier,
          builder: (context, isDark, child) {
            return Theme(
              data: index == 2
                  ? getTheme(!isDarkVisible)
                  : getTheme(isDarkVisible),
              child: widget.childBuilder(context, index),
            );
          });
    }

    return AnimatedBuilder(
        animation: controller!,
        builder: (context, child) {
          return Stack(
            children: [
              customBody(1),
              ClipPath(
                  clipper:
                      CircularClipper(controller!.value * radius, position),
                  child: customBody(2)),
            ],
          );
        });
  }
}

class CircularClipper extends CustomClipper<Path> {
  CircularClipper(this.radius, this.center);

  final double radius;
  final Offset center;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
