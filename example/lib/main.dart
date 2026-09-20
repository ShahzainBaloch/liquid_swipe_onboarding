import 'package:flutter/material.dart';
import 'package:liquid_swipe_onboarding/liquid_swipe_onboarding.dart';

void main() {
  runApp(const LiquidSwipeExampleApp());
}

class LiquidSwipeExampleApp extends StatelessWidget {
  const LiquidSwipeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Liquid Swipe Onboarding Demo',
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LiquidSwipeController _controller = LiquidSwipeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipeOnboarding(
        controller: _controller,
        onCompleted: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome aboard! Onboarding complete.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        pages: [
          _buildPage(
            backgroundColor: const Color(0xFF4F46E5), // Indigo
            icon: Icons.auto_awesome,
            title: 'Fluid Experience',
            description:
                'Drag horizontally anywhere on screen to feel the organic liquid wave distortion in real time.',
          ),
          _buildPage(
            backgroundColor: const Color(0xFF0D9488), // Teal
            icon: Icons.bolt,
            title: 'Impeller Optimized',
            description:
                'Built specifically for modern 60/120fps Flutter pipelines with zero jank and fluid spring physics.',
          ),
          _buildPage(
            backgroundColor: const Color(0xFFE11D48), // Rose
            icon: Icons.rocket_launch,
            title: 'Production Ready',
            description:
                'Includes morphing pill indicators, controller hooks, and zero external runtime dependencies.',
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Color backgroundColor,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 54, color: Colors.white),
            ),
            const SizedBox(height: 48),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
