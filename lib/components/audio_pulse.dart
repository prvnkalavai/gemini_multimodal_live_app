import 'package:flutter/material.dart';

class AudioPulse extends StatelessWidget {
  final double volume;
  final bool active;
  final bool hover;

  const AudioPulse({
    super.key,
    required this.volume,
    required this.active,
    this.hover = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? Colors.blue.withValues(blue: 0.2)
            : Colors.grey.withValues(alpha: 0.2),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 8 + (volume * 20),
          height: 8 + (volume * 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}
