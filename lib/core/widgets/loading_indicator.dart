import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double blurSigma;

  const LoadingIndicator({
    super.key,
    required this.child,
    required this.isLoading,
    this.blurSigma = 5.0, // Default blur value
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Child content, e.g. the form and other widgets
        child,

        // Display loading spinner and blur effect if `isLoading` is true
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Stack(
                children: [
                  // Background blur
                  BackdropFilter(
                    filter:
                        ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  // Centered spinner
                  const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
