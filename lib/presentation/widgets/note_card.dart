import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  /// Determines if the background color is light or dark
  /// Returns true if the color is light (needs dark text)
  bool _isLightColor(Color color) {
    // Calculate relative luminance
    final luminance = color.computeLuminance();
    // Threshold of 0.5 - colors with luminance > 0.5 are considered light
    return luminance > 0.5;
  }

  /// Gets the appropriate text color based on background
  Color _getTextColor(BuildContext context) {
    final backgroundColor = Color(note.color);
    final isLight = _isLightColor(backgroundColor);

    // Use dark text on light backgrounds, light text on dark backgrounds
    return isLight ? Colors.black87 : Colors.white.withValues(alpha: 0.95);
  }

  /// Gets the appropriate secondary text color
  Color _getSecondaryTextColor(BuildContext context) {
    final backgroundColor = Color(note.color);
    final isLight = _isLightColor(backgroundColor);

    return isLight ? Colors.black54 : Colors.white.withValues(alpha: 0.7);
  }

  /// Gets the appropriate icon color
  Color _getIconColor(BuildContext context) {
    final backgroundColor = Color(note.color);
    final isLight = _isLightColor(backgroundColor);

    return isLight ? Colors.black45 : Colors.white.withValues(alpha: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = _getTextColor(context);
    final secondaryTextColor = _getSecondaryTextColor(context);
    final iconColor = _getIconColor(context);

    return Card(
      color: Color(note.color),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pin indicator
              if (note.isPinned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.push_pin, size: 16, color: iconColor),
                      const Spacer(),
                    ],
                  ),
                ),

              // Title
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Content
              Text(
                note.content,
                style: textTheme.bodyMedium?.copyWith(
                  color: textColor.withValues(alpha: 0.9),
                  height: 1.5,
                ),
                maxLines: note.title.isEmpty ? 10 : 7,
                overflow: TextOverflow.ellipsis,
              ),

              // Labels
              if (note.labels.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.labels.take(3).map((label) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        style: textTheme.labelSmall?.copyWith(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Timestamp
              const SizedBox(height: 8),
              Text(
                _formatDate(note.updatedAt),
                style: textTheme.labelSmall?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(date);
    } else if (date.year == now.year) {
      return DateFormat('MMM d').format(date);
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
