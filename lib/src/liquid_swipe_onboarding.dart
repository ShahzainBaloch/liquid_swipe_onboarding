import 'package:flutter/material.dart';
import 'liquid_page_indicator.dart';
import 'liquid_swipe_controller.dart';
import 'liquid_wave_clipper.dart';

/// A fluid liquid wave onboarding carousel widget.
class LiquidSwipeOnboarding extends StatefulWidget {
  /// The list of page widgets to display in sequence.
  final List<Widget> pages;

  /// Optional programmatic controller.
  final LiquidSwipeController? controller;

  /// Callback fired when the active page index changes.
  final ValueChanged<int>? onPageChanged;

  /// Whether to render the built-in bottom indicator and navigation controls.
  final bool showControls;

  /// Color for the active indicator pill.
  final Color activeIndicatorColor;

  /// Color for inactive indicator dots.
  final Color inactiveIndicatorColor;

  /// Callback when user reaches the last slide and taps complete / get started.
  final VoidCallback? onCompleted;

  /// Text for the skip button. Defaults to `'Skip'`.
  final String skipText;

  /// Text for the final finish button. Defaults to `'Get Started'`.
  final String finishText;

  const LiquidSwipeOnboarding({
    super.key,
    required this.pages,
    this.controller,
    this.onPageChanged,
    this.showControls = true,
    this.activeIndicatorColor = Colors.white,
    this.inactiveIndicatorColor = const Color(0x66FFFFFF),
    this.onCompleted,
    this.skipText = 'Skip',
    this.finishText = 'Get Started',
  }) : assert(pages.length > 0, 'LiquidSwipeOnboarding requires at least one page.');

  @override
  State<LiquidSwipeOnboarding> createState() => _LiquidSwipeOnboardingState();
}

class _LiquidSwipeOnboardingState extends State<LiquidSwipeOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Animation<double>? _waveAnimation;

  int _activeIndex = 0;
  int? _incomingIndex;
  double _waveProgress = 0.0;
  double _touchY = 300.0;
  bool _fromLeft = false;

  double _dragDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _animController.addListener(() {
      if (_waveAnimation != null) {
        setState(() {
          _waveProgress = _waveAnimation!.value;
        });
      }
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_waveProgress >= 0.99 && _incomingIndex != null) {
          setState(() {
            _activeIndex = _incomingIndex!;
            _incomingIndex = null;
            _waveProgress = 0.0;
          });
          widget.controller?.updatePage(_activeIndex);
          widget.onPageChanged?.call(_activeIndex);
        } else if (_waveProgress <= 0.01) {
          setState(() {
            _incomingIndex = null;
            _waveProgress = 0.0;
          });
        }
      }
    });

    widget.controller?.attach(
      initialPage: _activeIndex,
      animateToPage: _animateToPage,
    );
  }

  @override
  void didUpdateWidget(covariant LiquidSwipeOnboarding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(
        initialPage: _activeIndex,
        animateToPage: _animateToPage,
      );
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _animateToPage(int targetPage, {Duration? duration}) async {
    if (targetPage < 0 ||
        targetPage >= widget.pages.length ||
        targetPage == _activeIndex ||
        _animController.isAnimating) {
      return;
    }

    final isForward = targetPage > _activeIndex;
    setState(() {
      _incomingIndex = targetPage;
      _fromLeft = !isForward;
      _touchY = MediaQuery.of(context).size.height * 0.5;
      _waveProgress = 0.0;
    });

    if (duration != null) {
      _animController.duration = duration;
    } else {
      _animController.duration = const Duration(milliseconds: 550);
    }

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    await _animController.forward(from: 0.0);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (_animController.isAnimating) return;
    _dragDistance = 0.0;
    _touchY = details.localPosition.dy;
  }

  void _onHorizontalDragUpdate(
      DragUpdateDetails details, double screenWidth) {
    if (_animController.isAnimating) return;
    _dragDistance += details.primaryDelta ?? 0.0;
    _touchY = details.localPosition.dy;

    if (_dragDistance < 0) {
      // Swiping to next page
      if (_activeIndex < widget.pages.length - 1) {
        _incomingIndex = _activeIndex + 1;
        _fromLeft = false;
        setState(() {
          _waveProgress = (_dragDistance.abs() / screenWidth).clamp(0.0, 1.0);
        });
      }
    } else if (_dragDistance > 0) {
      // Swiping to previous page
      if (_activeIndex > 0) {
        _incomingIndex = _activeIndex - 1;
        _fromLeft = true;
        setState(() {
          _waveProgress = (_dragDistance / screenWidth).clamp(0.0, 1.0);
        });
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_animController.isAnimating || _incomingIndex == null) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final bool shouldComplete;

    if (!_fromLeft) {
      shouldComplete = _waveProgress > 0.25 || velocity < -400;
    } else {
      shouldComplete = _waveProgress > 0.25 || velocity > 400;
    }

    final target = shouldComplete ? 1.0 : 0.0;

    _waveAnimation = Tween<double>(
      begin: _waveProgress,
      end: target,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Gesture detector area
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details, screenWidth),
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Base Active Page
                  widget.pages[_activeIndex],

                  // Incoming Liquid Wave Page
                  if (_incomingIndex != null && _waveProgress > 0.0)
                    ClipPath(
                      clipper: LiquidWaveClipper(
                        progress: _waveProgress,
                        touchY: _touchY,
                        fromLeft: _fromLeft,
                      ),
                      child: widget.pages[_incomingIndex!],
                    ),
                ],
              ),
            ),

            // Controls Overlay
            if (widget.showControls) _buildControlsOverlay(),
          ],
        );
      },
    );
  }

  Widget _buildControlsOverlay() {
    final isLastPage = _activeIndex == widget.pages.length - 1;

    return Positioned(
      left: 24,
      right: 24,
      bottom: 40,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Skip button
            if (!isLastPage)
              TextButton(
                onPressed: () {
                  _animateToPage(widget.pages.length - 1);
                },
                child: Text(
                  widget.skipText,
                  style: TextStyle(
                    color: widget.activeIndicatorColor.withValues(alpha: 0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const SizedBox(width: 60),

            // Morphing indicator
            LiquidPageIndicator(
              count: widget.pages.length,
              currentPage: _activeIndex,
              activeColor: widget.activeIndicatorColor,
              inactiveColor: widget.inactiveIndicatorColor,
              onDotTapped: (index) => _animateToPage(index),
            ),

            // Next / Finish button
            if (!isLastPage)
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: widget.activeIndicatorColor,
                  foregroundColor: Colors.black87,
                ),
                onPressed: () => _animateToPage(_activeIndex + 1),
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
              )
            else
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: widget.activeIndicatorColor,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                onPressed: widget.onCompleted,
                child: Text(
                  widget.finishText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
