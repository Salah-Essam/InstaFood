import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/items/data/model/item_size.dart';

class RadioButtonCollection extends StatefulWidget {
  /// Selected size notifier shared with parent; if null, an internal state is used.
  final ValueNotifier<ItemSize>? controller;
  const RadioButtonCollection({super.key, this.controller});

  @override
  State<RadioButtonCollection> createState() => _RadioButtonCollectionState();
}

class _RadioButtonCollectionState extends State<RadioButtonCollection> {
  late final ValueNotifier<ItemSize> _notifier;
  @override
  void initState() {
    super.initState();
    _notifier = widget.controller ?? ValueNotifier<ItemSize>(ItemSize.medium);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ItemSize.values.length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.5),
      itemBuilder: (context, index) {
        return RadioTheme(
          data: RadioThemeData(
            fillColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primaryOrange; // Active color
              }
              return AppColors.primaryOrange; // Inactive color
            }),
          ),
          child: ValueListenableBuilder<ItemSize>(
            valueListenable: _notifier,
            builder: (_, selected, __) {
              return RadioListTile<ItemSize>(
                value: ItemSize.values[index],
                groupValue: selected,
                onChanged: (ItemSize? newSize) {
                  if (newSize == null) return;
                  if (widget.controller == null) setState(() {});
                  _notifier.value = newSize;
                },
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ItemSize.values[index].displayName,
                      style: AppTextStyles.mediumText,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineThickness: 1.0,
                          dashLength: 2.0,
                          dashColor: AppColors.primaryOrange,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Text(
                      "\$${ItemSize.values[index].priceModifier}",
                      style: AppTextStyles.mediumText,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
