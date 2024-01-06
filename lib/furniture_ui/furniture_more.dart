import 'package:flutter/material.dart';
import 'package:ui_challenge_practice/furniture_ui/furniture_home.dart';

class FurnitureMore extends StatelessWidget {
  const FurnitureMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPicker.backgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            color: ColorPicker.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: ColorPicker.backgroundColor,
                  ),
                ),
                Text(
                  'Frama'.toUpperCase(),
                  style: const TextStyle(
                      color: ColorPicker.backgroundColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                ),
                const Icon(
                  Icons.bookmark_outline,
                  color: ColorPicker.backgroundColor,
                )
              ],
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              ClipPath(
                clipper: StepBorderClipper(),
                child: Container(
                  color: ColorPicker.primaryColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.36,
                        width: 25,
                        decoration: const BoxDecoration(
                            color: ColorPicker.secondaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            )),
                      ),
                      Image.asset(
                        'assets/chair.png',
                        height: 240,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            final chair = chairs[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/${chair['image']}',
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chair['title'] ?? "",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: ColorPicker.primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$${chair['price']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color:
                                                    ColorPicker.secondaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ]),
                                    ))
                              ],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          itemCount: chairs.length)),
                ],
              ),
            ],
          ))
        ],
      )),
    );
  }
}

class StepBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var h = size.height;
    var w = size.width;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h)
      ..lineTo(w * 0.3, h)
      ..quadraticBezierTo(w * 0.35, h * 0.99, w * 0.35, h * 0.95)
      ..lineTo(w * 0.35, h * 0.45)
      ..quadraticBezierTo(w * 0.35, h * 0.4, w * 0.4, h * 0.4)
      ..lineTo(w * 0.85, h * 0.4)
      ..quadraticBezierTo(w * 0.9, h * 0.4, w * 0.9, h * 0.35)
      ..lineTo(w * 0.9, h * 0.05)
      ..quadraticBezierTo(w * 0.9, h * 0, w * 0.95, h * 0)
      ..lineTo(w, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
