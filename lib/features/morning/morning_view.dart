import 'package:flutter/material.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/morning/widgets/quote_card.dart';
import 'package:oneday/features/morning/widgets/greeting_header.dart';
import 'package:oneday/features/morning/widgets/morning_lottie.dart';
import 'package:oneday/features/morning/widgets/outfit_advice_card.dart';
import 'package:oneday/features/morning/widgets/weather_card.dart';
import 'package:oneday/features/shared/widgets/native_ad_card.dart';

class MorningView extends StatelessWidget {
  const MorningView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          GreetingHeader(mode: TimeMode.morning),
          SizedBox(height: 20),
          MorningLottie(),
          SizedBox(height: 6),
          WeatherCard(),
          SizedBox(height: 16),
          OutfitAdviceCard(),
          SizedBox(height: 16),
          QuoteCard(),
          SizedBox(height: 16),
          NativeAdCard(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
