import 'package:flutter/material.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/evening_message_picker.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';

class ComfortMessageCard extends StatelessWidget {
  const ComfortMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final message = EveningMessagePicker.todayMessage();

    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_border_rounded, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: AppTextStyles.body(TimeMode.evening)),
          ),
        ],
      ),
    );
  }
}
