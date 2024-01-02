import 'dart:math';

import 'package:flutter/material.dart';

const colors = [
  {"colorName": "yellow", "color": Color(0xFFF2D337)},
  {"colorName": "blue", "color": Color(0xFF6C9DFD)},
  {"colorName": "green", "color": Color(0xFF7DD222)},
];

class DragDropScreen extends StatefulWidget {
  const DragDropScreen({super.key});

  @override
  State<DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen>
    with TickerProviderStateMixin {
  int selectedColor = 0;
  int qty = 0;
  bool showDragWidget = false;
  Offset dragOffset = const Offset(0, 0);
  double targetDistance = 0.0;

  GlobalKey bagKey = GlobalKey();
  GlobalKey imageKey = GlobalKey();

  late AnimationController imageController;
  late AnimationController qtyController;

  Offset imageOffset() =>
      (imageKey.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);

  Offset bagOffset() => (bagKey.currentContext!.findRenderObject() as RenderBox)
      .localToGlobal(Offset.zero);

  onLongPressStart(LongPressStartDetails details) {
    setState(() {
      dragOffset = Offset(imageOffset().dx - 30, imageOffset().dy - 180);
      showDragWidget = true;
      qty = 0;
    });
  }

  onLongPressEnd(LongPressEndDetails details) {
    if (targetDistance > 80) {
      targetDistance = 140;
      dragOffset = Offset(bagOffset().dx - 85, bagOffset().dy - 270);
      addQty();
    } else {
      targetDistance = 0;
      dragOffset = Offset(imageOffset().dx, imageOffset().dy - 192);
      setState(() {});
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        showDragWidget = false;
        targetDistance = 0;
      });
    });
  }

  onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    var position = details.globalPosition;
    setState(() {
      dragOffset = Offset(position.dx - 100, position.dy - 192);
    });
    double offDistance = (dragOffset - bagOffset()).distance;
    if (offDistance < 400 && offDistance > 250) {
      targetDistance = (400.0 - offDistance);
    }
  }

  addQty() async {
    setState(() {
      qty = 1;
    });
    await Future.delayed(const Duration(seconds: 1));
    qtyController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    qtyController.reverse();
  }

  @override
  void initState() {
    imageController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    qtyController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    super.initState();
  }

  @override
  void dispose() {
    imageController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: 190,
            left: 0,
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.2)
                              .animate(imageController),
                          child: GestureDetector(
                            onLongPressStart: onLongPressStart,
                            onLongPressEnd: onLongPressEnd,
                            onLongPressMoveUpdate: onLongPressMoveUpdate,
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                'assets/${colors[selectedColor]['colorName']}.png',
                                key: imageKey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < colors.length; i++)
                              Radio(
                                  value: i,
                                  groupValue: selectedColor,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => colors[i]['color'] as Color),
                                  activeColor: colors[i]['color'] as Color,
                                  onChanged: (int? value) {
                                    imageController.forward();
                                    Future.delayed(
                                        const Duration(
                                          milliseconds: 200,
                                        ), () {
                                      imageController.reverse();
                                      setState(() {
                                        selectedColor = value!;
                                      });
                                    });
                                  })
                          ],
                        )
                      ]),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      key: bagKey,
                      alignment: Alignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 60 + targetDistance,
                          height: 60 + targetDistance,
                          transform:
                              Matrix4.rotationZ(targetDistance * pi / 90),
                          transformAlignment: Alignment.center,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/gradient.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'assets/bag.png',
                            width: 21 + targetDistance / 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (showDragWidget)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 100),
                    top: dragOffset.dy + targetDistance,
                    left: dragOffset.dx + targetDistance,
                    child: SizedBox(
                      height: (150 - targetDistance).abs(),
                      width: (150 - targetDistance).abs(),
                      child: Image.asset(
                        'assets/${colors[selectedColor]['colorName']}.png',
                      ),
                    ),
                  )
              ],
            ))
      ]),
    );
  }
}
