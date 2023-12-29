import 'dart:math';

import 'package:flutter/material.dart';

class KineticPosterScreen extends StatefulWidget {
  const KineticPosterScreen({super.key});

  @override
  State<KineticPosterScreen> createState() => _KineticPosterScreenState();
}

class _KineticPosterScreenState extends State<KineticPosterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isOnLeft(double rotation) => cos(rotation) > 0;

  @override
  Widget build(BuildContext context) {
    int numberOfText = 20;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
            alignment: Alignment.center,
            children: List.generate(numberOfText, (index) {
              // final animationRotationValue =
              //     controller.value * 2 * pi / numberOfText;
              // double rotation =
              //     2 * pi * index / numberOfText + pi / 2 + animationRotationValue;
              double rotation =
                  2 * pi * (index + controller.value) / numberOfText + pi / 2;
              if (isOnLeft(rotation)) {
                // rotation = -2 * pi * index / numberOfText -
                //     pi / 2 -
                //     animationRotationValue +
                //     2 * animationRotationValue -
                //     pi * 2 / numberOfText;
                rotation = -1 *
                    (2 * pi * (index - controller.value + 1) / numberOfText +
                        pi / 2);
              }
              return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(rotation)
                          ..translate(-120.0),
                        child: const LinearText());
                  });
            })),
      ),
    );
  }
}

class LinearText extends StatelessWidget {
  const LinearText({super.key});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.2, 0.8])),
        child: const Text(
          'NOBOMAN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 110,
          ),
        ),
      ),
    );
  }
}
