import 'package:flutter/material.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/greeting_resolver.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final reminder = GreetingResolver.lunchReminder();

    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(reminder, style: AppTextStyles.body(TimeMode.lunch)),
          ),
        ],
      ),
    );
  }
}
