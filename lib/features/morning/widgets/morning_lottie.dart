import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:oneday/core/constants/lottie_assets.dart';
import 'package:oneday/providers/weather_provider.dart';

class MorningLottie extends ConsumerWidget {
  const MorningLottie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherNotifierProvider);

    String lottiePath = LottieAssets.sunrise;

    if (weatherAsync.hasValue) {
      final code = weatherAsync.value!.weatherCode;
      if (code >= 500 && code < 700) {
        lottiePath = LottieAssets.rain;
      } else if (code >= 600 && code < 700) {
        lottiePath = LottieAssets.snow;
      } else if (code > 800) {
        lottiePath = LottieAssets.cloudsMorning;
      }
    }

    final now = DateTime.now();

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: _LottieOrFallback(path: lottiePath, fallbackIcon: Icons.wb_sunny_outlined),
          ),
          const Spacer(),
          _DateColumn(now: now),
        ],
      ),
    );
  }
}

class _DateColumn extends StatelessWidget {
  final DateTime now;

  const _DateColumn({required this.now});

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdays[now.weekday - 1];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${now.month}월',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w200,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          '${now.day}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
        Text(
          weekday,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _LottieOrFallback extends StatelessWidget {
  final String path;
  final IconData fallbackIcon;

  const _LottieOrFallback({required this.path, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      path,
      repeat: true,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: 72, color: Colors.white.withOpacity(0.8));
      },
    );
  }
}
