import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/lunch/widgets/lunch_lottie.dart';
import 'package:oneday/features/lunch/widgets/menu_recommendation_card.dart';
import 'package:oneday/features/lunch/widgets/reminder_card.dart';
import 'package:oneday/features/lunch/widgets/uv_index_card.dart';
import 'package:oneday/features/morning/widgets/greeting_header.dart';
import 'package:oneday/features/shared/widgets/native_ad_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class LunchView extends ConsumerWidget {
  const LunchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(weatherNotifierProvider.notifier).refresh(),
      color: Colors.white,
      backgroundColor: Colors.black38,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
