import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration for Gemini AI using SDK
class GeminiConfig {
  static String get apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static bool get isConfigured =>
      apiKey.isNotEmpty && apiKey != 'your_api_key_here';

  /// Get Gemini model instance
  static GenerativeModel getModel() {
    if (!isConfigured) {
      throw Exception(
        'Gemini API key not configured. Please add your API key to .env file',
      );
    }

    return GenerativeModel(
      // model: 'gemini-1.5-flash',
      model: "gemini-2.5-flash",

      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  /// Initialize dotenv
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      print('Warning: Could not load .env file: $e');
    }
  }
}
