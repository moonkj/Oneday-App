import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.72),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.15), width: 0.5),
            ),
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 드래그 핸들
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 제목
              const Text(
                '설정',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 24),

              // ── 알림 섹션 ──
              _SectionLabel('알림'),
              const SizedBox(height: 12),

              _NotificationRow(
                icon: '☀️',
                label: '아침 알림',
                hour: settings.morningHour,
                minute: settings.morningMinute,
                enabled: settings.morningEnabled,
                onToggle: notifier.setMorningEnabled,
                onTimeTap: () => _pickTime(
                  context,
                  initial: TimeOfDay(hour: settings.morningHour, minute: settings.morningMinute),
                  onPicked: (t) => notifier.setMorningTime(t.hour, t.minute),
                ),
              ),
              _divider(),
              _NotificationRow(
                icon: '🍽️',
                label: '점심 알림',
                hour: settings.lunchHour,
                minute: settings.lunchMinute,
                enabled: settings.lunchEnabled,
                onToggle: notifier.setLunchEnabled,
                onTimeTap: () => _pickTime(
                  context,
                  initial: TimeOfDay(hour: settings.lunchHour, minute: settings.lunchMinute),
                  onPicked: (t) => notifier.setLunchTime(t.hour, t.minute),
                ),
              ),
              _divider(),
              _NotificationRow(
                icon: '🌙',
                label: '저녁 알림',
                hour: settings.eveningHour,
                minute: settings.eveningMinute,
                enabled: settings.eveningEnabled,
                onToggle: notifier.setEveningEnabled,
                onTimeTap: () => _pickTime(
                  context,
                  initial: TimeOfDay(hour: settings.eveningHour, minute: settings.eveningMinute),
                  onPicked: (t) => notifier.setEveningTime(t.hour, t.minute),
                ),
              ),

              const SizedBox(height: 28),

              // ── 법적 정보 섹션 ──
              _SectionLabel('법적 정보'),
              const SizedBox(height: 8),

              _LegalRow(
                label: '개인정보처리방침',
                onTap: () => _showLegal(context, _privacyTitle, _privacyBody),
              ),
              _divider(),
              _LegalRow(
                label: '이용약관',
                onTap: () => _showLegal(context, _termsTitle, _termsBody),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.white.withOpacity(0.08), height: 1);

  Future<void> _pickTime(
    BuildContext context, {
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.black,
            surface: Color(0xFF1C1C2E),
            onSurface: Colors.white,
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Color(0xFF1C1C2E),
            dialHandColor: Colors.white,
            dialTextColor: Colors.white,
            hourMinuteTextColor: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  void _showLegal(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LegalPage(title: title, body: body),
      ),
    );
  }

  static const _privacyTitle = '개인정보처리방침';
  static const _privacyBody = '''
One Day 앱(이하 "앱")은 사용자의 개인정보를 소중히 여기며 아래와 같이 처리합니다.

1. 수집하는 정보
앱은 날씨 정보 제공을 위해 기기의 위치 정보(GPS)를 수집합니다. 위치 정보는 서버에 저장되지 않으며, 날씨 API 호출 용도로만 일시적으로 사용됩니다.

2. 정보의 보관 및 이용
수집된 위치 정보는 외부에 전송되지 않습니다. 사용자가 앱에 입력한 오늘의 한 문장은 기기 내부(로컬)에만 저장됩니다.

3. 제3자 서비스
앱은 날씨 데이터를 위해 OpenWeatherMap API를, 배경 이미지를 위해 Unsplash API를 사용합니다. 각 서비스의 개인정보처리방침을 참고하세요.

4. 알림
앱은 사용자가 설정한 시간에 로컬 푸시 알림을 발송합니다. 알림 데이터는 외부로 전송되지 않습니다.

5. 문의
개인정보 처리에 관한 문의는 앱 스토어의 개발자 연락처를 이용해 주세요.

최종 수정일: 2026년 2월
''';

  static const _termsTitle = '이용약관';
  static const _termsBody = '''
One Day 앱 이용약관

1. 서비스 이용
앱은 시간대에 따른 날씨, 일정, 감성 루틴 정보를 제공합니다. 서비스는 현재 무료로 제공됩니다.

2. 사용자 의무
사용자는 앱을 개인적, 비상업적 목적으로만 사용해야 합니다. 앱을 역공학, 복제, 배포하는 행위는 금지됩니다.

3. 서비스 변경 및 중단
개발자는 사전 고지 없이 서비스의 일부 또는 전부를 변경하거나 중단할 수 있습니다.

4. 면책 조항
날씨 정보는 외부 API를 통해 제공되며, 정확성을 보장하지 않습니다. 이로 인한 손해에 대해 개발자는 책임을 지지 않습니다.

5. 준거법
본 약관은 대한민국 법률에 따라 해석됩니다.

최종 수정일: 2026년 2월
''';
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final String icon;
  final String label;
  final int hour;
  final int minute;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeTap;

  const _NotificationRow({
    required this.icon,
    required this.label,
    required this.hour,
    required this.minute,
    required this.enabled,
    required this.onToggle,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          GestureDetector(
            onTap: enabled ? onTimeTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: enabled ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timeStr,
                style: TextStyle(
                  color: enabled ? Colors.white : Colors.white38,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.35),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white10,
          ),
        ],
      ),
    );
  }
}

class _LegalRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LegalRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.4), size: 20),
          ],
        ),
      ),
    );
  }
}

class _LegalPage extends StatelessWidget {
  final String title;
  final String body;

  const _LegalPage({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1E),
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Text(
          body,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.8,
          ),
        ),
      ),
    );
  }
}
