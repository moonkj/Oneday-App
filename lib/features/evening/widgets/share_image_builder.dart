import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:intl/intl.dart';
import 'package:oneday/core/constants/app_strings.dart';
import 'package:oneday/core/utils/image_renderer.dart';
import 'package:oneday/core/utils/quote_picker.dart';
import 'package:oneday/providers/background_image_provider.dart';
import 'package:oneday/providers/daily_record_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' show openAppSettings;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareImageBuilder extends ConsumerStatefulWidget {
  const ShareImageBuilder({super.key});

  @override
  ConsumerState<ShareImageBuilder> createState() => _ShareImageBuilderState();
}

class _ShareImageBuilderState extends ConsumerState<ShareImageBuilder> {
  // 프리뷰 위젯 캡처용 (공유에 사용 - 빠름)
  final _screenshotController = ScreenshotController();
  bool _isSaving = false;
  bool _isSharing = false;
  final _shareButtonKey = GlobalKey();
  final _todayQuote = QuotePicker.todayQuote();

  @override
  Widget build(BuildContext context) {
    final record = ref.watch(dailyRecordProvider);
    final imageAsync = ref.watch(backgroundImageProvider);

    if (record.sentence.trim().isEmpty) return const SizedBox.shrink();

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 프리뷰 이미지
            Screenshot(
              controller: _screenshotController,
              child: _ShareImagePreview(
                sentence: record.sentence,
                backgroundUrl: imageAsync.valueOrNull?.regularUrl,
                quote: _todayQuote,
              ),
            ),
            // 우상단 아이콘 버튼 3개: 새로고침 | 저장 | 공유
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  _IconBtn(
                    icon: imageAsync.isLoading
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 18),
                    onTap: imageAsync.isLoading
                        ? null
                        : () => ref.read(backgroundImageProvider.notifier).refresh(),
                  ),
                  const SizedBox(width: 6),
                  _IconBtn(
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_alt_outlined,
                            color: Colors.white, size: 18),
                    onTap: (_isSaving || _isSharing) ? null : _saveToGallery,
                  ),
                  const SizedBox(width: 6),
                  _IconBtn(
                    key: _shareButtonKey,
                    icon: _isSharing
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.ios_share_rounded,
                            color: Colors.white, size: 18),
                    onTap: (_isSaving || _isSharing) ? null : _shareImage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 갤러리 저장: 고해상도 2160×2700 ──────────────────────

  Future<void> _saveToGallery() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => _isSaving = true);

    try {
      final bytes = await renderGalleryImage(
        ref.read(dailyRecordProvider).sentence,
        ref.read(backgroundImageProvider).valueOrNull?.fullUrl,
        quoteText: _todayQuote.text,
        quoteAuthor: _todayQuote.author,
      );
      final result = await SaverGallery.saveImage(bytes, quality: 100, name: 'oneday_${DateTime.now().millisecondsSinceEpoch}', androidExistNotSave: false, androidRelativePath: 'Pictures/Oneday');
      if (mounted) {
        if (result.isSuccess) {
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(AppStrings.saveImageSuccess),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ));
        } else {
          _showPermissionDialog();
        }
      }
    } catch (_) {
      if (mounted) _showPermissionDialog();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── 공유: 프리뷰 스크린샷 3x (1080×1350, 빠름) ──────────

  Future<void> _shareImage() async {
    setState(() => _isSharing = true);

    // Step 1: 프리뷰 위젯 캡처 (이미 렌더링됨 → 빠름)
    Uint8List? bytes;
    try {
      bytes = await _screenshotController.capture(pixelRatio: 3.0);
      if (bytes == null) throw Exception('캡처 결과 null');
    } catch (e, st) {
      if (mounted) _showErrorDialog('스크린샷 실패', '$e\n\n$st');
      if (mounted) setState(() => _isSharing = false);
      return;
    }

    // Step 2: 파일 저장
    File file;
    try {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/oneday.png');
      await file.writeAsBytes(bytes, flush: true);
    } catch (e, st) {
      if (mounted) _showErrorDialog('파일 저장 실패', '$e\n\n$st');
      if (mounted) setState(() => _isSharing = false);
      return;
    }

    if (!mounted) {
      setState(() => _isSharing = false);
      return;
    }

    // Step 3: iOS 공유 시트
    try {
      final box =
          _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
      final origin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 400, 200, 50);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png', name: 'oneday.png')],
        sharePositionOrigin: origin,
      );
    } catch (e, st) {
      if (mounted) _showErrorDialog('공유 시트 실패', '$e\n\n$st');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  // ── 유틸 ────────────────────────────────────────────────

  void _showErrorDialog(String title, String detail) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: SelectableText(detail, style: const TextStyle(fontSize: 11)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '$title\n$detail'));
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(const SnackBar(content: Text('에러 복사됨')));
            },
            child: const Text('복사'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('사진 저장 실패'),
        content:
            const Text('사진 접근 권한이 필요합니다.\n설정에서 Oneday의 사진 권한을 허용해주세요.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('설정으로 이동'),
          ),
        ],
      ),
    );
  }
}

// ── 미리보기 위젯 ──────────────────────────────────────────

class _ShareImagePreview extends StatelessWidget {
  final String sentence;
  final String? backgroundUrl;
  final Quote quote;

  const _ShareImagePreview({
    required this.sentence,
    required this.quote,
    this.backgroundUrl,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy. MM. dd').format(DateTime.now());

    return SizedBox(
      width: 360,
      height: 450,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundUrl != null)
            Image.network(backgroundUrl!, fit: BoxFit.cover)
          else
            Container(color: const Color(0xFF0D1520)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC000000),
                  Color(0x33000000),
                  Color(0x33000000),
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ONE DAY',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3)),
                    Text(dateStr,
                        style: const TextStyle(
                            color: Color(0x60FFFFFF),
                            fontSize: 11,
                            letterSpacing: 0.5)),
                  ],
                ),
                const Spacer(),
                Text(sentence,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.gowunBatang(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.7,
                        shadows: const [
                          Shadow(
                              color: Color(0x99000000),
                              blurRadius: 16,
                              offset: Offset(0, 3))
                        ])),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.2),
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    Text(
                      '"${quote.text}"',
                      style: const TextStyle(
                          color: Color(0x80FFFFFF),
                          fontSize: 9.5,
                          height: 1.5,
                          letterSpacing: 0.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— ${quote.author}',
                        style: const TextStyle(
                            color: Color(0x60FFFFFF),
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 공통 아이콘 버튼 ──────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const _IconBtn({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
        ),
        child: icon,
      ),
    );
  }
}
