import 'dart:async';

import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:flutter/material.dart';

class CustomVerticalDotLoadingWidget extends StatefulWidget {
  const CustomVerticalDotLoadingWidget({super.key});

  @override
  _CustomVerticalDotLoadingWidgetState createState() => _CustomVerticalDotLoadingWidgetState();
}

class _CustomVerticalDotLoadingWidgetState extends State<CustomVerticalDotLoadingWidget> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3; // Quay vòng từ 0 -> 1 -> 2 -> 0
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: AppSize.a8,
          height: AppSize.a8,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.red : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: _currentIndex == index
                ? [
              BoxShadow(
                color: Colors.red.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 3,
              )
            ]
                : [],
          ),
        );
      }),
    );
  }
}