import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 공유용: 1080×1350 (인스타 4:5), 배경 2160px 다운로드
Future<Uint8List> renderShareImage(
  String sentence,
  String? bgUrl, {
  String quoteText = '',
  String quoteAuthor = '',
}) async {
  const double scale = 3.0;
  const double w = 360 * scale; // 1080
  const double h = 450 * scale; // 1350
  final rect = Rect.fromLTWH(0, 0, w, h);
  const double pad = 32 * scale;
  const double topY = 36 * scale;

  final bgImage = await _downloadImage(bgUrl, width: 2160, quality: 100);

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, rect);

  _drawBackground(canvas, rect, bgImage);
  _drawGradient(canvas, rect);
  _drawText(canvas,
      sentence: sentence,
      quoteText: quoteText,
      quoteAuthor: quoteAuthor,
      w: w,
      h: h,
      pad: pad,
      topY: topY,
      scale: scale);

  final picture = recorder.endRecording();
  final image = await picture.toImage(1080, 1350);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

/// 갤러리 저장용: 2160×2700 (6x 최고화질)
Future<Uint8List> renderGalleryImage(
  String sentence,
  String? bgUrl, {
  String quoteText = '',
  String quoteAuthor = '',
}) async {
  const double scale = 6.0;
  const double w = 360 * scale; // 2160
  const double h = 450 * scale; // 2700
  final rect = Rect.fromLTWH(0, 0, w, h);
  const double pad = 32 * scale;
  const double topY = 36 * scale;

  final bgImage = await _downloadImage(bgUrl, width: 4320, quality: 100);

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, rect);

  _drawBackground(canvas, rect, bgImage);
  _drawGradient(canvas, rect);
  _drawText(canvas,
      sentence: sentence,
      quoteText: quoteText,
      quoteAuthor: quoteAuthor,
      w: w,
      h: h,
      pad: pad,
      topY: topY,
      scale: scale);

  final picture = recorder.endRecording();
  final image = await picture.toImage(2160, 2700);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

// ── 내부 헬퍼 ────────────────────────────────────────────

Future<ui.Image?> _downloadImage(String? bgUrl,
    {required int width, required int quality}) async {
  if (bgUrl == null) return null;
  try {
    final uri = Uri.parse(bgUrl);
    final url = uri.replace(queryParameters: {
      ...uri.queryParameters,
      'q': '$quality',
      'fm': 'jpg',
      'w': '$width',
    }).toString();
    final resp = await Dio().get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    final codec =
        await ui.instantiateImageCodec(Uint8List.fromList(resp.data!));
    return (await codec.getNextFrame()).image;
  } catch (_) {
    return null;
  }
}

void _drawBackground(Canvas canvas, Rect rect, ui.Image? bgImage) {
  if (bgImage != null) {
    paintImage(
      canvas: canvas,
      rect: rect,
      image: bgImage,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  } else {
    canvas.drawRect(rect, Paint()..color = const Color(0xFF0D1520));
  }
}

void _drawGradient(Canvas canvas, Rect rect) {
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xCC000000),
          Color(0x33000000),
          Color(0x33000000),
          Color(0xCC000000),
        ],
        stops: [0.0, 0.25, 0.75, 1.0],
      ).createShader(rect),
  );
}

void _drawText(
  Canvas canvas, {
  required String sentence,
  required String quoteText,
  required String quoteAuthor,
  required double w,
  required double h,
  required double pad,
  required double topY,
  required double scale,
}) {
  // ONE DAY (좌상단)
  (_makePainter('ONE DAY',
        color: Colors.white54,
        size: 11 * scale,
        weight: FontWeight.w700,
        spacing: 3 * scale)
      ..layout())
      .paint(canvas, Offset(pad, topY));

  // 날짜 (우상단)
  final dateStr = DateFormat('yyyy. MM. dd').format(DateTime.now());
  final dateTp = _makePainter(dateStr,
      color: const Color(0x60FFFFFF), size: 11 * scale)
    ..layout();
  dateTp.paint(canvas, Offset(w - pad - dateTp.width, topY));

  // 메인 문장 (중앙)
  final sentenceTp = _makePainter(sentence,
      color: Colors.white,
      size: 24 * scale,
      weight: FontWeight.w600,
      height: 1.7,
      align: TextAlign.center)
    ..layout(maxWidth: w - pad * 2);
  sentenceTp.paint(
      canvas, Offset((w - sentenceTp.width) / 2, (h - sentenceTp.height) / 2));

  // 하단 구분선
  canvas.drawLine(
    Offset(pad, h - 92 * scale),
    Offset(w - pad, h - 92 * scale),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1.5 * (scale / 3),
  );

  // 명언 본문 (하단)
  if (quoteText.isNotEmpty) {
    final quoteTp = _makePainter('"$quoteText"',
        color: const Color(0x80FFFFFF), size: 9.5 * scale, height: 1.5)
      ..layout(maxWidth: w - pad * 2);
    quoteTp.paint(canvas, Offset(pad, h - 84 * scale));

    // 명언 저자 (우하단)
    final authorTp = _makePainter('— $quoteAuthor',
        color: const Color(0x60FFFFFF),
        size: 9 * scale,
        fontStyle: FontStyle.italic)
      ..layout(maxWidth: w - pad * 2);
    authorTp.paint(canvas, Offset(w - pad - authorTp.width, h - 38 * scale));
  }
}

TextPainter _makePainter(
  String text, {
  Color color = Colors.white,
  double size = 40,
  FontWeight weight = FontWeight.normal,
  FontStyle fontStyle = FontStyle.normal,
  double? height,
  double spacing = 0,
  TextAlign align = TextAlign.left,
}) {
  return TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontStyle: fontStyle,
        height: height,
        letterSpacing: spacing,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
    textAlign: align,
  );
}
