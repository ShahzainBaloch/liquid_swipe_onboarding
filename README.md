# liquid_swipe_onboarding

A modern, fluid liquid wave onboarding carousel for Flutter with real-time finger wave distortion, spring physics, and animated morphing indicators.

[![pub package](https://img.shields.io/pub/v/liquid_swipe_onboarding.svg)](https://pub.dev/packages/liquid_swipe_onboarding)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## ✨ Features

- 💧 **Organic Liquid Wave Transitions**: Touch-anchored cubic Bézier curves dynamically deform around your finger as you drag across the screen.
- 🚀 **Impeller & 120Hz Ready**: Smooth 60/120fps hardware-accelerated clipping path calculations with zero dropped frames.
- 💊 **Morphing Pill Indicator**: Built-in animated page indicator (`LiquidPageIndicator`) that morphs between dots and elongated active pills.
- 🎮 **Programmatic Control**: Navigate slides programmatically via `LiquidSwipeController` (`nextPage()`, `previousPage()`, `animateToPage()`).
- 🎨 **Fully Customizable**: Control skip buttons, get started actions, wave curves, and colors.
- 🧹 **Zero External Dependencies**: Pure Flutter SDK implementation.

---

## 🚀 Getting Started

Add `liquid_swipe_onboarding` to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_swipe_onboarding: ^1.0.0
```

Import the package:

```dart
import 'package:liquid_swipe_onboarding/liquid_swipe_onboarding.dart';
```

---

## 💡 Quick Example

```dart
final controller = LiquidSwipeController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: LiquidSwipeOnboarding(
      controller: controller,
      onCompleted: () => Navigator.pushReplacementNamed(context, '/home'),
      pages: [
        OnboardingSlide(
          color: Colors.indigo,
          title: 'Welcome to App',
          subtitle: 'Swipe horizontally to experience liquid wave transitions.',
        ),
        OnboardingSlide(
          color: Colors.teal,
          title: 'Fast & Fluid',
          subtitle: 'Designed specifically for modern mobile interfaces.',
        ),
        OnboardingSlide(
          color: Colors.pinkAccent,
          title: 'Ready to Explore',
          subtitle: 'Tap Get Started to begin your journey.',
        ),
      ],
    ),
  );
}
```

---

## 🛠️ Configuration Options

| Property | Type | Default | Description |
|---|---|---|---|
| `pages` | `List<Widget>` | **Required** | The list of slides to display. |
| `controller` | `LiquidSwipeController?` | `null` | Controller for programmatic page turns. |
| `showControls` | `bool` | `true` | Whether to display bottom indicators and navigation buttons. |
| `activeIndicatorColor` | `Color` | `Colors.white` | Color of the active morphing pill indicator. |
| `inactiveIndicatorColor` | `Color` | `0x66FFFFFF` | Color of inactive page dots. |
| `skipText` | `String` | `'Skip'` | Label for the skip button. |
| `finishText` | `String` | `'Get Started'` | Label for the final slide action button. |
| `onPageChanged` | `ValueChanged<int>?` | `null` | Fired whenever active slide index updates. |
| `onCompleted` | `VoidCallback?` | `null` | Fired when user taps finish button on last slide. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Copyright © 2026 [Shahzain Baloch](https://github.com/ShahzainBaloch).
