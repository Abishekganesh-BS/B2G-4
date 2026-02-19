import 'package:flutter/material.dart';
import '../../theme.dart';

/// Atomic card component: 16dp radius, 0px 4px 12px rgba(0,0,0,0.05) shadow.
class NurtureCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool elevated;

  const NurtureCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius = 16,
    this.onTap,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? NurtureColors.surface;
    final resolvedRadius = BorderRadius.circular(borderRadius);

    return Container(
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: resolvedRadius,
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
        border: Border.all(color: NurtureColors.border, width: 0.5),
      ),
      child: onTap != null
          ? ClipRRect(
              borderRadius: resolvedRadius,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashColor: NurtureColors.primaryPink.withOpacity(0.2),
                  highlightColor: NurtureColors.primaryPink.withOpacity(0.1),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
    );
  }
}
