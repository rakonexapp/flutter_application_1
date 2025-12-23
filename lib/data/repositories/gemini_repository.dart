import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/config/gemini_config.dart';
import '../../domain/entities/ai_suggestion.dart';

/// Repository for Gemini AI operations using SDK
class GeminiRepository {
  // We don't cache the model instance because we want to ensure fresh config if env changes
  // but typically we can. For simple implementation let's get it fresh or lazily.

  GenerativeModel get _model => GeminiConfig.getModel();

  /// Generate a summary of the note content
  Future<AISuggestion> generateSummary(String content) async {
    try {
      final prompt =
          '''
Summarize the following note in 2-3 concise sentences. Focus on the main points and key information.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final summary = response.text?.trim() ?? 'Could not generate summary';

      return AISuggestion.summary(summary);
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }

  /// Suggest relevant labels/tags for the note
  Future<AISuggestion> suggestLabels(String content) async {
    try {
      final prompt =
          '''
Analyze this note and suggest 3-5 relevant labels or tags. Return ONLY the labels as a comma-separated list, nothing else:

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final labelsText = response.text?.trim() ?? '';

      // Parse comma-separated labels
      final labels = labelsText
          .split(',')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      return AISuggestion.labels(labels);
    } catch (e) {
      throw Exception('Failed to suggest labels: $e');
    }
  }

  /// Improve the writing quality
  Future<AISuggestion> improveWriting(
    String content, {
    String style = 'clear',
  }) async {
    try {
      final prompt =
          '''
Improve the clarity and grammar of this text. Make it more $style while preserving the original meaning.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final improved = response.text?.trim() ?? content;

      return AISuggestion.improvement(improved);
    } catch (e) {
      throw Exception('Failed to improve writing: $e');
    }
  }

  /// Expand brief text with more details
  Future<AISuggestion> expandText(String content) async {
    try {
      final prompt =
          '''
Expand this brief note with more details and context while staying relevant to the original content.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final expanded = response.text?.trim() ?? content;

      return AISuggestion.improvement(expanded);
    } catch (e) {
      throw Exception('Failed to expand text: $e');
    }
  }

  /// Shorten verbose text
  Future<AISuggestion> shortenText(String content) async {
    try {
      final prompt =
          '''
Make this text more concise while keeping all important information.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final shortened = response.text?.trim() ?? content;

      return AISuggestion.improvement(shortened);
    } catch (e) {
      throw Exception('Failed to shorten text: $e');
    }
  }

  /// Change the tone of the text
  Future<AISuggestion> changeTone(String content, String tone) async {
    try {
      final prompt =
          '''
Rewrite this text in a $tone tone while preserving the original meaning.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final rewritten = response.text?.trim() ?? content;

      return AISuggestion.improvement(rewritten);
    } catch (e) {
      throw Exception('Failed to change tone: $e');
    }
  }

  /// Extract action items and TODOs
  Future<AISuggestion> extractActionItems(String content) async {
    try {
      final prompt =
          '''
Extract all action items, tasks, and TODOs from this note. Return them as a bullet list, one item per line starting with "- ":

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final actionsText = response.text?.trim() ?? '';

      // Parse bullet list
      final actions = actionsText
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.startsWith('-') || l.startsWith('•'))
          .map((l) => l.substring(1).trim())
          .where((l) => l.isNotEmpty)
          .toList();

      return AISuggestion.actions(actions);
    } catch (e) {
      throw Exception('Failed to extract action items: $e');
    }
  }

  /// Fix grammar and spelling
  Future<AISuggestion> fixGrammar(String content) async {
    try {
      final prompt =
          '''
Fix all grammar and spelling errors in this text.
Return ONLY plain text without any markdown formatting, asterisks, or special characters.

$content
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final corrected = response.text?.trim() ?? content;

      return AISuggestion.improvement(corrected);
    } catch (e) {
      throw Exception('Failed to fix grammar: $e');
    }
  }
}
