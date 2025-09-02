import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class NotificationSettingsItem extends StatefulWidget {
  const NotificationSettingsItem({
    super.key,
    required this.value,
    required this.onToggle,
    required this.title,
  });

  final bool value;
  final ValueChanged<bool> onToggle;
  final String title;

  @override
  State<NotificationSettingsItem> createState() =>
      _NotificationSettingsItemState();
}

class _NotificationSettingsItemState extends State<NotificationSettingsItem> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: AppTextStyles.fontBlackMedBold),
        Transform.scale(
          scale: 0.8,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Switch(
              value: isChecked,
              onChanged: (value) {
                widget.onToggle(value);
                setState(() {
                  isChecked = !isChecked;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
