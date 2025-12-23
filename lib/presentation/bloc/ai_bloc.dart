import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/gemini_repository.dart';
import 'ai_event.dart';
import 'ai_state.dart';

/// BLoC for AI operations
class AIBloc extends Bloc<AIEvent, AIState> {
  final GeminiRepository _geminiRepository;

  AIBloc(this._geminiRepository) : super(AIInitial()) {
    on<GenerateSummaryEvent>(_onGenerateSummary);
    on<SuggestLabelsEvent>(_onSuggestLabels);
    on<ImproveWritingEvent>(_onImproveWriting);
    on<ExpandTextEvent>(_onExpandText);
    on<ShortenTextEvent>(_onShortenText);
    on<ChangeToneEvent>(_onChangeTone);
    on<ExtractActionItemsEvent>(_onExtractActionItems);
    on<FixGrammarEvent>(_onFixGrammar);
    on<ClearAISuggestionEvent>(_onClearSuggestion);
  }

  Future<void> _onGenerateSummary(
    GenerateSummaryEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Generating summary...'));
    try {
      final suggestion = await _geminiRepository.generateSummary(event.content);
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to generate summary: ${e.toString()}'));
    }
  }

  Future<void> _onSuggestLabels(
    SuggestLabelsEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Suggesting labels...'));
    try {
      final suggestion = await _geminiRepository.suggestLabels(event.content);
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to suggest labels: ${e.toString()}'));
    }
  }

  Future<void> _onImproveWriting(
    ImproveWritingEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Improving writing...'));
    try {
      final suggestion = await _geminiRepository.improveWriting(
        event.content,
        style: event.style,
      );
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to improve writing: ${e.toString()}'));
    }
  }

  Future<void> _onExpandText(
    ExpandTextEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Expanding text...'));
    try {
      final suggestion = await _geminiRepository.expandText(event.content);
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to expand text: ${e.toString()}'));
    }
  }

  Future<void> _onShortenText(
    ShortenTextEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Shortening text...'));
    try {
      final suggestion = await _geminiRepository.shortenText(event.content);
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to shorten text: ${e.toString()}'));
    }
  }

  Future<void> _onChangeTone(
    ChangeToneEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Changing tone...'));
    try {
      final suggestion = await _geminiRepository.changeTone(
        event.content,
        event.tone,
      );
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to change tone: ${e.toString()}'));
    }
  }

  Future<void> _onExtractActionItems(
    ExtractActionItemsEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Extracting action items...'));
    try {
      final suggestion = await _geminiRepository.extractActionItems(
        event.content,
      );
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to extract action items: ${e.toString()}'));
    }
  }

  Future<void> _onFixGrammar(
    FixGrammarEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(AILoading(message: 'Fixing grammar...'));
    try {
      final suggestion = await _geminiRepository.fixGrammar(event.content);
      emit(AISuggestionReady(suggestion));
    } catch (e) {
      emit(AIError('Failed to fix grammar: ${e.toString()}'));
    }
  }

  void _onClearSuggestion(ClearAISuggestionEvent event, Emitter<AIState> emit) {
    emit(AIInitial());
  }
}
