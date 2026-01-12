import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

/// Provides the soft gradient backdrop used across primary surfaces.
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    // Adjust glow circle size based on screen size
    final isSmallScreen = screenWidth < 480;
    final glowSize1 = isSmallScreen ? 200.0 : 260.0;
    final glowSize2 = isSmallScreen ? 180.0 : 220.0;
    final glowSize3 = isSmallScreen ? 220.0 : 280.0;
    
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withValues(alpha: 0.12),
              scheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -80,
              child: _GlowCircle(
                color: scheme.primary.withValues(alpha: 0.22),
                diameter: glowSize1,
              ),
            ),
            Positioned(
              top: 160,
              left: -100,
              child: _GlowCircle(
                color: scheme.secondary.withValues(alpha: 0.18),
                diameter: glowSize2,
              ),
            ),
            Positioned(
              bottom: -140,
              right: -100,
              child: _GlowCircle(
                color: scheme.tertiary.withValues(alpha: 0.14),
                diameter: glowSize3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.color,
    required this.diameter,
  });

  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: diameter / 2,
              spreadRadius: diameter / 4,
            ),
          ],
        ),
      );
}

/// Shared wrapper that keeps page content padded within the gradient shell.
class AppPageContainer extends StatelessWidget {
  const AppPageContainer({
    super.key,
    required this.child,
    this.topPadding,
    this.horizontalPadding,
    this.bottomPadding,
  });

  final Widget child;
  final double? topPadding;
  final double? horizontalPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    // Use responsive padding if not explicitly provided
    final responsiveHorizontal = horizontalPadding ?? 
        ResponsiveUtils.horizontalPadding(context);
    final responsiveTop = topPadding ?? 
        ResponsiveUtils.verticalPadding(context);
    final responsiveBottom = bottomPadding ?? 
        ResponsiveUtils.verticalPadding(context);
    
    return Stack(
      children: [
        const AppGradientBackground(),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              responsiveHorizontal,
              responsiveTop,
              responsiveHorizontal,
              responsiveBottom,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Primary surface block with consistent shadow, border, and padding.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final borderRadius = ResponsiveUtils.borderRadius(context);
    
    // Use responsive padding if not provided
    final cardPadding = padding ?? 
        EdgeInsets.all(ResponsiveUtils.spacing(context));
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null
            ? scheme.surface.withValues(alpha: 0.92)
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );
  }
}

/// Spacer helper to maintain vertical rhythm across sections.
class SectionGap extends StatelessWidget {
  const SectionGap.small({super.key}) : size = 12;
  const SectionGap.medium({super.key}) : size = 20;
  const SectionGap.large({super.key}) : size = 28;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}
