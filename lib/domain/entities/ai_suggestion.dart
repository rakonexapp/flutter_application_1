/// AI-generated suggestion entity
class AISuggestion {
  final String type; // summary, labels, improvement, actions, etc.
  final String content;
  final List<String>? suggestions;
  final DateTime timestamp;

  const AISuggestion({
    required this.type,
    required this.content,
    this.suggestions,
    required this.timestamp,
  });

  factory AISuggestion.summary(String summary) {
    return AISuggestion(
      type: 'summary',
      content: summary,
      timestamp: DateTime.now(),
    );
  }

  factory AISuggestion.labels(List<String> labels) {
    return AISuggestion(
      type: 'labels',
      content: '',
      suggestions: labels,
      timestamp: DateTime.now(),
    );
  }

  factory AISuggestion.improvement(String improvedText) {
    return AISuggestion(
      type: 'improvement',
      content: improvedText,
      timestamp: DateTime.now(),
    );
  }

  factory AISuggestion.actions(List<String> actionItems) {
    return AISuggestion(
      type: 'actions',
      content: '',
      suggestions: actionItems,
      timestamp: DateTime.now(),
    );
  }
}
