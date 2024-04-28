import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:torch_controller/torch_controller.dart';

class QRHome extends StatefulWidget {
  @override
  _QRHomeState createState() => _QRHomeState();
}

class _QRHomeState extends State<QRHome> with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  String? qrCodeResult;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;
  final TorchController _torchController =
      TorchController(); // Initialize TorchController

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 30.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _torchController.initialize(); // Initialize the torch controller
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 44, 44, 1),
        elevation: 0,
      ),
      body: Container(
        color: Color.fromRGBO(44, 44, 44, 1),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset('assets/icons/qr.svg', fit: BoxFit.cover),
                  ClipPath(
                    clipper: QRCodeClipper(),
                    child: Container(
                      width: 230,
                      height: 360,
                      alignment: Alignment.center,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          MobileScanner(
                            controller: cameraController,
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                debugPrint(
                                    'Barcode found: ${barcode.rawValue}');
                                setState(() {
                                  qrCodeResult = barcode.rawValue;
                                });
                              }
                            },
                            fit: BoxFit.cover,
                          ),
                          AnimatedBuilder(
                            animation: _scanAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: _scanAnimation.value,
                                left: 0,
                                right: 0,
                                child:
                                    SvgPicture.asset('assets/icons/scan.svg'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40, right: 0, bottom: 20),
                  child: IconButton(
                    onPressed: () {
                      // Handle flashlight button press
                    },
                    icon: Image.asset(
                      'assets/icons/image.png',
                      width: 120, // Set your desired width here
                      height: 70,
                    ),
                    iconSize: 10,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 40),
                  child: IconButton(
                    onPressed: () {
                      _torchController
                          .toggle(); // Use the initialized controller to toggle the flashlight
                    },
                    icon: Image.asset(
                      'assets/icons/flashlight.png',
                      width: 120, // Set your desired width here
                      height: 90,
                    ),
                    iconSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(
      (size.width - 300) / 2,
      (size.height - 300) / 2,
      300,
      200,
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
