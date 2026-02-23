import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/theme/app_theme.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/evening/evening_view.dart';
import 'package:oneday/features/home/widgets/background_layer.dart';
import 'package:oneday/features/lunch/lunch_view.dart';
import 'package:oneday/features/morning/morning_view.dart';
import 'package:oneday/features/settings/settings_screen.dart';
import 'package:oneday/providers/background_image_provider.dart';
import 'package:oneday/providers/notification_provider.dart';
import 'package:oneday/providers/time_provider.dart';
import 'package:oneday/providers/weather_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱 재개 시 위치를 새로 가져옴
      // locationProvider 무효화 → WeatherNotifier, tomorrowForecastProvider 자동 rebuild
      ref.invalidate(locationProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(effectiveTimeModeProvider);
    ref.watch(notificationSetupProvider);

    return Scaffold(
      backgroundColor: AppTheme.fallbackColorForMode(mode),
      body: Stack(
        children: [
          // 1. 배경 레이어
          const Positioned.fill(child: BackgroundLayer()),

          // 2. 콘텐츠 레이어
          SafeArea(
            child: Column(
              children: [
                // 상단 앱 바 영역
                _TopBar(mode: mode),

                // 시간대별 뷰
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: _modeView(mode),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeView(TimeMode mode) {
    switch (mode) {
      case TimeMode.morning:
        return const MorningView(key: ValueKey('morning'));
      case TimeMode.lunch:
        return const LunchView(key: ValueKey('lunch'));
      case TimeMode.evening:
        return const EveningView(key: ValueKey('evening'));
    }
  }
}

class _TopBar extends ConsumerWidget {
  final TimeMode mode;

  const _TopBar({required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 앱 이름
          const Text(
            'One Day',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
            ),
          ),

          // 우측 버튼 그룹
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => ref.read(backgroundImageProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 20),
                tooltip: '배경 변경',
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const SettingsScreen(),
                  );
                },
                icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 20),
                tooltip: '설정',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
