import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme.dart';

/// A rectangular shimmer box for skeleton loading states.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NurtureColors.primaryPink.withOpacity(0.25),
      highlightColor: NurtureColors.primaryPink.withOpacity(0.55),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: NurtureColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Full-screen shimmer skeleton that mirrors the dashboard layout.
class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NurtureColors.primaryPink.withOpacity(0.22),
      highlightColor: NurtureColors.primaryPink.withOpacity(0.50),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Nest card skeleton
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: NurtureColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 24),
            // Section title
            Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: NurtureColors.surface,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),
            // Grid cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: List.generate(
                4,
                (_) => Container(
                  decoration: BoxDecoration(
                    color: NurtureColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // AI insight card skeleton
            Container(
              height: 96,
              decoration: BoxDecoration(
                color: NurtureColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer card for list-based screens.
class ShimmerListCard extends StatelessWidget {
  const ShimmerListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NurtureColors.primaryPink.withOpacity(0.22),
      highlightColor: NurtureColors.primaryPink.withOpacity(0.50),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: NurtureColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
