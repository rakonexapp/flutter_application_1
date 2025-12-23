import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../bloc/ai_bloc.dart';
import '../bloc/ai_event.dart';
import '../bloc/ai_state.dart';

class AIAssistantSheet extends StatelessWidget {
  final String noteContent;
  final Function(String)? onApplyText;
  final ScrollController? scrollController;

  const AIAssistantSheet({
    super.key,
    required this.noteContent,
    this.onApplyText,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Assistant',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Powered by Gemini',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // AI State Display
          BlocBuilder<AIBloc, AIState>(
            builder: (context, state) {
              if (state is AILoading) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildLoadingState(context, state.message),
                );
              } else if (state is AISuggestionReady) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildResultState(context, state),
                  ),
                );
              } else if (state is AIError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildErrorState(context, state.message),
                );
              }
              return _buildOptionsGrid(context);
            },
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final options = [
      _OptionData(
        icon: Icons.summarize_outlined,
        title: 'Summarize',
        subtitle: 'Quick summary',
        color: colorScheme.primary,
        onTap: () =>
            context.read<AIBloc>().add(GenerateSummaryEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.label_outline,
        title: 'Suggest labels',
        subtitle: 'Auto tags',
        color: colorScheme.secondary,
        onTap: () =>
            context.read<AIBloc>().add(SuggestLabelsEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.edit_outlined,
        title: 'Improve',
        subtitle: 'Better writing',
        color: colorScheme.tertiary,
        onTap: () =>
            context.read<AIBloc>().add(ImproveWritingEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.unfold_more,
        title: 'Expand',
        subtitle: 'Add details',
        color: colorScheme.primary,
        onTap: () => context.read<AIBloc>().add(ExpandTextEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.unfold_less,
        title: 'Shorten',
        subtitle: 'Make concise',
        color: colorScheme.secondary,
        onTap: () => context.read<AIBloc>().add(ShortenTextEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.checklist,
        title: 'Action items',
        subtitle: 'Extract TODOs',
        color: colorScheme.tertiary,
        onTap: () =>
            context.read<AIBloc>().add(ExtractActionItemsEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.spellcheck,
        title: 'Fix grammar',
        subtitle: 'Correct errors',
        color: colorScheme.primary,
        onTap: () => context.read<AIBloc>().add(FixGrammarEvent(noteContent)),
      ),
      _OptionData(
        icon: Icons.sentiment_satisfied_outlined,
        title: 'Change tone',
        subtitle: 'Professional',
        color: colorScheme.secondary,
        onTap: () => context.read<AIBloc>().add(
          ChangeToneEvent(noteContent, 'professional'),
        ),
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: options
            .asMap()
            .entries
            .map((entry) => _buildOptionCard(context, entry.value, entry.key))
            .toList(),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, _OptionData data, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: data.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(data.icon, size: 32, color: data.color),
                  const SizedBox(height: 12),
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (50 + index * 30).ms, duration: 300.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildLoadingState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(BuildContext context, AISuggestionReady state) {
    final suggestion = state.suggestion;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Result header
        Row(
              children: [
                Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Result',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<AIBloc>().add(ClearAISuggestionEvent());
                  },
                  tooltip: 'Back to options',
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 200.ms)
            .slideX(begin: -0.1, end: 0, duration: 300.ms),
        const SizedBox(height: 16),

        // Result content
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (suggestion.type == 'labels' &&
                      suggestion.suggestions != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: suggestion.suggestions!.asMap().entries.map((
                        entry,
                      ) {
                        return Chip(
                              label: Text(entry.value),
                              backgroundColor: colorScheme.secondaryContainer,
                              labelStyle: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                              ),
                              side: BorderSide.none,
                            )
                            .animate()
                            .fadeIn(
                              delay: (entry.key * 50).ms,
                              duration: 200.ms,
                            )
                            .scale(
                              delay: (entry.key * 50).ms,
                              duration: 200.ms,
                            );
                      }).toList(),
                    )
                  else if (suggestion.type == 'actions' &&
                      suggestion.suggestions != null)
                    ...suggestion.suggestions!.asMap().entries.map((entry) {
                      return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_box_outline_blank,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (entry.key * 50).ms, duration: 200.ms)
                          .slideX(
                            begin: -0.1,
                            end: 0,
                            delay: (entry.key * 50).ms,
                            duration: 200.ms,
                          );
                    })
                  else
                    MarkdownBody(
                      data: suggestion.content,
                      styleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyMedium,
                        h1: Theme.of(context).textTheme.titleLarge,
                        h2: Theme.of(context).textTheme.titleMedium,
                        h3: Theme.of(context).textTheme.titleSmall,
                        listBullet: Theme.of(context).textTheme.bodyMedium,
                      ),
                      selectable: true,
                    ).animate().fadeIn(duration: 300.ms),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 300.ms)
            .slideY(begin: 0.05, end: 0, duration: 300.ms),
        const SizedBox(height: 16),

        // Action buttons
        Row(
              children: [
                if (suggestion.type != 'labels' && suggestion.type != 'actions')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: suggestion.content),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (suggestion.type != 'labels' && suggestion.type != 'actions')
                  const SizedBox(width: 12),
                if (onApplyText != null &&
                    suggestion.type != 'labels' &&
                    suggestion.type != 'actions')
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        onApplyText!(suggestion.content);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Apply'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 200.ms)
            .slideY(begin: 0.1, end: 0, duration: 300.ms),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error)
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(delay: 100.ms, duration: 300.ms),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ).animate().fadeIn(delay: 200.ms, duration: 200.ms),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms, duration: 200.ms),
            const SizedBox(height: 24),
            FilledButton.icon(
                  onPressed: () {
                    context.read<AIBloc>().add(ClearAISuggestionEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 200.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}

class _OptionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _OptionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
