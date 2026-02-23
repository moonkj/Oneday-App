import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/theme/color_palette.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';
import 'package:oneday/providers/daily_record_provider.dart';

class SentenceInputCard extends ConsumerStatefulWidget {
  const SentenceInputCard({super.key});

  @override
  ConsumerState<SentenceInputCard> createState() => _SentenceInputCardState();
}

class _SentenceInputCardState extends ConsumerState<SentenceInputCard> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final savedSentence = ref.read(dailyRecordProvider).sentence;
    _controller = TextEditingController(text: savedSentence);
    _controller.addListener(() {
      ref.read(dailyRecordProvider.notifier).updateSentence(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(AppStrings.recordTitle, style: AppTextStyles.label(TimeMode.evening)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            style: AppTextStyles.input(TimeMode.evening),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: AppStrings.recordHint,
              hintStyle: AppTextStyles.input(TimeMode.evening).copyWith(
                color: Colors.white38,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            cursorColor: Colors.white70,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: ColorPalette.glassBorderColor),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(AppStrings.recordSave),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecord() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isSaving = true);
    final success = await ref.read(dailyRecordProvider.notifier).saveRecord();
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? AppStrings.recordSaveSuccess : AppStrings.recordSaveFail,
          ),
          backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
