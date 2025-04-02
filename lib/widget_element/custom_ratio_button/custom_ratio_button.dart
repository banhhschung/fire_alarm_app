import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  CustomRadioButton({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Container(
            width: AppSize.a20,
            height: AppSize.a20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? AppColors.orangee : AppColors.backgroundGrey,
                width: AppSize.a2,
              ),
              color: Colors.transparent,
            ),
            child: value
                ? Center(
              child: Container(
                width: AppSize.a10,
                height: AppSize.a10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangee
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: AppSize.a4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}