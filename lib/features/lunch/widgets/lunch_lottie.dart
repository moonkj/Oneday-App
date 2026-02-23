import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oneday/core/constants/lottie_assets.dart';

class LunchLottie extends StatelessWidget {
  const LunchLottie({super.key});

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = _weekdays[now.weekday - 1];

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              LottieAssets.sunAfternoon,
              repeat: true,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.wb_sunny, size: 72, color: Colors.white.withOpacity(0.8));
              },
            ),
          ),
          const Spacer(),
          Column(
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
          ),
        ],
      ),
    );
  }
}
