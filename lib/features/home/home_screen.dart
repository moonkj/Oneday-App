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
  late PageController _pageController;
  int _currentPageIndex = 0;

  static const _indexToMode = [
    TimeMode.morning,
    TimeMode.lunch,
    TimeMode.evening,
  ];

  int _modeToIndex(TimeMode mode) => switch (mode) {
        TimeMode.morning => 0,
        TimeMode.lunch => 1,
        TimeMode.evening => 2,
      };

  TimeMode get _viewedMode => _indexToMode[_currentPageIndex.clamp(0, 2)];

  List<Widget> _pagesForMode(TimeMode mode) => switch (mode) {
        TimeMode.morning => [const MorningView()],
        TimeMode.lunch => [const MorningView(), const LunchView()],
        TimeMode.evening => [
            const MorningView(),
            const LunchView(),
            const EveningView()
          ],
      };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final initialMode = ref.read(effectiveTimeModeProvider);
    _currentPageIndex = _modeToIndex(initialMode);
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(locationProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(effectiveTimeModeProvider);
    ref.watch(notificationSetupProvider);

    // 시간대가 바뀌면 해당 모드의 마지막 페이지로 자동 이동
    ref.listen<TimeMode>(effectiveTimeModeProvider, (prev, next) {
      if (prev != null && prev != next) {
        final target = _modeToIndex(next);
        setState(() => _currentPageIndex = target);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              target,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });

    final pages = _pagesForMode(mode);
    final showIndicator = pages.length > 1;

    return Scaffold(
      backgroundColor: AppTheme.fallbackColorForMode(_viewedMode),
      body: Stack(
        children: [
          // 1. 배경 레이어 (현재 보고 있는 페이지 기준)
          Positioned.fill(child: BackgroundLayer(mode: _viewedMode)),

          // 2. 콘텐츠 레이어
          SafeArea(
            child: Column(
              children: [
                // 상단 앱 바 (현재 보고 있는 페이지 기준)
                _TopBar(mode: _viewedMode),

                // 시간대별 페이지뷰
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentPageIndex = index);
                    },
                    children: pages,
                  ),
                ),

                // 페이지 인디케이터 (2페이지 이상일 때만)
                if (showIndicator)
                  _PageIndicator(
                    total: pages.length,
                    current: _currentPageIndex,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int total;
  final int current;

  const _PageIndicator({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final isActive = i == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white38,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
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
                onPressed: () =>
                    ref.read(backgroundImageProvider(mode).notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.white70, size: 20),
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
                icon: const Icon(Icons.settings_outlined,
                    color: Colors.white70, size: 20),
                tooltip: '설정',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
