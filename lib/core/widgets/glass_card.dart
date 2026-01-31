import 'package:flutter/material.dart';
import 'dart:ui';

/// Enhanced glass morphism card widget with premium blur and gradient effects
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? borderGradient;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double blurIntensity;
  
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.backgroundColor,
    this.borderColor,
    this.borderGradient,
    this.boxShadow,
    this.padding,
    this.width,
    this.height,
    this.blurIntensity = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: boxShadow,
          ),
          child: borderGradient != null
              ? _buildWithGradientBorder()
              : _buildWithSolidBorder(),
        ),
      ),
    );
  }

  Widget _buildWithGradientBorder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: borderGradient,
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5), // Border width
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius - 1),
        ),
        child: child,
      ),
    );
  }

  Widget _buildWithSolidBorder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
