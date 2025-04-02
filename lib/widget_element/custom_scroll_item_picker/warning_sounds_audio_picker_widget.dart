import 'package:audioplayers/audioplayers.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ResultCallback = void Function(int? index);

class WarningSoundsAudioPickerWidget extends StatefulWidget {
  final ResultCallback? done;
  final List<dynamic>? listAudioData;
  final int? preselectedIndex;

  const WarningSoundsAudioPickerWidget({super.key, this.done, this.listAudioData, this.preselectedIndex});

  @override
  State<WarningSoundsAudioPickerWidget> createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<WarningSoundsAudioPickerWidget> {
  int? selectedIndex;
  List<dynamic>? listAudioData = [];

  late AudioPlayer audioPlayer;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    selectedIndex = widget.preselectedIndex;
    widget.listAudioData!.forEach((soundItem) {
      listAudioData!.add(soundItem.name);
    });
    if (widget.listAudioData![selectedIndex!].audioLink != null) {
      audioPlayer.play(UrlSource(widget.listAudioData![selectedIndex!].audioLink));
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.a16), topRight: Radius.circular(AppSize.a16)),
        color: Colors.white,
      ),
      height: 180,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  await audioPlayer.stop();
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  size: AppSize.a24,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await audioPlayer.stop();
                  Navigator.of(context).pop();
                  widget.done!(selectedIndex);
                },
                child: Text(
                  S.current.save,
                  style: AppFonts.title3(fontSize: AppSize.a16, color: AppColors.orangee),
                ),
              ),
            ],
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              diameterRatio: 1,
              looping: true,
              onSelectedItemChanged: (index) async {
                setState(() => selectedIndex = index);
                await audioPlayer.stop();
                if (widget.listAudioData![selectedIndex!].audioLink != null) {
                  Future.delayed(Duration(milliseconds: 200));
                  await audioPlayer.play(UrlSource(widget.listAudioData![selectedIndex!].audioLink));
                }
              },
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: Colors.grey.withOpacity(0.12),
              ),
              scrollController: FixedExtentScrollController(initialItem: selectedIndex!),
              children: modelBuilder<dynamic>(
                listAudioData!,
                    (index, value) {
                  final isSelected = selectedIndex == index;
                  final color = isSelected ? AppColors.title : AppColors.primaryText;
                  return Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(color: color, fontSize: isSelected ? 16 : 14),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> modelBuilder<M>(List<M> models, Widget Function(int index, M model) builder) =>
      models.asMap().map<int, Widget>((index, model) => MapEntry(index, builder(index, model))).values.toList();
}
