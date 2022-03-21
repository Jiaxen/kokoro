import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kokoro/app/login/login_screen.dart';
import 'package:kokoro/app/screens/empty_content.dart';
import 'package:kokoro/app/screens/notes_screen.dart';
import 'package:kokoro/app/screens/onboarding.dart';
import 'package:kokoro/routing/app_router.dart';
import 'package:kokoro/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/auth_widget.dart';
import 'app/top_level_providers.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope( //In Riverpod, ProviderScope stores the state of all the providers
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child!,
        );
      },
      home: AuthWidget(
        nonSignedInBuilder: (_) => LoginScreen(),
        signedInBuilder: (_) => OnboardingCheck(ref),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings),
    );
  }

  Widget OnboardingCheck(WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    return userAsyncValue.when(
      data: (user) => user.currentGroup == null
          ? OnboardingPage()
          : NotesScreen(user),
      loading: () => EmptyContent(),
      error: (_, __) => EmptyContent(),
    );
  }
}


class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {
    return child;
  }
}
