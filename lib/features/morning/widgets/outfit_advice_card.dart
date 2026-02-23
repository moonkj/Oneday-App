import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/outfit_advisor.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class OutfitAdviceCard extends ConsumerWidget {
  const OutfitAdviceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherNotifierProvider);

    return weatherAsync.when(
      data: (weather) {
        final advice = OutfitAdvisor.getAdvice(
          currentTemp: weather.tempCurrent,
          weatherMain: weather.weatherMain,
          rainProbPercent: weather.rainProbPercent,
        );

        return GlassCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.checkroom_outlined, color: Colors.white70, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.outfitAdviceTitle,
                      style: AppTextStyles.label(TimeMode.morning),
                    ),
                    const SizedBox(height: 6),
                    Text(advice, style: AppTextStyles.body(TimeMode.morning)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
