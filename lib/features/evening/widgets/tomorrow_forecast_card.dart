import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/extensions/double_extensions.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class TomorrowForecastCard extends ConsumerWidget {
  const TomorrowForecastCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(tomorrowForecastProvider);
    final cityName = ref.watch(cityNameProvider);

    return forecastAsync.when(
      data: (forecast) => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(AppStrings.tomorrowForecast, style: AppTextStyles.label(TimeMode.evening)),
                const Spacer(),
                if (cityName.isNotEmpty) ...[
                  const Icon(Icons.location_on_outlined, color: Colors.white54, size: 13),
                  const SizedBox(width: 3),
                  Text(cityName,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 0.3)),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // 날씨 상태
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.weatherCondition(forecast.weatherMain),
                        style: AppTextStyles.subheadline(TimeMode.evening),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '강수 ${forecast.rainProbPercent}%',
                        style: AppTextStyles.label(TimeMode.evening),
                      ),
                    ],
                  ),
                ),
                // 기온
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${AppStrings.weatherHigh} ${forecast.tempMax.tempString}',
                      style: AppTextStyles.body(TimeMode.evening),
                    ),
                    Text(
                      '${AppStrings.weatherLow} ${forecast.tempMin.tempString}',
                      style: AppTextStyles.label(TimeMode.evening),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => GlassCard(
        child: Text(AppStrings.loadingMessage, style: AppTextStyles.body(TimeMode.evening)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
