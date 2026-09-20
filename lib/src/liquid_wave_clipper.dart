import 'dart:math';
import 'package:flutter/material.dart';

/// Custom clipper that renders an organic, fluid liquid wave transition path.
class LiquidWaveClipper extends CustomClipper<Path> {
  /// Progress of the wave transition between 0.0 (hidden) and 1.0 (fully covering the screen).
  final double progress;

  /// Vertical Y coordinate where the touch/wave crest originates.
  final double touchY;

  /// Whether the wave sweeps from right to left (`false`) or left to right (`true`).
  final bool fromLeft;

  const LiquidWaveClipper({
    required this.progress,
    required this.touchY,
    this.fromLeft = false,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final clampedProgress = progress.clamp(0.0, 1.0);

    if (clampedProgress <= 0.0) {
      return path; // Empty path
    }
    if (clampedProgress >= 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    final peakY = touchY.clamp(size.height * 0.15, size.height * 0.85);
    final waveSpread = 160.0 + 80.0 * sin(clampedProgress * pi);
    final waveBulge = 120.0 * sin(clampedProgress * pi);

    if (!fromLeft) {
      // Swiping right-to-left: revealing next page from right side
      final baseX = size.width * (1.0 - clampedProgress);
      final crestX = (baseX - waveBulge).clamp(0.0, size.width);

      path.moveTo(size.width, 0);
      path.lineTo(baseX, 0);

      final topY = (peakY - waveSpread).clamp(0.0, size.height);
      path.lineTo(baseX, topY);

      // Curve leading to wave crest
      path.cubicTo(
        baseX,
        peakY - waveSpread * 0.45,
        crestX,
        peakY - waveSpread * 0.25,
        crestX,
        peakY,
      );

      final bottomY = (peakY + waveSpread).clamp(0.0, size.height);
      // Curve descending from crest back to base line
      path.cubicTo(
        crestX,
        peakY + waveSpread * 0.25,
        baseX,
        peakY + waveSpread * 0.45,
        baseX,
        bottomY,
      );

      path.lineTo(baseX, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      // Swiping left-to-right: revealing previous page from left side
      final baseX = size.width * clampedProgress;
      final crestX = (baseX + waveBulge).clamp(0.0, size.width);

      path.moveTo(0, 0);
      path.lineTo(baseX, 0);

      final topY = (peakY - waveSpread).clamp(0.0, size.height);
      path.lineTo(baseX, topY);

      path.cubicTo(
        baseX,
        peakY - waveSpread * 0.45,
        crestX,
        peakY - waveSpread * 0.25,
        crestX,
        peakY,
      );

      final bottomY = (peakY + waveSpread).clamp(0.0, size.height);
      path.cubicTo(
        crestX,
        peakY + waveSpread * 0.25,
        baseX,
        peakY + waveSpread * 0.45,
        baseX,
        bottomY,
      );

      path.lineTo(baseX, size.height);
      path.lineTo(0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant LiquidWaveClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.touchY != touchY ||
        oldClipper.fromLeft != fromLeft;
  }
}
