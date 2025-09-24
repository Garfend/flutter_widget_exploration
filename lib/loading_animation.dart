import 'package:flutter/material.dart';

class LoadingDotsAnimation extends StatefulWidget {
  const LoadingDotsAnimation({super.key});

  @override
  State<LoadingDotsAnimation> createState() => _LoadingDotsAnimationState();
}

class _LoadingDotsAnimationState extends State<LoadingDotsAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  )..repeat();

  static const _dotCount = 3;
  static const _dotDelay = 0.2; // delay between dots

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _buildDotAnimation(int index, {required bool forScale}) {
    final start = index * _dotDelay;
    final end = start + 0.6;
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeInOut),
    );
    return Tween<double>(begin: forScale ? 0.6 : 0.0, end: 1.0).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Animation')),
      body: Center(
        child: SizedBox(
          height: 40,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_dotCount, (i) {
                    final scale = _buildDotAnimation(i, forScale: true).value;
                    final opacity = _buildDotAnimation(
                      i,
                      forScale: false,
                    ).value;
                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
