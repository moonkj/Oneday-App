import 'package:flutter/material.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/core/utils/quote_picker.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = QuotePicker.todayQuote();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              const Icon(Icons.format_quote_rounded, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text('오늘의 명언', style: AppTextStyles.label(TimeMode.morning)),
            ],
          ),
          const SizedBox(height: 14),
          // 명언 본문
          Text(
            '"${quote.text}"',
            style: AppTextStyles.quote(TimeMode.morning),
          ),
          const SizedBox(height: 10),
          // 저자
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— ${quote.author}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
