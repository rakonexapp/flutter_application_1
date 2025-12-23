import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
                Icons.lightbulb_outline,
                size: 120,
                color: colorScheme.primary.withValues(alpha: 0.3),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.5, 0.5),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
              .then(delay: 200.ms)
              .shimmer(
                duration: 2000.ms,
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
          const SizedBox(height: 24),
          Text(
                'Notes you add appear here',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.2, delay: 300.ms, duration: 500.ms),
        ],
      ),
    );
  }
}
