import 'dart:async';
import 'package:check_artisan/loginsignupclient/home_screen.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.repeat(reverse: true);

    Timer(const Duration(milliseconds: 10000), () {
      CheckartisanNavigator.push(context, const HomeScreen());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/Home Screen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              child: Image.asset('assets/icons/logo checkartisan 1.png',
                  width: 150, height: 150),
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value * 0.5 + 0.75,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
