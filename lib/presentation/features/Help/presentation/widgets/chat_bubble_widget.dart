import 'package:flutter/widgets.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class ChatBubbleWidget extends StatelessWidget {
  const ChatBubbleWidget({super.key, required this.isMe, required this.text});

  final bool isMe;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(minWidth: 150, maxWidth: 250),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: isMe
              ? null
              : Border.all(color: AppColors.primaryOrange, width: 1.5),
          color: isMe ? AppColors.lightYellow : AppColors.scaffoldBackgournd,
          shape: BoxShape.rectangle,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(16),
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, textAlign: isMe ? TextAlign.right : TextAlign.left),
        ),
      ),
    );
  }
}
