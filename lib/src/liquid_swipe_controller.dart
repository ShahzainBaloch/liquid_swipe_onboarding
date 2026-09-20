import 'package:flutter/foundation.dart';

typedef AnimateToPageCallback = Future<void> Function(int page,
    {Duration? duration});

/// Programmatic controller for navigating pages in a [LiquidSwipeOnboarding] widget.
class LiquidSwipeController extends ChangeNotifier {
  int _currentPage = 0;
  AnimateToPageCallback? _animateToPage;

  /// The index of the currently active onboarding page.
  int get currentPage => _currentPage;

  /// Internal attachment hook called by the stateful widget.
  void attach({
    required int initialPage,
    required AnimateToPageCallback animateToPage,
  }) {
    _currentPage = initialPage;
    _animateToPage = animateToPage;
  }

  /// Internal detachment hook.
  void detach() {
    _animateToPage = null;
  }

  /// Updates the current page internally.
  void updatePage(int page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }

  /// Animates forward to the next onboarding slide.
  Future<void> nextPage({Duration? duration}) async {
    if (_animateToPage != null) {
      await _animateToPage!(_currentPage + 1, duration: duration);
    }
  }

  /// Animates backward to the previous onboarding slide.
  Future<void> previousPage({Duration? duration}) async {
    if (_animateToPage != null && _currentPage > 0) {
      await _animateToPage!(_currentPage - 1, duration: duration);
    }
  }

  /// Animates directly to the specified target page index.
  Future<void> animateToPage(int page, {Duration? duration}) async {
    if (_animateToPage != null) {
      await _animateToPage!(page, duration: duration);
    }
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }
}
