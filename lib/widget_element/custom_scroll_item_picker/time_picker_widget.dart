import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DoneCallback = void Function(Duration? duration);

class TimePickerBottomSheet extends StatefulWidget {
  final DoneCallback? done;
  final Duration? duration;

  const TimePickerBottomSheet({super.key, this.done, this.duration});

  @override
  State<TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  Duration? duration = const Duration(hours: 0, minutes: 1, seconds: 0);

  @override
  void initState() {
    duration = widget.duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16)),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: AppSize.a24,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.done!(duration);
                  },
                  child: Text(S.current.save, style: AppFonts.title3(fontSize: AppSize.a16, color: AppColors.orangee)),
                ),
              ],
            ),
            Container(margin: const EdgeInsets.symmetric(horizontal: AppPadding.p24), child: buildTimePicker()),
          ],
        ),
      ),
    );
  }

  Widget buildTimePicker() => SizedBox(
        height: 180,
        child: CupertinoTimerPicker(
          initialTimerDuration: duration!,
          mode: CupertinoTimerPickerMode.ms,
          minuteInterval: 1,
          secondInterval: 1,
          onTimerDurationChanged: (duration) => setState(() => this.duration = duration),
        ),
      );
}
