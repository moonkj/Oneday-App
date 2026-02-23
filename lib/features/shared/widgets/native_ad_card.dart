import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oneday/core/config/app_config.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';

/// 시간대 화면 최하단에 표시되는 네이티브 광고 카드
///
/// 광고 로드 실패 또는 로딩 중에는 SizedBox.shrink()를 반환해
/// 레이아웃에 영향을 주지 않습니다.
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: Platform.isIOS ? AppConfig.nativeAdUnitIdIos : AppConfig.nativeAdUnitIdAndroid,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() => _isLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.transparent,
        cornerRadius: 16,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFF5E4AE3),
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white70,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white54,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 11.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '광고',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 260,
            ),
            child: AdWidget(ad: _nativeAd!),
          ),
        ],
      ),
    );
  }
}
