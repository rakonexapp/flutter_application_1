import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'core/config/gemini_config.dart';
import 'injection_container.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GeminiConfig.initialize();

  await InjectionContainer.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Use dynamic colors if available (Android 12+), otherwise use app theme
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // Dynamic colors available
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Fallback to app's color scheme
          lightColorScheme = AppTheme.lightColorScheme;
          darkColorScheme = AppTheme.darkColorScheme;
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => InjectionContainer.noteBloc),
            BlocProvider(create: (context) => InjectionContainer.aiBloc),
          ],
          child: MaterialApp(
            title: 'Notes',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme.copyWith(colorScheme: lightColorScheme),
            darkTheme: AppTheme.darkTheme.copyWith(
              colorScheme: darkColorScheme,
            ),
            themeMode: ThemeMode.system, // Follow system theme
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
