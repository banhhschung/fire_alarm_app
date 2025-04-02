import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final bool showLoading;
  final Widget child;

  const CustomLoadingWidget({super.key, this.showLoading = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: child),
            if (showLoading)
              Container(
                constraints: const BoxConstraints.expand(),
                color: AppColors.backgroundGrey.withOpacity(0.4),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSize.a16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.a16),
                      color: AppColors.backgroundGrey,
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: AppSize.a2,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
