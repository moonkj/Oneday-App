import 'package:flutter/material.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/greeting_picker.dart';
import 'package:oneday/data/models/time_mode.dart';

class GreetingHeader extends StatelessWidget {
  final TimeMode mode;

  const GreetingHeader({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final greeting = switch (mode) {
      TimeMode.morning => GreetingPicker.morningGreeting(),
      TimeMode.lunch => GreetingPicker.lunchGreeting(),
      TimeMode.evening => GreetingPicker.eveningGreeting(),
    };

    return Text(greeting, style: AppTextStyles.headline(mode));
  }
}
