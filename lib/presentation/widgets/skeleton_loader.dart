import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width ?? double.infinity,
      height: height ?? 20,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: theme.colorScheme.surface.withAlpha(150),
        )
        .fadeIn(duration: 300.ms);
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) => const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(width: 120, height: 16),
            SizedBox(height: 12),
            SkeletonLoader(height: 24),
            SizedBox(height: 8),
            SkeletonLoader(height: 16),
            SizedBox(height: 16),
            Row(
              children: [
                SkeletonLoader(width: 80, height: 16),
                Spacer(),
                SkeletonLoader(width: 60, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) => const ListTile(
      leading: SkeletonLoader(
        width: 48,
        height: 48,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      title: SkeletonLoader(height: 16),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 8),
        child: SkeletonLoader(height: 12),
      ),
      trailing: SkeletonLoader(width: 60, height: 16),
    );
}

