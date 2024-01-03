import 'dart:math';
import 'dart:ui' as ui show Image;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> assetImages = [
  'assets/profile1.png',
  'assets/profile2.png',
  'assets/profile1.png',
  'assets/profile2.png',
  'assets/profile1.png',
  'assets/profile2.png',
  'assets/profile1.png',
  'assets/profile2.png',
  'assets/profile1.png',
  'assets/profile2.png',
  'assets/profile1.png',
  'assets/profile2.png',
];

class PhoneCallUiDesign extends StatelessWidget {
  const PhoneCallUiDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(children: [
        Positioned.fill(
            child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(200),
            ),
            color: Color.fromARGB(255, 255, 253, 253),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.pink.shade300,
              child: Image.asset(
                'assets/profile2.png',
              ),
            ),
          ),
        )),
        Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height / 2.5,
            child: Align(
              child: Container(
                color: Colors.transparent,
                height: 100,
                width: 60,
                child: CustomPaint(
                  painter: PointerDesign(),
                  child: Center(
                    child: Material(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          Icons.refresh,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Positioned(
          right: -MediaQuery.of(context).size.width / 2,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: FutureBuilder(
                future: _loadImage(assetImages),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomPaint(
                      painter: ProfilePainter(image: snapshot.data!),
                      child: Transform(
                        transform: Matrix4.translationValues(-60, 0, 0),
                        child: const Icon(
                          Icons.mic,
                          size: 80,
                          color: Colors.pink,
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ),
      ]),
    );
  }
}

class PointerDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h)
      ..lineTo(w * 0.8, h * 0.65)
      ..quadraticBezierTo(w * 1, h * 0.5, w * 0.8, h * 0.35);
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawShadow(path, Colors.grey.shade100, 0.8, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Future<List<ui.Image>> _loadImage(List<String> imageAssetPaths) async {
  List<ui.Image> frameImages = [];
  for (int i = 0; i < imageAssetPaths.length; i++) {
    final ByteData data = await rootBundle.load(imageAssetPaths[i]);
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 80,
      targetWidth: 80,
    );
    var frame = await codec.getNextFrame();
    frameImages.add(frame.image);
  }
  print('////// frame: $frameImages');
  return frameImages;
}

class ProfilePainter extends CustomPainter {
  ProfilePainter({required this.image});
  final List<ui.Image> image;
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    canvas.drawCircle(Offset(w / 2, h / 2), 140, Paint()..color = Colors.white);
    canvas.drawCircle(
        Offset(w / 2, h / 2),
        140,
        Paint()
          ..color = Colors.grey.shade100
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    canvas.drawCircle(
        Offset(w / 2, h / 2),
        155,
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    canvas.drawCircle(
        Offset(w / 2, h / 2),
        190,
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawCircle(
        Offset(w / 2, h / 2),
        250,
        Paint()
          ..color = Colors.pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    var centerX = w / 2;
    var centerY = h / 2;
    var radius = min(centerX, centerY) + 40;

    for (int i = 0; i < 360; i += 30) {
      var x = centerX + radius * cos(i * pi / 180);
      var y = centerY + radius * sin(i * pi / 180);
      canvas.drawImage(image[i ~/ 30], Offset(x - 50, y - 40), Paint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
