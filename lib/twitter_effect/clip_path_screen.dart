import 'package:flutter/material.dart';

class ClipPathScreen extends StatefulWidget {
  const ClipPathScreen({super.key});

  @override
  State<ClipPathScreen> createState() => _ClipPathScreenState();
}

class _ClipPathScreenState extends State<ClipPathScreen> {
  double dx = 0;
  double dy = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            dx = details.localPosition.dx;
            dy = details.localPosition.dy;
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color.fromARGB(255, 74, 0, 87),
            ),
            ClipPath(
                clipper: CircleClipper(
                  center: Offset(dx, dy),
                  radius: 100,
                ),
                child: const HomeScreen()),
          ],
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  CircleClipper({
    required this.center,
    required this.radius,
  });
  final Offset center;
  final double radius;
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
