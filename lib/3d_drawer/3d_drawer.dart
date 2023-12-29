import 'dart:math';

import 'package:flutter/material.dart';

class DrawerAnimationScreen extends StatefulWidget {
  const DrawerAnimationScreen({super.key});

  @override
  State<DrawerAnimationScreen> createState() => _DrawerAnimationScreenState();
}

class _DrawerAnimationScreenState extends State<DrawerAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late bool canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggle() =>
      controller.isDismissed ? controller.forward() : controller.reverse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 62, 0, 73),
      body: GestureDetector(
        onHorizontalDragStart: onDragStart,
        onHorizontalDragEnd: onDragEnd,
        onHorizontalDragUpdate: onDragUpdate,
        onTap: toggle,
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(maxSlide * (controller.value - 1), 0),
                    child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(pi / 2 * (1 - controller.value)),
                        alignment: Alignment.centerRight,
                        child: const MyDrawer()),
                  ),
                  Transform.translate(
                      offset: Offset(maxSlide * controller.value, 0),
                      child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(-pi * controller.value / 2),
                          alignment: Alignment.centerLeft,
                          child: const HomePage())),
                  // Positioned(
                  //     top: 4.0 + MediaQuery.of(context).padding.top,
                  //     left: 4.0 + controller.value * maxSlide,
                  //     child: IconButton(
                  //       icon: const Icon(Icons.menu),
                  //       onPressed: toggle,
                  //       color: Colors.white,
                  //     )),
                  // Positioned(
                  //     top: 16.0 + MediaQuery.of(context).padding.top,
                  //     left:
                  //         controller.value * MediaQuery.of(context).size.width,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Text(
                  //       'Home Screen',
                  //       style: Theme.of(context).primaryTextTheme.titleLarge,
                  //       textAlign: TextAlign.center,
                  //     )),
                ],
              );
            }),
      ),
    );
  }

  void onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = controller.isDismissed;
    bool isDragCloseFromRight = controller.isCompleted;
    canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      controller.value += delta;
    }
  }

  onDragEnd(DragEndDetails details) {
    double flingVelocity = 365.0;
    if (controller.isDismissed || controller.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= flingVelocity) {
      double velocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      controller.fling(velocity: velocity);
    } else if (controller.value < 0.5) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: ColoredBox(
        color: Colors.purple,
        child: SafeArea(
            child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
          ),
          child: Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.all(10),
                color: Colors.white,
              ),
              const ListTile(
                leading: Icon(
                  Icons.new_releases,
                ),
                title: Text("News"),
              ),
              const ListTile(
                leading: Icon(
                  Icons.star,
                ),
                title: Text("Favorites"),
              ),
              const ListTile(
                leading: Icon(
                  Icons.map,
                ),
                title: Text("Map"),
              ),
              const ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: Text("Settings"),
              ),
              const ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text("Profile"),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
