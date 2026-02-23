import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/extensions/double_extensions.dart';
import 'package:oneday/core/theme/color_palette.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';
import 'package:oneday/providers/weather_provider.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherNotifierProvider);

    final cityName = ref.watch(cityNameProvider);

    return weatherAsync.when(
      data: (weather) => GlassCard(
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
            // 날씨 상태 + 현재 기온
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.weatherCondition(weather.weatherMain),
                        style: AppTextStyles.subheadline(TimeMode.morning),
                      ),
                      Text(
                        weather.tempCurrent.tempString,
                        style: AppTextStyles.temperature(TimeMode.morning),
                      ),
                    ],
                  ),
                ),
                _WeatherIcon(code: weather.weatherCode),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: ColorPalette.glassBorderColor, height: 1),
            const SizedBox(height: 16),

            // 세부 정보 그리드
            Row(
              children: [
                _WeatherDetail(
                  label: AppStrings.weatherFeelsLike,
                  value: weather.feelsLike.tempString,
                ),
                _WeatherDetail(
                  label: AppStrings.weatherHigh,
                  value: weather.tempMax.tempString,
                ),
                _WeatherDetail(
                  label: AppStrings.weatherLow,
                  value: weather.tempMin.tempString,
                ),
                _WeatherDetail(
                  label: AppStrings.weatherRainChance,
                  value: '${weather.rainProbPercent}%',
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => GlassCard(
        child: SizedBox(
          height: 140,
          child: Center(
            child: Text(
              AppStrings.loadingMessage,
              style: AppTextStyles.body(TimeMode.morning),
            ),
          ),
        ),
      ),
      error: (error, _) => GlassCard(
        child: Column(
          children: [
            Text(
              error.toString().contains('위치') || error.toString().contains('권한')
                  ? AppStrings.locationPermissionDenied
                  : AppStrings.networkError,
              style: AppTextStyles.body(TimeMode.morning),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(weatherNotifierProvider.notifier).refresh(),
              child: Text(AppStrings.errorRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String label;
  final String value;

  const _WeatherDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.label(TimeMode.morning)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body(TimeMode.morning).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final int code;

  const _WeatherIcon({required this.code});

  IconData _getIcon() {
    if (code >= 200 && code < 300) return Icons.thunderstorm_outlined;
    if (code >= 300 && code < 400) return Icons.grain_outlined;
    if (code >= 500 && code < 600) return Icons.umbrella_outlined;
    if (code >= 600 && code < 700) return Icons.ac_unit_outlined;
    if (code >= 700 && code < 800) return Icons.foggy;
    if (code == 800) return Icons.wb_sunny_outlined;
    if (code > 800) return Icons.cloud_outlined;
    return Icons.wb_cloudy_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_getIcon(), size: 48, color: ColorPalette.textOnDark);
  }
}
