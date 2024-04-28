import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medisync/screens/qrhome.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SVGAnimationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SVGAnimationPage extends StatefulWidget {
  @override
  _SVGAnimationPageState createState() => _SVGAnimationPageState();
}

class _SVGAnimationPageState extends State<SVGAnimationPage> {
  int _currentStep = 0;

  void _startAnimation() {
    setState(() {
      _currentStep = 1;
    });
  }

  void _animateToNextStep() {
    setState(() {
      _currentStep = (_currentStep + 1) % 5;
    });
  }

  Future<void> _navigateToQRHome() async {
    await Future.delayed(Duration(milliseconds: 2000)); // Add a delay before navigating
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => QRHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _currentStep == 0 ? _startAnimation : null,
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _buildAnimationStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationStep() {
    switch (_currentStep) {
      case 0:
        return SvgPicture.asset('assets/icons/start.svg');
      case 1:
        return SvgPicture.asset('assets/icons/start.svg')
            .animate(onComplete: (_) => _animateToNextStep())
            .fadeOut(duration: 800.ms);
      case 2:
        return SvgPicture.asset('assets/icons/firstlogo.svg')
            .animate(onComplete: (_) => _animateToNextStep())
            .fadeIn(duration: 800.ms)
            .then(delay: 1000.ms)
            .fadeOut(duration: 1000.ms);
      case 3:
        return SvgPicture.asset('assets/icons/logo.svg')
            .animate(onComplete: (_) => _animateToNextStep())
            .fadeIn(duration: 800.ms)
            .then(delay: 1000.ms)
            .fadeOut(duration: 800.ms);
      case 4:
        return SvgPicture.asset('assets/icons/qr.svg')
            .animate(onComplete: (_) => _navigateToQRHome())
            .fadeIn(duration: 800.ms)
            .then(delay: 1000.ms)
            .fadeOut(duration: 1000.ms);
      default:
        return SizedBox();
    }
  }
}