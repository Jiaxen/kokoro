import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kokoro/app/onboarding/onboarding_page.dart';
import 'package:kokoro/app/onboarding/onboarding_view_model.dart';
import 'package:kokoro/app/login/login_screen.dart';
import 'package:kokoro/app/screens/notes_screen.dart';
import 'package:kokoro/routing/app_router.dart';
import 'package:kokoro/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/auth_widget.dart';
import 'app/top_level_providers.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
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
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child!,
        );
      },
      home: AuthWidget(
        nonSignedInBuilder: (_) =>
            Consumer(
              builder: (context, ref, _) {
                final didCompleteOnboarding =
                ref.watch(onboardingViewModelProvider);
                return didCompleteOnboarding ? LoginScreen() : OnboardingPage();
              },
            ),
        signedInBuilder: (_) => NotesScreen(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
//    // Provider of Firebase user at the top of the app tree
//     return MultiProvider(
//         providers: [
//           FirebaseUserStream(),
//           AppUserStream(),
//           GroupStream(),
//         ],
//         child: Builder(builder: (context) {
//           final user = Provider.of<User?>(context);
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             builder: (context, child) {
//               return ScrollConfiguration(
//                 behavior: NoGlowScrollBehavior(),
//                 child: child!,
//               );
//             },
//             home: (user == null) ? const LoginScreen() : const NotesScreen(),
//             routes: {
//               LoginScreen.id: (context) => const LoginScreen(),
//               NotesScreen.id: (context) => const NotesScreen(),
//               FindPartnerScreen.id: (context) => const FindPartnerScreen(),
//             },
//           );
//         }));

//   StreamProvider<User?> FirebaseUserStream() {
//     return StreamProvider<User?>.value(
//         value: FirebaseAuth.instance.authStateChanges(),
//         initialData: FirebaseAuth.instance.currentUser);
//   }
//
//   StreamProvider<Group> GroupStream() {
//     return StreamProvider<Group>(
//       create: (context) {
//         String? appUserGroup = Provider
//             .of<AppUser>(context, listen: false)
//             .currentGroup;
//         print(appUserGroup);
//         return groupCollection()
//             .doc(appUserGroup)
//             .snapshots()
//             .map((snapshot) => documentSnapshotToGroup(snapshot));
//       },
//       initialData: Group.initial,
//     );
//   }
//
//   StreamProvider<AppUser> AppUserStream() {
//     return StreamProvider<AppUser>(
//         create: (context) =>
//             userCollection()
//                 .doc(Provider
//                 .of<User?>(context, listen: false)
//                 ?.uid)
//                 .snapshots()
//                 .map((snapshot) => documentSnapshotToAppUser(snapshot)),
//         initialData: AppUser.initial);
//   }
// }

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {
    return child;
  }
}
