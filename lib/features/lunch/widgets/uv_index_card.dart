import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/extensions/double_extensions.dart';
import 'package:oneday/core/theme/color_palette.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/outfit_advisor.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class UvIndexCard extends ConsumerWidget {
  const UvIndexCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherNotifierProvider);

    final cityName = ref.watch(cityNameProvider);

    return weatherAsync.when(
      data: (weather) {
        final uvDesc = OutfitAdvisor.uvDescription(weather.uvIndex);
        final uvAdvice = OutfitAdvisor.uvAdvice(weather.uvIndex);
        final uvColor = _uvColor(weather.uvIndex);

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 현재 위치
              if (cityName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.white54, size: 13),
                      const SizedBox(width: 4),
                      Text(cityName,
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 0.3)),
                    ],
                  ),
                ),
              Row(
                children: [
                  // 자외선 지수
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.weatherUvIndex, style: AppTextStyles.label(TimeMode.lunch)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              weather.uvIndex.toStringAsFixed(1),
                              style: AppTextStyles.temperature(TimeMode.lunch).copyWith(
                                fontSize: 36,
                                color: uvColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(uvDesc, style: AppTextStyles.body(TimeMode.lunch).copyWith(color: uvColor)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 체감 온도
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.weatherFeelsLike, style: AppTextStyles.label(TimeMode.lunch)),
                        const SizedBox(height: 4),
                        Text(
                          weather.feelsLike.tempString,
                          style: AppTextStyles.temperature(TimeMode.lunch).copyWith(fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: ColorPalette.glassBorderColor, height: 1),
              const SizedBox(height: 12),
              Text(uvAdvice, style: AppTextStyles.body(TimeMode.lunch)),
            ],
          ),
        );
      },
      loading: () => GlassCard(
        child: SizedBox(
          height: 120,
          child: Center(child: Text(AppStrings.loadingMessage, style: AppTextStyles.body(TimeMode.lunch))),
        ),
      ),
      error: (_, __) => GlassCard(
        child: Text(AppStrings.networkError, style: AppTextStyles.body(TimeMode.lunch)),
      ),
    );
  }

  Color _uvColor(double uv) {
    if (uv < 3) return Colors.green.shade300;
    if (uv < 6) return Colors.yellow.shade300;
    if (uv < 8) return Colors.orange.shade300;
    if (uv < 11) return Colors.red.shade300;
    return Colors.purple.shade300;
  }
}
