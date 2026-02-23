import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneday/core/theme/app_theme.dart';
import 'package:oneday/features/home/home_screen.dart';
import 'package:oneday/providers/time_provider.dart';

class OnedayApp extends ConsumerWidget {
  const OnedayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(effectiveTimeModeProvider);

    return MaterialApp(
      title: 'One Day',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forMode(mode),
      home: const HomeScreen(),
    );
  }
}
