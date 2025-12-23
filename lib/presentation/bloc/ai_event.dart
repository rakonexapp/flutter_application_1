/// AI Events
abstract class AIEvent {}

class GenerateSummaryEvent extends AIEvent {
  final String content;
  GenerateSummaryEvent(this.content);
}

class SuggestLabelsEvent extends AIEvent {
  final String content;
  SuggestLabelsEvent(this.content);
}

class ImproveWritingEvent extends AIEvent {
  final String content;
  final String style;
  ImproveWritingEvent(this.content, {this.style = 'clear'});
}

class ExpandTextEvent extends AIEvent {
  final String content;
  ExpandTextEvent(this.content);
}

class ShortenTextEvent extends AIEvent {
  final String content;
  ShortenTextEvent(this.content);
}

class ChangeToneEvent extends AIEvent {
  final String content;
  final String tone;
  ChangeToneEvent(this.content, this.tone);
}

class ExtractActionItemsEvent extends AIEvent {
  final String content;
  ExtractActionItemsEvent(this.content);
}

class FixGrammarEvent extends AIEvent {
  final String content;
  FixGrammarEvent(this.content);
}

class ClearAISuggestionEvent extends AIEvent {}
