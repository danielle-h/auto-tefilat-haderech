import 'package:flutter/material.dart';

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    super.key,
    required this.animation,
    required this.slide,
    required this.child,
  });

  final Animation<double> animation;
  final double slide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          return Transform(
              transform: Matrix4.translationValues(
                  0, (1.0 - animation.value) * slide, 0),
              child: child);
        });
  }
}
