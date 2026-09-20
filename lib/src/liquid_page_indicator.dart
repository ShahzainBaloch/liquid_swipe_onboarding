import 'package:flutter/material.dart';

/// An animated, morphing pill and dot page indicator for onboarding carousels.
class LiquidPageIndicator extends StatelessWidget {
  /// The total number of pages.
  final int count;

  /// The currently active page index.
  final int currentPage;

  /// Color of the active page indicator pill.
  final Color activeColor;

  /// Color of the inactive page dots.
  final Color inactiveColor;

  /// Height of the indicator dots/pill. Defaults to `8.0`.
  final double dotHeight;

  /// Width of an inactive dot. Defaults to `8.0`.
  final double dotWidth;

  /// Width of the active elongated pill. Defaults to `28.0`.
  final double activeWidth;

  /// Spacing between dots. Defaults to `6.0`.
  final double spacing;

  /// Callback when an indicator dot is tapped.
  final ValueChanged<int>? onDotTapped;

  const LiquidPageIndicator({
    super.key,
    required this.count,
    required this.currentPage,
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0x66FFFFFF),
    this.dotHeight = 8.0,
    this.dotWidth = 8.0,
    this.activeWidth = 28.0,
    this.spacing = 6.0,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;

        return GestureDetector(
          onTap: () => onDotTapped?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            height: dotHeight,
            width: isActive ? activeWidth : dotWidth,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(dotHeight / 2),
            ),
          ),
        );
      }),
    );
  }
}
