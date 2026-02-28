import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/evening/widgets/comfort_message_card.dart';
import 'package:oneday/features/evening/widgets/evening_lottie.dart';
import 'package:oneday/features/evening/widgets/sentence_input_card.dart';
import 'package:oneday/features/evening/widgets/share_image_builder.dart';
import 'package:oneday/features/evening/widgets/tomorrow_forecast_card.dart';
import 'package:oneday/features/morning/widgets/greeting_header.dart';
import 'package:oneday/features/shared/widgets/native_ad_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class EveningView extends ConsumerWidget {
  const EveningView({super.key});

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
            GreetingHeader(mode: TimeMode.evening),
            SizedBox(height: 20),
            EveningLottie(),
            SizedBox(height: 6),
            ComfortMessageCard(),
            SizedBox(height: 16),
            TomorrowForecastCard(),
            SizedBox(height: 16),
            SentenceInputCard(),
            SizedBox(height: 16),
            ShareImageBuilder(),
            SizedBox(height: 16),
            NativeAdCard(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
