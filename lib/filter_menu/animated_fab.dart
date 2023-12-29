import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  const AnimatedFab({super.key, required this.onClick});
  final void Function() onClick;

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    colorAnimation = ColorTween(
      begin: Colors.pink,
      end: Colors.pink.shade800,
    ).animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                buildExpandedBackground(),
                buildOption(Icons.check_circle, 0.0),
                buildOption(Icons.flash_on, -pi / 3),
                buildOption(Icons.access_time, -2 * pi / 3),
                buildOption(Icons.error_outline, pi),
                buildFabCore(),
              ],
            );
          }),
    );
  }

  Widget buildFabCore() {
    double scaleFactor = 2 * (animationController.value - 0.5).abs();
    return FloatingActionButton(
      onPressed: onFabTap,
      backgroundColor: colorAnimation.value,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(1.0, scaleFactor),
        child: Icon(
            animationController.value > 0.5 ? Icons.close : Icons.filter_list,
            color: Colors.white),
      ),
    );
  }

  Widget buildOption(IconData icon, double angle) {
    double iconSize = 0.0;
    if (animationController.isDismissed) {
      return Container();
    }
    if (animationController.value > 0.8) {
      iconSize = 26.0 * (animationController.value - 0.8) * 5;
    }
    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: IconButton(
            onPressed: () {
              widget.onClick();
              close();
            },
            icon: Transform.rotate(
              angle: -angle,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * animationController.value;
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink,
      ),
    );
  }

  void onFabTap() {
    if (animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  void open() {
    if (animationController.isDismissed) {
      animationController.forward();
    }
  }

  void close() {
    if (animationController.isCompleted) {
      animationController.reverse();
    }
  }
}
