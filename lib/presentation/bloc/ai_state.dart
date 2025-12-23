import '../../domain/entities/ai_suggestion.dart';

/// AI States
abstract class AIState {}

class AIInitial extends AIState {}

class AILoading extends AIState {
  final String message;
  AILoading({this.message = 'AI is thinking...'});
}

class AISuggestionReady extends AIState {
  final AISuggestion suggestion;
  AISuggestionReady(this.suggestion);
}

class AIError extends AIState {
  final String message;
  AIError(this.message);
}
