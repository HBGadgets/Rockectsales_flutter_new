import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsales/resources/my_assets.dart';
import 'package:rocketsales/resources/my_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Dot animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!_navigated) {
      _navigated = true;
      _controller.stop();
      Get.offNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _navigateToLogin,
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColor.bodycolor1, MyColor.bodycolor2],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      height: size.height * 0.3,
                      width: size.width * 0.8,
                      image: rocket_sale,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            int activeDot =
                                (_controller.value * 3).floor() % 3;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: activeDot == index
                                    ? Colors.cyan
                                    : Colors.cyan.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom image
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image(
                height: size.height * 0.25,
                width: size.width,
                fit: BoxFit.cover,
                image: splashscreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
