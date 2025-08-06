import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/my_assets.dart';
import '../../../../resources/my_colors.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

late Size size;

class _splash_screenState extends State<splash_screen> {
  int _activeDot = 0;
  Timer? _dotTimer;
  Timer? _navigationTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Start dot animation timer
    _dotTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        _activeDot = (_activeDot + 1) % 3;
      });
    });

    // Auto navigate after 3 seconds
    _navigationTimer = Timer(Duration(seconds: 3), () {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    if (!_navigated) {
      _navigated = true;
      _dotTimer?.cancel();
      _navigationTimer?.cancel();
      Get.offNamed('/login');
    }
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _navigateToLogin,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: _activeDot == index
                                ? Colors.cyan
                                : Colors.cyan.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
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
