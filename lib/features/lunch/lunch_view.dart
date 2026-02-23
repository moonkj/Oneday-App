import 'package:flutter/material.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/lunch/widgets/lunch_lottie.dart';
import 'package:oneday/features/lunch/widgets/menu_recommendation_card.dart';
import 'package:oneday/features/lunch/widgets/reminder_card.dart';
import 'package:oneday/features/lunch/widgets/uv_index_card.dart';
import 'package:oneday/features/morning/widgets/greeting_header.dart';
import 'package:oneday/features/shared/widgets/native_ad_card.dart';

class LunchView extends StatelessWidget {
  const LunchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          GreetingHeader(mode: TimeMode.lunch),
          SizedBox(height: 20),
          LunchLottie(),
          SizedBox(height: 6),
          UvIndexCard(),
          SizedBox(height: 16),
          MenuRecommendationCard(),
          SizedBox(height: 16),
          ReminderCard(),
          SizedBox(height: 16),
          NativeAdCard(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
